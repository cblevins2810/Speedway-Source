SELECT i.name
FROM Fcst_Group AS fg
JOIN Metric_Group AS mg
ON   fg.metric_group_id = mg.metric_group_id
JOIN Metric_Group_Dimension_List AS mgdl
ON   mg.metric_group_id = mgdl.metric_group_id
JOIN Metric AS m
ON   mgdl.metric_id = m.metric_id
JOIN Metric_Group_Dimension_Value_Filter As mgvf
ON   mgvf.metric_group_id = mg.metric_group_id
JOIN Item_hierarchy AS i
ON   i.item_hierarchy_id = mgvf.value_id
WHERE fg.forecast_group_id = 1000002
