--begin transaction

--select * from pos_text
delete pos_text 
where client_id > 0

--select * from POS_Button
delete pos_button 
where client_id > 0

delete POS_Menu_Frame_Group_List
where client_id > 0

--select * from pos_frame
delete pos_frame
where client_id > 0

--select * from pos_frame_group
delete pos_frame_group
where client_id > 0

--select * from pos_menu_frame_group_type_list
delete pos_menu_frame_group_type_list
where client_id > 0

--select * from pos_button_template
delete pos_button_template
where client_id > 0

--select * from pos_frame_template
delete pos_frame_template
where client_id > 0

--select * from pos_frame_group_type
delete pos_frame_group_type
where client_id > 0

--select * from POS_Menu_Type
delete POS_Menu_Type
where client_id > 0

--rollback transaction