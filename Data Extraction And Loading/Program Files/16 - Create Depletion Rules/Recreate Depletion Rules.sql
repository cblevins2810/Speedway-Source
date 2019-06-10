DECLARE @ClientId INT

SELECT @ClientId = MAX(client_id) FROM RAD_SYS_Client

EXEC mm_gen_retail_item_depletion @ClientId