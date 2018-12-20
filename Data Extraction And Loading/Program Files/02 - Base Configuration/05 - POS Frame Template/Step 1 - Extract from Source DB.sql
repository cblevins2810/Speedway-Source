IF OBJECT_ID('bc_extract_pos_frame_template') IS NOT NULL
  DROP TABLE bc_extract_pos_frame_template
GO

IF OBJECT_ID('bc_extract_pos_frame_group_type') IS NOT NULL
  DROP TABLE bc_extract_pos_frame_group_type
GO

SELECT t.*, g.name INTO bc_extract_pos_frame_template
FROM POS_Frame_Template AS t
JOIN POS_Frame_Group_Type AS g
ON   t.frame_group_type_id = g.frame_group_type_id
WHERE t.descriptiON IN ('PCS Enhancement Frame, 4X4',
'PCS Enhancement Frame, 5X5',
'PCS Menu Frame, 4X4',
'PCS Menu Frame, 5X5')

SELECT * INTO bc_extract_pos_frame_group_type
FROM POS_Frame_Group_Type
WHERE frame_group_type_id IN (31,
32,
33,
34)
