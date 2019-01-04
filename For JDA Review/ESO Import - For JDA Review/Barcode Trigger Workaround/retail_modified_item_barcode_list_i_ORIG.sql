
DROP trigger [dbo].[retail_modified_item_barcode_list_i]
GO

CREATE  trigger [dbo].[retail_modified_item_barcode_list_i] on [dbo].[Retail_Modified_Item_BarCode_List]
for insert as
SET NOCOUNT ON;
declare  @cnt int
    ,@ticket int
    ,@compressed_code_cnt int

declare @barcode_list table (int_id int not null identity(0,1)
            ,retail_modified_item_id int not null
            ,barcode_id int not null
            ,client_id int not null
            ,last_modified_user_id int not null
            ,last_modified_timestamp datetime not null)

insert into @barcode_list (retail_modified_item_id
              ,barcode_id
              ,client_id
              ,last_modified_user_id
              ,last_modified_timestamp)

select   retail_modified_item_id
        ,barcode_id
        ,client_id
        ,last_modified_user_id
        ,last_modified_timestamp
      from inserted

select @cnt = @@rowcount

exec @ticket = plt_get_next_named_ticket 'Retail_Modified_Item_Barcode','n',@cnt

insert into retail_modified_item_barcode (retail_modified_item_id
                    ,barcode_id
                    ,barcode_type_code
                    ,barcode_number
                    ,client_id
                    ,last_modified_user_id
                    ,last_modified_timestamp)
  select i.retail_modified_item_id
      ,@ticket-i.int_id
      ,b.barcode_type_code
      ,b.primitive_complete_code
      ,i.client_id
      ,i.last_modified_user_id
      ,i.last_modified_timestamp
    from @barcode_list i
    join barcode b
      on i.barcode_id = b.barcode_id
      and not exists (select 1 from Retail_Modified_Item_Barcode bl
                where bl.retail_modified_item_id = i.retail_modified_item_id
                and bl.barcode_type_code = b.barcode_type_code
                and bl.barcode_number = b.primitive_complete_code)

/* if the complete code is different from the compressed code 
                            then insert record into Retail_Modified_Item_Barcode */

select @compressed_code_cnt = ( select count(*) 
                               from barcode b
                               join @barcode_list i
                                on i.barcode_id = b.barcode_id
                               where primitive_compressed_code <> primitive_complete_code )
if ( @compressed_code_cnt > 0 )
begin
  exec @ticket = plt_get_next_named_ticket 'Retail_Modified_Item_Barcode','n',@compressed_code_cnt
  insert into retail_modified_item_barcode (retail_modified_item_id
                      ,barcode_id
                      ,barcode_type_code
                      ,barcode_number
                      ,client_id
                      ,last_modified_user_id
                      ,last_modified_timestamp)
    select i.retail_modified_item_id
        ,@ticket-i.int_id
        ,b.barcode_type_code
        ,b.primitive_compressed_code
        ,i.client_id
        ,i.last_modified_user_id
        ,i.last_modified_timestamp
      from @barcode_list i
      join barcode b
        on i.barcode_id = b.barcode_id
        and not exists (select 1 from Retail_Modified_Item_Barcode bl
                  where bl.retail_modified_item_id = i.retail_modified_item_id
                  and bl.barcode_type_code = b.barcode_type_code
                  and bl.barcode_number = b.primitive_compressed_code)
  
end 






GO

ALTER TABLE [dbo].[Retail_Modified_Item_BarCode_List] ENABLE TRIGGER [retail_modified_item_barcode_list_i]
GO

