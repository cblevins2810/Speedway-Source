IF OBJECT_ID('bcssa_custom_integration..bc_extract_pos_frame_template') IS NOT NULL
  DROP TABLE bcssa_custom_integration..bc_extract_pos_frame_template
GO

IF OBJECT_ID('bcssa_custom_integration..bc_extract_pos_frame_group_type') IS NOT NULL
  DROP TABLE bcssa_custom_integration..bc_extract_pos_frame_group_type
GO

IF OBJECT_ID('bcssa_custom_integration..bc_extract_pos_menu_frame_group_type_list') IS NOT NULL
  DROP TABLE bcssa_custom_integration..bc_extract_pos_menu_frame_group_type_list
GO

IF OBJECT_ID('bcssa_custom_integration..bc_extract_POS_Button_Template') IS NOT NULL
  DROP TABLE bcssa_custom_integration..bc_extract_POS_Button_Template
GO

IF OBJECT_ID('bcssa_custom_integration..bc_extract_POS_Button_Action_Frame_Group_List') IS NOT NULL
  DROP TABLE bcssa_custom_integration..bc_extract_POS_Button_Action_Frame_Group_List
GO

SELECT t.*, g.name INTO  bcssa_custom_integration..bc_extract_pos_frame_template
FROM  POS_Frame_Template AS t
JOIN POS_Frame_Group_Type AS g
ON   t.frame_group_type_id = g.frame_group_type_id
WHERE t.description IN ('PCS Enhancement Frame, 5X5', 'PCS Menu Frame, 5X5')

SELECT * INTO  bcssa_custom_integration..bc_extract_pos_frame_group_type
FROM  POS_Frame_Group_Type
WHERE name in ('PCS Main Frame (5X5)','PCS Enhancement Frame (5X5)')

SELECT  l.*, fgt.name, ft.description
INTO  bcssa_custom_integration..bc_extract_pos_menu_frame_group_type_list
FROM  pos_menu_frame_group_type_list AS l
JOIN POS_Frame_Group_Type AS fgt
ON   l.frame_group_type_id = fgt.frame_group_type_id
JOIN POS_Frame_Template AS ft
ON   l.default_frame_template_id = ft.pos_frame_template_id
WHERE fgt.name in ('PCS Main Frame (5X5)','PCS Enhancement Frame (5X5)')
AND   l.menu_type_id = 9

SELECT bt.*, ft.description
INTO   bcssa_custom_integration..bc_extract_pos_button_template
FROM   POS_Button_Template AS bt
JOIN   POS_Frame_Template AS ft
ON     bt.pos_frame_template_id = ft.pos_frame_template_id
WHERE  ft.description IN ('PCS Enhancement Frame, 5X5', 'PCS Menu Frame, 5X5')

SELECT l.*, fgt.name
INTO bcssa_custom_integration..bc_extract_POS_Button_Action_Frame_Group_List
FROM POS_Button_Action_Frame_Group_List AS l
JOIN POS_Frame_Group_Type AS fgt
ON   l.frame_group_type_id = fgt.frame_group_type_id
WHERE fgt.name in ('PCS Main Frame (5X5)','PCS Enhancement Frame (5X5)')





