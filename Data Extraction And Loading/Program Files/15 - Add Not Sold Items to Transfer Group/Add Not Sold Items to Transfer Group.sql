SET NOCOUNT ON


-- Temp Table variable to hold item/group list
DECLARE @tInvItemGroupList table
(
	log_seq					INT IDENTITY(1,1),
	item_group_id			INT NOT NULL,
	inventory_item_id		INT NOT NULL,
	last_modified_user_id	INT NOT NULL,
	sort_order				INT NOT NULL,
	last_modified_timestamp	[DATETIME] NOT NULL,
	client_id				INT NOT NULL
 )

-- Declare variables
DECLARE	@ClientId			INT
DECLARE	@ItemGroupId		INT


-- Set Variables
SELECT	@ClientId		= MAX(client_id)
FROM	Rad_Sys_Client

SELECT	@ItemGroupId	= item_group_id
FROM	inventory_item_group
WHERE	name = 'Transfer Group'


-- Get all information in temp table
INSERT INTO	@tInvItemGroupList
			(
				item_group_id,
				inventory_item_id,
				last_modified_user_id,
				sort_order,
				last_modified_timestamp,
				client_id		
			)
SELECT		@ItemGroupId, i.item_id, 42, 0, GETDATE(), @ClientId
FROM		item							AS i
JOIN		item_hierarchy					AS ih
ON			i.item_hierarchy_id				= ih.item_hierarchy_id
JOIN		item_hierarchy_list				AS ihl
ON			ih.item_hierarchy_id			= ihl.item_hierarchy_id
JOIN		item_hierarchy					AS ihdept
ON			ihl.parent_item_hierarchy_id	= ihdept.item_hierarchy_id
JOIN		unit_of_measure_class			AS uomc
ON			i.unit_of_measure_class_id		= uomc.unit_of_measure_class_id
JOIN		inventory_item					AS ii
ON			i.item_id						= ii.inventory_item_id
WHERE		i.item_type_code			= 'i'
AND			i.track_flag				= 'y'
AND			ihl.hierarchy_level			= 3
AND			ihl.parent_hierarchy_level	= 1
AND			ihdept.name IN
			(
				'201 Alternative Food Service',
				'206 Franchise Food',
				'212 Hot Beverage',
				'215 Cold Beverage',
				'218 Pre-Packaged Food Service',
				'221 Prepared Food Service',
				'231 Food Service Bakery',
				'76 Office Supplies',
				'77 Store Supplies',
				'94 M&S Food',
				'95 M&S Petroleum'
			)
AND 		NOT  EXISTS (SELECT 1 FROM recipe_item AS r
						WHERE r.recipe_item_id = i.item_id)



-- Insert only if no records exist yet for the item id/item_group id in the list
MERGE INTO	inventory_item_group_list				AS tgt
USING		@tInvItemGroupList						AS src
ON			tgt.item_group_id						= src.item_group_id
AND			tgt.inventory_item_id					= src.inventory_item_id
AND			tgt.client_id							= src.client_id
WHEN NOT MATCHED BY TARGET THEN
INSERT
	(
		item_group_id,
		inventory_item_id,
		last_modified_user_id,
		sort_order,
		last_modified_timestamp,
		client_id
	)
	VALUES
	(
		src.item_group_id,
		src.inventory_item_id,
		src.last_modified_user_id,
		src.sort_order,
		src.last_modified_timestamp,
		src.client_id
	);


