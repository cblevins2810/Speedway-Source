exec sp_executesql @statement=N'/*CollectLastCountsoFDay*/
INSERT  #tmp_bu_day_count 
(
        bu_id,
        business_date,
        inventory_item_id,
        bu_date_last_count_timestamp,
        atomic_count_qty,
        frequency_code
)
SELECT  @bu_id, 
        @business_date, 
        cnt.inventory_item_id,
        cnt.timestamp,
        COALESCE(atomic_count_qty, 0),
        cnt.frequency_code

FROM    #f_gen_inv_count          cnt WITH (NOLOCK)
WHERE   cnt.timestamp             = ( SELECT  MAX(cnt2.timestamp)
                                      FROM    #f_gen_inv_count        cnt2 WITH (NOLOCK)
                                      WHERE   cnt.inventory_item_id   = cnt2.inventory_item_id 
                                    )',@parameters=N'@bu_id int, @business_date smalldatetime, @wave_data_flag nchar(1)',@bu_id=1000397,@business_date=N'11/21/2018',@wave_data_flag=N'y '