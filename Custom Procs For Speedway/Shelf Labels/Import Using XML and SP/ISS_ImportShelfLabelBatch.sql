USE [bcssa_cert]
GO

/****** Object:  StoredProcedure [dbo].[ISS_ImportShelfLabelBatch]    Script Date: 11/15/2018 10:40:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--
--   ISS_ImportShelfLabelBatch
--
--   Called from the ISS Import WaveDO this procedure is responsible
--   for creating a new enterprise transaction with the contents of
--   a passed XML document.
--
--

CREATE  PROCEDURE [dbo].[ISS_ImportShelfLabelBatch]
@buid     AS int,
@clientId AS int,
@XMLInput AS NTEXT

AS
SET NOCOUNT ON 

--
--   Internal Declarations, Variables and Tables.
--
DECLARE @existing_Shelf_Label_batch_id INT
DECLARE @header_ticket                 INT
DECLARE @idoc                          INT
DECLARE @inputStatusCode               NCHAR
DECLARE @processItems                  NCHAR

--
--   Load XML content into temporary tables.
--
EXEC sp_xml_preparedocument @idoc OUTPUT, @XMLInput

INSERT INTO #ImportedShelfLabelHeader
SELECT      *
FROM        OPENXML ( @idoc, '//ShelfLabelBatch' ) with #ImportedShelfLabelHeader

INSERT INTO #ImportedShelfLabelItems
SELECT      *
FROM        OPENXML ( @idoc, '//ShelfLabelBatchRMI' ) with #ImportedShelfLabelItems

--
--   Prepare Header and Detail items for insert into enterprise.
--
SELECT  @inputStatusCode = ( SELECT ImportedShelfLabelHeader.status_code
                             FROM   #ImportedShelfLabelHeader ImportedShelfLabelHeader WITH (NOLOCK)
                           )
--
--    Initialize Global Variables
--
SELECT @processItems  = 'n'
--
--   Determine if there is an open Shelf Label Batch for this Business Unit
--
SELECT @existing_Shelf_Label_batch_id = ( SELECT     ShelfLabelBatch.shelf_label_batch_id
                                          FROM       Shelf_Label_Batch ShelfLabelBatch WITH (NOLOCK)
                                          WHERE      ShelfLabelBatch.business_unit_id = @buid
                                                     AND ShelfLabelBatch.client_id = @clientId
                                                     AND ShelfLabelBatch.status_code = 'o'
                                    )

IF @existing_Shelf_Label_batch_id IS NULL
BEGIN
  IF @inputStatusCode <> 'x'
  BEGIN
    SELECT  @processItems = 'y'
    --
    --    Acquire EP Ticket Number for Transaction Header
    --
    EXEC @header_ticket = plt_get_next_named_ticket 'Shelf_Label_Batch', 'n', 1

    SELECT @existing_Shelf_Label_batch_id = ( SELECT @header_ticket )
    --
    --    Alrighty then, It's Showtime, Process the Document Header
    --
    INSERT INTO Shelf_Label_Batch
    (
      business_unit_id,
      client_id,
      last_modified_timestamp,
      last_modified_user_id,
      shelf_label_batch_id,
      status_code
    )
    SELECT @buid AS business_unit_id,
           @clientId AS client_id,
           GETDATE() AS last_modified_timestamp,
           COALESCE( ImportedShelfLabelHeader.user_id, 42 ) AS last_modified_user_id,
           @existing_Shelf_Label_batch_id AS shelf_label_batch_id,
           'o' AS status_code
    FROM   #ImportedShelfLabelHeader ImportedShelfLabelHeader
  END
  ELSE
  --
  --    Someone is attempting to Delete a New Transaction
  --
  BEGIN
    SELECT @existing_Shelf_Label_batch_id = NULL
    SELECT @processItems                  = 'n'
  END
END
--
--  Transaction exists so Update/Insert or Delete with new information
--
ELSE
BEGIN
  --
  --  Determine if we can actually update this Document
  --
  DECLARE @statusCode NCHAR
  SELECT  @statusCode = ( SELECT ShelfLabelBatch.status_code
                          FROM   Shelf_Label_Batch ShelfLabelBatch WITH (NOLOCK)
                          WHERE  ShelfLabelBatch.shelf_label_batch_id = @existing_Shelf_Label_batch_id
                                 AND ShelfLabelBatch.business_unit_id = @buid
                        )
  IF ( @statusCode      =  'o' AND
       @inputStatusCode <> 'x' )
  BEGIN
    --
    --    At this point we're doing an Update or Insert of imported Items
    --
    --    Begin by updating the Document header
    --
    UPDATE     Shelf_Label_Batch
    SET        last_modified_timestamp = GETDATE(),
               last_modified_user_id   = COALESCE( ImportedShelfLabelHeader.user_id, 42 )
    FROM       #ImportedShelfLabelHeader ImportedShelfLabelHeader
    INNER JOIN Shelf_Label_Batch ShelfLabelBatch
               ON  ShelfLabelBatch.shelf_label_batch_id = @existing_Shelf_Label_batch_id
               AND ShelfLabelBatch.business_unit_id = @buid
    --
    --    Update existing rows
    --
    UPDATE       ShelfLabelBatchRMIList
    SET          last_modified_timestamp = GETDATE(),
                 last_modified_user_id   = ImportedShelfLabelItems.user_id,
                 print_quantity          = ImportedShelfLabelItems.print_quantity
    FROM         #ImportedShelfLabelItems ImportedShelfLabelItems
    INNER JOIN   Shelf_Label_Batch_RMI_List ShelfLabelBatchRMIList
                 ON  ShelfLabelBatchRMIList.shelf_label_batch_id = @existing_Shelf_Label_batch_id
                 AND ShelfLabelBatchRMIList.retail_modified_item_id = ImportedShelfLabelItems.retail_modified_item_id
                 AND ShelfLabelBatchRMIList.business_unit_id = @buid
                 AND ShelfLabelBatchRMIList.client_id = @clientId
    WHERE        ImportedShelfLabelItems.status_code <> 'x'
    --
    --    Dump previously recorded line items that ISS wants to get rid of
    --
    DELETE       ShelfLabelBatchRMIList
    FROM         #ImportedShelfLabelItems ImportedShelfLabelItems
    INNER JOIN   Shelf_Label_Batch_RMI_List ShelfLabelBatchRMIList
                 ON  ShelfLabelBatchRMIList.shelf_label_batch_id = @existing_Shelf_Label_batch_id
                 AND ShelfLabelBatchRMIList.retail_modified_item_id = ImportedShelfLabelItems.retail_modified_item_id
                 AND ShelfLabelBatchRMIList.business_unit_id = @buid
                 AND ShelfLabelBatchRMIList.client_id = @clientId
    WHERE        ImportedShelfLabelItems.status_code = 'x'
    --
    --    Remove Update Items from Item List (i.e. Get Insertable Items)
    --
    DELETE       ImportedShelfLabelItems
    FROM         #ImportedShelfLabelItems ImportedShelfLabelItems
    WHERE EXISTS ( SELECT 1
                     FROM   Shelf_Label_Batch_RMI_List ShelfLabelBatchRMIList WITH (NOLOCK)
                     WHERE  ShelfLabelBatchRMIList.shelf_label_batch_id = @existing_Shelf_Label_batch_id
                            AND ShelfLabelBatchRMIList.retail_modified_item_id = ImportedShelfLabelItems.retail_modified_item_id
                            AND ShelfLabelBatchRMIList.business_unit_id = @buid
                            AND ShelfLabelBatchRMIList.client_id = @clientId
                 )
    SELECT @processItems = 'y'

  END
  ELSE
  BEGIN
    --
    --    If the request is to remove an existing Document, remove it.
    --
    IF @inputStatusCode = 'x'
    BEGIN
      --
      --    Clobber Transaction Tables
      --
      DELETE FROM Shelf_Label_Batch_RMI_List
      WHERE       shelf_label_batch_id = @existing_Shelf_Label_batch_id

      DELETE FROM Shelf_Label_Batch
      WHERE       shelf_label_batch_id = @existing_Shelf_Label_batch_id

    END
    --
    --    Insure we don't do any more processing of this transaction
    --
    SELECT @existing_Shelf_Label_batch_id = NULL
    SELECT @processItems                  = 'n'

  END
END
--
--    If there are new Items to process, process them!
--
IF @processItems = 'y'
BEGIN
  --
  --    Clobber any Items that may be deletes in the list
  --
  DELETE FROM ImportedShelfLabelItems
  FROM        #ImportedShelfLabelItems ImportedShelfLabelItems
  WHERE       ImportedShelfLabelItems.status_code = 'x'
  --
  --    Determine if there are actually Items to process
  --
  IF EXISTS ( SELECT 1
              FROM   #ImportedShelfLabelItems
            )
  BEGIN
    --
    --    Finally, Insert Items into EP database
    --
    INSERT INTO Shelf_Label_Batch_RMI_List
    (
      business_unit_id,
      client_id,
      last_modified_timestamp,
      last_modified_user_id,
      print_quantity,
      retail_modified_item_id,
      shelf_label_batch_id
    )
    SELECT @buid AS business_unit_id,
           @clientId AS client_id,
           GETDATE() AS last_modified_timestamp,
           ImportedShelfLabelItems.user_id AS last_modified_user_id,
           ImportedShelfLabelItems.print_quantity AS print_quantity,
           ImportedShelfLabelItems.retail_modified_item_id AS retail_modified_item_id,
           @existing_Shelf_Label_batch_id AS shelf_label_batch_id
    FROM   #ImportedShelfLabelItems ImportedShelfLabelItems
  END
END
--
--    Drop SQL DOM.
--
EXEC sp_xml_removedocument @idoc

--
--  Return results set
--
SELECT *
FROM   Shelf_Label_Batch ShelfLabelBatch WITH (NOLOCK)
WHERE  ShelfLabelBatch.shelf_label_batch_id = @existing_Shelf_Label_batch_id
 


GO

