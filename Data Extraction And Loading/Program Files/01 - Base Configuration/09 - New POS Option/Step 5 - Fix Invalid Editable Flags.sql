update POS_Option 
set value_editable_flag = 'n'
where lh_identifier IN (
'6000',
'10000',
'10001',
'10002',
'10004',
'10028')
and name not like '%Tokh%'

update POS_Option_Template_List
set default_value = 0, value_editable_flag = 'y'
where pos_option_id in (select pos_option_id
                        from POS_Option 
                        where lh_identifier IN (
                        '6000',
                        '10000',
                        '10001',
                        '10002',
                        '10004',
                        '10028')
                         and name not like '%Tokh%')




