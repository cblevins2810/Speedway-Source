select * from POS_Frame_Group_Type

select 'select * from ' + object_name(id) + ' where frame_group_type_id in (31,33)' from syscolumns where name = 'frame_group_type_id'

select * from POS_Button_Action_Frame_Group_List where frame_group_type_id in (31,33)
--select * from bc_extract_pos_menu_frame_group_type_list where frame_group_type_id in (31,33)
select * from POS_Frame_Group where frame_group_type_id in (31,33)
select * from POS_Frame_Group_Type where frame_group_type_id in (31,33)
select * from POS_Frame_Template where frame_group_type_id in (31,33)
--select * from bc_extract_POS_Button_Action_Frame_Group_List where frame_group_type_id in (31,33)
select * from POS_Menu_Frame_Group_Type_List where frame_group_type_id in (31,33)
select * from POS_Message where frame_group_type_id in (31,33)
select * from POS_Message_Override where frame_group_type_id in (31,33)
select * from POS_Message_Template_List where frame_group_type_id in (31,33)

insert POS_Frame_Group_Type (frame_group_type_id, name, client_id, last_modified_user_id, last_modified_timestamp, data_guid)
select frame_group_type_id * -1, name, client_id, last_modified_user_id, last_modified_timestamp, data_guid
from pos_frame_group_type
where frame_group_type_id in (31,33)

update POS_Button_Action_Frame_Group_List
set frame_group_type_id = -1 * frame_group_type_id
where frame_group_type_id in (31,33)

update POS_Frame_Template
set frame_group_type_id = -1 * frame_group_type_id
where frame_group_type_id in (31,33)

update POS_Menu_Frame_Group_Type_List
set frame_group_type_id = -1 * frame_group_type_id
where frame_group_type_id in (31,33)

select * from pos_frame_group_type

select * from POS_Button_Action_Frame_Group_List where frame_group_type_id in (1000111,1000112)
select * from POS_Frame_Group where frame_group_type_id in (1000111,1000112)
--select * from POS_Frame_Group_Type where frame_group_type_id in  (1000111,1000112)
select * from POS_Frame_Template where frame_group_type_id in  (1000111,1000112)
select * from POS_Menu_Frame_Group_Type_List where frame_group_type_id in  (1000111,1000112)
--select * from POS_Message where frame_group_type_id in  (1000111,1000112)
--select * from POS_Message_Override where frame_group_type_id in  (1000111,1000112)
--select * from POS_Message_Template_List where frame_group_type_id in  (1000111,1000112)

update POS_Button_Action_Frame_Group_List
set frame_group_type_id = 33
where frame_group_type_id in (1000111)

update POS_Button_Action_Frame_Group_List
set frame_group_type_id = 31
where frame_group_type_id in (1000112)

update POS_Frame_Group
set frame_group_type_id = 33
where frame_group_type_id in (1000111)

update POS_Frame_Group
set frame_group_type_id = 31
where frame_group_type_id in (1000112)

update POS_Frame_Template
set frame_group_type_id = 33
where frame_group_type_id in (1000111)

update POS_Frame_Template
set frame_group_type_id = 31
where frame_group_type_id in (1000112)

update POS_Menu_Frame_Group_Type_List
set frame_group_type_id = 33
where frame_group_type_id in (1000111)

update POS_Menu_Frame_Group_Type_List
set frame_group_type_id = 31
where frame_group_type_id in (1000112)

select * from POS_Menu_Frame_Group_Type_List

select * from POS_Frame_Group_Type

update POS_Frame_Group_Type
set name =  'PCS Enhancement Frame (5X5)'
where frame_group_type_id = 33

update POS_Frame_Group_Type
set name =  'PCS Main Frame (5X5)'
where frame_group_type_id = 31

delete POS_Frame_Group_Type where frame_group_type_id > 10000
