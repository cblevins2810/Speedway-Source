/*  This script adds POS Options that were created as red table data in the Speedway BC version, but did not exists in 
    the latest (18.1) version of ESO.  The options are created with the client id of the client, not the global 0 client. */

/*
-- Custom BlueCube Options that are being re-implemented
-2147383390	Carwash Rollback Max Gallons
20857	Switch to Refund Time Delay
20867	SVC Fuel Discount ID
20868	SVC Card Activate Discount ID
20869	SVC Card Recharge Discount ID
20870	SVC Retail Activate Dicount ID
20871	SVC Retail Recharge Dicount ID
20872	Max Money Order Transaction Amount
20875	Time re-prompt interval for Fuel Price change
500001	Days To Retain CSS Transaction Data
500002	CSS Default Item ID
500003	CSS Data Path
*/

DECLARE @ClientId INT
DECLARE @POSOptionGroupId INT
DECLARE @POSOptionId INT
SELECT @ClientId = MAX(client_id) FROM RAD_SYS_Client

DECLARE @NumberOfTickets INT
DECLARE @NextTicket INT

-- This will get the current ticket value, not the next ticket value
SET @NumberOfTickets = 0
EXEC plt_get_next_named_ticket 'POS_Option_Group','n', @NumberOfTickets, @NextTicket OUTPUT
SET @POSOptionGroupId = @NextTicket

SET @NumberOfTickets = 12
EXEC plt_get_next_named_ticket 'POS_Option','n', @NumberOfTickets, @NextTicket OUTPUT
SET @POSOptionId = @NextTicket

INSERT POS_Option (pos_option_id, valid_value_group_id, pos_option_category_id, name, description, value_editable_flag, option_type_code, default_value, valid_expression, sort_order, lh_identifier, pos_translate_code, client_id, last_modified_user_id, last_modified_timestamp, data_guid)
VALUES (@POSOptionId, 4, 121, 'Carwash Rollback Max Gallons', 'Represents the maximum quantity of fuel to which the Carwash Rollback price reduction applies; default 0', 'y', 'i', '0', NULL, 0, '10038', 'n', 0, 42, GETDATE(), '0e357fe6-b3d0-4da3-a2f5-360192d5f2b6')
INSERT POS_Option_Group_List (pos_option_group_id, pos_option_id, value, client_id, value_editable_flag, last_modified_user_id, last_modified_timestamp)
VALUES (@POSOptionGroupId, @POSOptionId, '20', @ClientId, 'y', 42, GETDATE())

SET @POSOptionId += 1
INSERT POS_Option (pos_option_id, valid_value_group_id, pos_option_category_id, name, description, value_editable_flag, option_type_code, default_value, valid_expression, sort_order, lh_identifier, pos_translate_code, client_id, last_modified_user_id, last_modified_timestamp, data_guid)
VALUES (@POSOptionId, 4, 107, 'Switch to Refund Time Delay', 'The time out value for a transaction to reside uncompleted on the POS before it reverts to a refund transaction.  Time is in seconds.', '', 'i', '600', NULL, 1, '6000', 'n', 0, 42, GETDATE(), '2953fe80-0ad1-483b-a6d3-fee2401770f9')
INSERT POS_Option_Group_List (pos_option_group_id, pos_option_id, value, client_id, value_editable_flag, last_modified_user_id, last_modified_timestamp)
VALUES (@POSOptionGroupId, @POSOptionId, '600', @ClientId, '', 42, GETDATE())

SET @POSOptionId += 1
INSERT POS_Option (pos_option_id, valid_value_group_id, pos_option_category_id, name, description, value_editable_flag, option_type_code, default_value, valid_expression, sort_order, lh_identifier, pos_translate_code, client_id, last_modified_user_id, last_modified_timestamp, data_guid)
VALUES (@POSOptionId, 4, 106, 'SVC Fuel Discount ID', 'SSA custom option for SVC discounts', '', 'i', '0', NULL, 1, '10000', 'n', 0, 42, GETDATE(), 'c07a09c6-a048-4268-8ba5-8cf0261f1609')
INSERT POS_Option_Group_List (pos_option_group_id, pos_option_id, value, client_id, value_editable_flag, last_modified_user_id, last_modified_timestamp)
VALUES (@POSOptionGroupId, @POSOptionId, '1138840', @ClientId, '', 42, GETDATE())

SET @POSOptionId += 1
INSERT POS_Option (pos_option_id, valid_value_group_id, pos_option_category_id, name, description, value_editable_flag, option_type_code, default_value, valid_expression, sort_order, lh_identifier, pos_translate_code, client_id, last_modified_user_id, last_modified_timestamp, data_guid)
VALUES (@POSOptionId, 4, 106, 'SVC Card Activate Discount ID', 'SSA custom option for Card activate discount', '', 'i', '0', NULL, 1, '10001', 'n', 0, 42, GETDATE(), '4c1b7c87-86c5-4fdf-b01e-84fca21d083f')
INSERT POS_Option_Group_List (pos_option_group_id, pos_option_id, value, client_id, value_editable_flag, last_modified_user_id, last_modified_timestamp)
VALUES (@POSOptionGroupId, @POSOptionId, '1138839', @ClientId, '', 42, GETDATE())

SET @POSOptionId +=1
INSERT POS_Option (pos_option_id, valid_value_group_id, pos_option_category_id, name, description, value_editable_flag, option_type_code, default_value, valid_expression, sort_order, lh_identifier, pos_translate_code, client_id, last_modified_user_id, last_modified_timestamp, data_guid)
VALUES (@POSOptionId, 4, 106, 'SVC Card Recharge Discount ID', 'SSA Custom option for card recharge SVC discount', '', 'i', '0', NULL, 1, '10002', 'n', 0, 42, GETDATE(), 'd7cff47d-2092-4c28-a73a-8aaa1b1eeece')
INSERT POS_Option_Group_List (pos_option_group_id, pos_option_id, value, client_id, value_editable_flag, last_modified_user_id, last_modified_timestamp)
VALUES (@POSOptionGroupId, @POSOptionId, '1138842', @ClientId, '', 42, GETDATE())

SET @POSOptionId +=1
INSERT POS_Option (pos_option_id, valid_value_group_id, pos_option_category_id, name, description, value_editable_flag, option_type_code, default_value, valid_expression, sort_order, lh_identifier, pos_translate_code, client_id, last_modified_user_id, last_modified_timestamp, data_guid)
VALUES (@POSOptionId, 4, 106, 'SVC Retail Activate Dicount ID', 'SSA Custom option for SVC Retail Activate Discount', 'n', 'i', '0', NULL, 1, '10003', 'n', 0, 42, GETDATE(), '646cf6a4-85a3-454c-9f82-e44ec3401d07')
INSERT POS_Option_Group_List (pos_option_group_id, pos_option_id, value, client_id, value_editable_flag, last_modified_user_id, last_modified_timestamp)
VALUES (@POSOptionGroupId, @POSOptionId, '1138841', @ClientId, '', 42, GETDATE())

SET @POSOptionId +=1
INSERT POS_Option (pos_option_id, valid_value_group_id, pos_option_category_id, name, description, value_editable_flag, option_type_code, default_value, valid_expression, sort_order, lh_identifier, pos_translate_code, client_id, last_modified_user_id, last_modified_timestamp, data_guid)
VALUES (@POSOptionId, 4, 106, 'SVC Retail Recharge Dicount ID', 'SSA Custom option for SVC Retail Recharge Discount', '', 'i', '0', NULL, 1, '10004', 'n', 0, 42, GETDATE(), '02f8e654-cd8b-48eb-abde-fc8e075bbf51')
INSERT POS_Option_Group_List (pos_option_group_id, pos_option_id, value, client_id, value_editable_flag, last_modified_user_id, last_modified_timestamp)
VALUES (@POSOptionGroupId, @POSOptionId, '1138843', @ClientId, '', 42, GETDATE())

SET @POSOptionId +=1
INSERT POS_Option (pos_option_id, valid_value_group_id, pos_option_category_id, name, description, value_editable_flag, option_type_code, default_value, valid_expression, sort_order, lh_identifier, pos_translate_code, client_id, last_modified_user_id, last_modified_timestamp, data_guid)
VALUES (@POSOptionId, 4, 105, 'Max Money Order Transaction Amount', 'The maximum amount for a single Money Order transactio', '', 'i', '299999', NULL, 1, '10028', 'n', 0, 42, GETDATE(), '0953ca7c-57f9-4da0-83b7-03a45662d669')
INSERT POS_Option_Group_List (pos_option_group_id, pos_option_id, value, client_id, value_editable_flag, last_modified_user_id, last_modified_timestamp)
VALUES (@POSOptionGroupId, @POSOptionId, '1900', @ClientId, '', 42, GETDATE())

SET @POSOptionId +=1
INSERT POS_Option (pos_option_id, valid_value_group_id, pos_option_category_id, name, description, value_editable_flag, option_type_code, default_value, valid_expression, sort_order, lh_identifier, pos_translate_code, client_id, last_modified_user_id, last_modified_timestamp, data_guid)
VALUES (@POSOptionId, 4, 121, 'Time re-prompt interval for Fuel Price change', 'RPOS needs this option to prompt for alert the user after the new price effect has passed and no action has been taken by the user to commit the new price.  This value indicates the time interval (in minutes) for re-prompting the user.', 'y', 'i', '5', NULL, 1, '10029', 'n', 0, 42, GETDATE(), 'b46b329b-3360-4948-9da8-8417a610321f')
INSERT POS_Option_Group_List (pos_option_group_id, pos_option_id, value, client_id, value_editable_flag, last_modified_user_id, last_modified_timestamp)
VALUES (@POSOptionGroupId, @POSOptionId, '5', @ClientId, 'y', 42, GETDATE())

SET @POSOptionId +=1
INSERT POS_Option (pos_option_id, valid_value_group_id, pos_option_category_id, name, description, value_editable_flag, option_type_code, default_value, valid_expression, sort_order, lh_identifier, pos_translate_code, client_id, last_modified_user_id, last_modified_timestamp, data_guid)
VALUES (@POSOptionId, 4, 102, 'Days To Retain CSS Transaction Data', NULL, 'y', 'i', '7', NULL, 1, 'DaysToRetainCSSData', 'g', 0, 42, GETDATE(), NULL)
INSERT POS_Option_Group_List (pos_option_group_id, pos_option_id, value, client_id, value_editable_flag, last_modified_user_id, last_modified_timestamp)
VALUES (@POSOptionGroupId, @POSOptionId, '7', @ClientId, 'y', 42, GETDATE())

SET @POSOptionId +=1
INSERT POS_Option (pos_option_id, valid_value_group_id, pos_option_category_id, name, description, value_editable_flag, option_type_code, default_value, valid_expression, sort_order, lh_identifier, pos_translate_code, client_id, last_modified_user_id, last_modified_timestamp, data_guid)
VALUES (@POSOptionId, 4, 102, 'CSS Default Item ID', NULL, 'y', 'i', '23833', NULL, 1, '10036', 'n', 0, 42, GETDATE(), NULL)
INSERT POS_Option_Group_List (pos_option_group_id, pos_option_id, value, client_id, value_editable_flag, last_modified_user_id, last_modified_timestamp)
VALUES (@POSOptionGroupId, @POSOptionId, '23833', @ClientId, 'y', 42, GETDATE())

SET @POSOptionId +=1
INSERT POS_Option (pos_option_id, valid_value_group_id, pos_option_category_id, name, description, value_editable_flag, option_type_code, default_value, valid_expression, sort_order, lh_identifier, pos_translate_code, client_id, last_modified_user_id, last_modified_timestamp, data_guid)
VALUES (@POSOptionId, 4, 102, 'CSS Data Path', NULL, 'y', 's', 'C:\Program Files\Radiant\CSSData', NULL, 1, 'CSSDataPath', 'g', 0, 42, GETDATE(), NULL)
INSERT POS_Option_Group_List (pos_option_group_id, pos_option_id, value, client_id, value_editable_flag, last_modified_user_id, last_modified_timestamp)
VALUES (@POSOptionGroupId, @POSOptionId, 'C:\Program Files\Radiant\CSSData', @ClientId, 'y', 42, GETDATE())
