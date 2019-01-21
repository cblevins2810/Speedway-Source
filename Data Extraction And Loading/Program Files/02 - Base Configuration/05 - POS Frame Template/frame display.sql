--exec sp_executesql N'
SELECT  button.button_id AS button_id, button.button_name AS button_name, button.text_color_id AS text_color_id, 
       color1.rgb as text_color, color1.color_name as text_color_name, button.button_color_id AS button_color_id, color2.rgb as button_color, color2.color_name as button_color_name, button.pos_file_id AS pos_file_id, image.src_dir + image.src_filename as file_name, image.name as image_name, button.visible_flag AS visible_flag,
       button.action_id as action_id, button.retail_modified_item_id AS retail_modified_item_id, button.two_item_retail_modified_item_id AS two_item_retail_modified_item_id,
       item.retail_item_id AS retail_item_id, item2.retail_item_id as retail_item2_id, item.name as item_name, item2.name as item_name2, button.external_item_value AS external_item_value, button.dimension_member_id AS dimension_member_id, ridm.name as modifier_name, button.navigation_frame_group_id AS navigation_frame_group_id, button.frame_id as frame_id, button.pos_frame_group_id as pos_frame_group_id, pf.frame_group_name as navigation_frame, button.pos_button_template_id AS pos_button_template_id, ba.name as action_name,t.pos_font_id AS pos_font_id, pfile.name as font_name, font.browser_font_name AS browser_font_name, font.browser_font_size AS browser_font_size, font.pixel_per_char AS pixel_per_char, button.action_parameter AS action_parameter, 
       button.tender_id AS tender_id, tender.name as tender_name, button.sales_dest_id AS sales_dest_id, dest.name as dest_name, button.justification_type_code AS justification_type_code, t.pos_button_type_code as buttonType, t.left_position as pos_left, t.top_position as pos_top, t.height as height, t.width as width, 
       sysImage.pos_file_id as sysFileName, sysButClr.rgb as sysButClr, sysTxtClr.rgb as sysTxtClr

FROM (SELECT * FROM  pos_button_template t 
      WHERE  client_id in (@cdm_client_id, 0)) t

	  JOIN (SELECT * FROM  (select d.color_id, d.frame_group_type_id, d.frame_resolution_type_code, d.global_flag, d.height, d.left_position, d.pos_frame_template_id, d.top_position, d.width, d.client_id, d.data_guid, coalesce(m.description, d.description) as description, d.last_modified_timestamp, d.last_modified_user_id
                      from pos_frame_template as d 
                      left join pos_frame_template_lang as m
                      on m.translated_lang_id = @current_language_id
                      and m.pos_frame_template_id = d.pos_frame_template_id) ft
					  WHERE  client_id in (@cdm_client_id, 0)) ft
ON   ft.pos_frame_template_id = t.pos_frame_template_id

LEFT OUTER JOIN (SELECT * FROM  pos_button button WHERE  client_id in (@cdm_client_id, 0)) button
 ON  t.pos_button_template_id = button.pos_button_template_id
 AND button.frame_id = @frame_id

 
LEFT OUTER JOIN (SELECT * FROM  pos_menu pm WHERE  client_id in (@cdm_client_id, 0)) pm
ON   pm.menu_id = button.menu_id
LEFT OUTER JOIN (SELECT * FROM  item_hierarchy ih WHERE  client_id in (@cdm_client_id, 0)) ih
 ON  ih.item_hierarchy_id = button.open_sales_item_hierarchy_id
LEFT OUTER JOIN (SELECT * FROM  (select d.amount, d.denomination_id, d.client_id, d.data_guid, d.last_modified_timestamp, d.last_modified_user_id, coalesce(m.name, d.name) as name from tender_denomination as d 
   left join tender_denomination_lang as m
     on m.translated_lang_id = @current_language_id
  and m.denomination_id = d.denomination_id) td WHERE  client_id in (@cdm_client_id, 0)) td
 ON  td.denomination_id = button.denomination_id
LEFT OUTER JOIN (SELECT * FROM  (select d.cdm_owner_id, d.description, d.dest_dir, d.dest_filename, d.file_data, d.file_type, d.height, d.pos_file_guid, d.pos_file_id, d.src_dir, d.src_filename, d.width, d.client_id, d.data_guid, d.last_modified_timestamp, d.last_modified_user_id, coalesce(m.name, d.name) as name from pos_file as d 
   left join pos_file_lang as m
     on m.translated_lang_id = @current_language_id
  and m.pos_file_id = d.pos_file_id) image WHERE  client_id in (@cdm_client_id, 0)) image 
 ON  Button.pos_file_id = image.pos_file_id 
LEFT OUTER JOIN (SELECT * FROM  (select d.cdm_owner_id, d.description, d.dest_dir, d.dest_filename, d.file_data, d.file_type, d.height, d.pos_file_guid, d.pos_file_id, d.src_dir, d.src_filename, d.width, d.client_id, d.data_guid, d.last_modified_timestamp, d.last_modified_user_id, coalesce(m.name, d.name) as name from pos_file as d 
   left join pos_file_lang as m
     on m.translated_lang_id = @current_language_id
  and m.pos_file_id = d.pos_file_id) sysImage WHERE  client_id in (@cdm_client_id, 0)) sysImage 
 ON  t.pos_file_id = sysImage.pos_file_id 
LEFT OUTER JOIN (SELECT * FROM  retail_modified_item item WHERE  client_id in (@cdm_client_id, 0)) item 
 ON  button.retail_modified_item_id = item.retail_modified_item_id 
LEFT OUTER JOIN (SELECT * FROM  retail_modified_item item2 WHERE  client_id in (@cdm_client_id, 0)) item2 
 ON  button.two_item_retail_modified_item_id = item2.retail_modified_item_id 
LEFT OUTER JOIN (SELECT * FROM  (select d.color_id, d.decimal_value, d.rgb, d.client_id, coalesce(m.color_name, d.color_name) as color_name, d.data_guid, d.last_modified_timestamp, d.last_modified_user_id from pos_color as d 
   left join pos_color_lang as m
     on m.translated_lang_id = @current_language_id
  and m.color_id = d.color_id) color1 WHERE  client_id in (@cdm_client_id, 0)) color1 
 ON  button.text_color_id = color1.color_id 
LEFT OUTER JOIN (SELECT * FROM  (select d.color_id, d.decimal_value, d.rgb, d.client_id, coalesce(m.color_name, d.color_name) as color_name, d.data_guid, d.last_modified_timestamp, d.last_modified_user_id from pos_color as d 
   left join pos_color_lang as m
     on m.translated_lang_id = @current_language_id
  and m.color_id = d.color_id) color2 WHERE  client_id in (@cdm_client_id, 0)) color2 
 ON  button.button_color_id = color2.color_id 
LEFT OUTER JOIN (SELECT * FROM  (select d.color_id, d.decimal_value, d.rgb, d.client_id, coalesce(m.color_name, d.color_name) as color_name, d.data_guid, d.last_modified_timestamp, d.last_modified_user_id from pos_color as d 
   left join pos_color_lang as m
     on m.translated_lang_id = @current_language_id
  and m.color_id = d.color_id) as sysButClr WHERE  client_id in (@cdm_client_id, 0)) as sysButClr 
 ON  t.button_color_id = sysButClr.color_id 
LEFT OUTER JOIN (SELECT * FROM  (select d.color_id, d.decimal_value, d.rgb, d.client_id, coalesce(m.color_name, d.color_name) as color_name, d.data_guid, d.last_modified_timestamp, d.last_modified_user_id from pos_color as d 
   left join pos_color_lang as m
     on m.translated_lang_id = @current_language_id
  and m.color_id = d.color_id) as sysTxtClr WHERE  client_id in (@cdm_client_id, 0)) as sysTxtClr 
 ON  t.text_color_id = sysTxtClr.color_id 
LEFT OUTER JOIN (SELECT * FROM  (select d.active_flag, d.dimension_id, d.dimension_member_id, d.pos_mapping_number, d.unit_of_measure_id, d.unit_of_measure_quantity, d.client_id, d.data_guid, d.last_modified_timestamp, d.last_modified_user_id, coalesce(m.name, d.name) as name, coalesce(m.receipt_text, d.receipt_text) as receipt_text from retail_item_dimension_member as d 
   left join retail_item_dimension_member_lang as m
     on m.translated_lang_id = @current_language_id
  and m.dimension_member_id = d.dimension_member_id) ridm WHERE  client_id in (@cdm_client_id, 0)) ridm 
 ON  button.dimension_member_id = ridm.dimension_member_id 
LEFT OUTER JOIN (SELECT * FROM  pos_frame_group pf WHERE  client_id in (@cdm_client_id, 0)) pf 
 ON  button.navigation_frame_group_id = pf.pos_frame_group_id
LEFT OUTER JOIN (SELECT * FROM  pos_button_action ba WHERE  client_id in (@cdm_client_id, 0)) ba 
 ON  button.action_id = ba.action_id 
LEFT OUTER JOIN (SELECT * FROM  (select d.cdm_owner_id, d.description, d.dest_dir, d.dest_filename, d.file_data, d.file_type, d.height, d.pos_file_guid, d.pos_file_id, d.src_dir, d.src_filename, d.width, d.client_id, d.data_guid, d.last_modified_timestamp, d.last_modified_user_id, coalesce(m.name, d.name) as name from pos_file as d 
   left join pos_file_lang as m
     on m.translated_lang_id = @current_language_id
  and m.pos_file_id = d.pos_file_id) pfile WHERE  client_id in (@cdm_client_id, 0)) pfile 
 ON  button.pos_font_id = pfile.pos_file_id 
LEFT OUTER JOIN (SELECT * FROM  pos_font font WHERE  client_id in (@cdm_client_id, 0)) font 
 ON  pfile.pos_file_id = font.pos_font_id 
 AND button.pos_font_id = font.pos_font_id 
LEFT OUTER JOIN (SELECT * FROM  sales_destination dest WHERE  client_id in (@cdm_client_id, 0)) dest ON button.sales_dest_id = dest.sales_dest_id 
 AND button.pos_font_id = font.pos_font_id 
LEFT OUTER JOIN (SELECT * FROM  tender WHERE  client_id in (@cdm_client_id, 0)) tender 
 ON  button.tender_id = tender.tender_id
WHERE( t.pos_frame_template_id = 
  (SELECT min(pos_frame_template_id) 
   FROM (SELECT * FROM  pos_button WHERE  client_id in (@cdm_client_id, 0)) pos_button 
   WHERE frame_id = @frame_id)
 AND ( (button.button_id IS NOT NULL) OR (t.pos_button_type_code = N''f'') )) and ( button.client_id = 10000001 OR button.client_id IS NULL )  order by buttonType, pos_top, pos_left
',
N'
@cdm_client_id int, 
@current_language_id int, 
@frame_id int',

@cdm_client_id = 10000001, 
@current_language_id = 1, 
@frame_id = 1000124