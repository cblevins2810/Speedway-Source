BEGIN TRANSACTION

DECLARE @MenuId INT
DECLARE @FrameGroupId INT

SELECT @MenuId = MIN(menu_id)
FROM   pos_menu
WHERE  menu_type_id = 3

SELECT @FrameGroupId = flg.pos_frame_group_id
FROM POS_Menu_Frame_Group_List AS flg
JOIN POS_Frame AS pf
ON   flg.frame_id = pf.frame_id
WHERE menu_id = @MenuId
AND  POS_Frame_Template_id = 7

SELECT @MenuId, @FrameGroupId

SELECT *
FROM POS_Menu_Frame_Group_List AS flg
JOIN POS_Frame AS pf
ON   flg.frame_id = pf.frame_id
WHERE menu_id = @MenuId
AND  POS_Frame_Template_id = 7

DELETE POS_Menu_Frame_Group_List
WHERE  menu_id = @MenuId
AND    pos_frame_group_id = @FrameGroupId

SELECT *
FROM POS_Menu_Frame_Group_List AS flg
JOIN POS_Frame AS pf
ON   flg.frame_id = pf.frame_id
WHERE menu_id = @MenuId
AND  POS_Frame_Template_id = 7

-- ROLLBACK TRANSACTION
COMMIT TRANSACTION