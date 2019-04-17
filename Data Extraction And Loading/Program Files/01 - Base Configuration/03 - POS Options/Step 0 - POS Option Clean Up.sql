delete POS_Option_Group_List
where client_id > 0

update Business_Unit_Settings
set pos_option_group_id = NULL

delete POS_Option_Group
where client_id > 0

delete POS_Option_Template_List
where client_id > 0

delete POS_Option_Template
where client_id > 0

delete from pos_option
where pos_option_id >= 1000000 



