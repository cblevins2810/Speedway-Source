/* This script adds missing time zone information to the ESO database.  This data was determined to be missing based upon
   errors received during the business unit import process and observing the SQL trace that generated the errors.  */

if not exists (select 1 from Time_Zone_Defn where time_zone_defn_id = -2147466925)
begin
	insert Time_Zone_Defn (time_zone_defn_id,name,last_modified_user_id,last_modified_timestamp,client_id)
	select -2147466925,'Central Standard Time',42,'2013-04-07 20:33:52.730',0
	insert Time_Zone_Defn_Time_Zone_DEA (time_zone_defn_id, start_date, time_zone_id, last_modified_user_id, last_modified_timestamp, client_id)
	select -2147466925,	'2013-04-07 00:00:00',-2147466925,42,'2013-04-07 20:33:52.730',0
end

if not exists (select 1 from Time_Zone_Defn where time_zone_defn_id = -2147463257)
begin
	insert Time_Zone_Defn (time_zone_defn_id,name,last_modified_user_id,last_modified_timestamp,client_id)
	select -2147463257,'Central America Standard Time',42,'2013-04-07 20:33:52.730',0
	insert Time_Zone_Defn_Time_Zone_DEA (time_zone_defn_id, start_date, time_zone_id, last_modified_user_id, last_modified_timestamp, client_id)
	select -2147463257,	'2013-04-07 00:00:00',-2147463257,42,'2013-04-07 20:33:52.730',0
end

if not exists (select 1 from Time_Zone_Defn where time_zone_defn_id = 8)
begin
	insert Time_Zone_Defn (time_zone_defn_id,name,last_modified_user_id,last_modified_timestamp,client_id)
	select 8,'Central Time (US & Canada)-Mexico City (GMT -6:00)',42,'2013-04-07 20:33:52.730',0
	insert Time_Zone_Defn_Time_Zone_DEA (time_zone_defn_id, start_date, time_zone_id, last_modified_user_id, last_modified_timestamp, client_id)
	select 8,'2013-04-07 00:00:00',8,42,'2013-04-07 20:33:52.730',0
end

if not exists (select 1 from Time_Zone_Defn where time_zone_defn_id = 12)
begin
	insert Time_Zone_Defn (time_zone_defn_id,name,last_modified_user_id,last_modified_timestamp,client_id)
	select 12,'Eastern Time (US & Canada) (GMT -5:00)',42,'2013-04-07 20:33:52.730',0
	insert Time_Zone_Defn_Time_Zone_DEA (time_zone_defn_id, start_date, time_zone_id, last_modified_user_id, last_modified_timestamp, client_id)
	select 12,'2013-04-07 00:00:00',12,42,'2013-04-07 20:33:52.730',0
end

if not exists (select 1 from Time_Zone_Defn where time_zone_defn_id = 6)
begin
	insert Time_Zone_Defn (time_zone_defn_id,name,last_modified_user_id,last_modified_timestamp,client_id)
	select 6,'US Mountain Standard Time (GMT -7:00)',42,'2013-04-07 20:33:52.730',0
	insert Time_Zone_Defn_Time_Zone_DEA (time_zone_defn_id, start_date, time_zone_id, last_modified_user_id, last_modified_timestamp, client_id)
	select 6,'2013-04-07 00:00:00',6,42,'2013-04-07 20:33:52.730',0
end

if not exists (select 1 from Time_Zone_Defn where time_zone_defn_id = 7)
begin
	insert Time_Zone_Defn (time_zone_defn_id,name,last_modified_user_id,last_modified_timestamp,client_id)
	select 7,'Mountain Standard Time (GMT -7:00)',42,'2013-04-07 20:33:52.730',0
	insert Time_Zone_Defn_Time_Zone_DEA (time_zone_defn_id, start_date, time_zone_id, last_modified_user_id, last_modified_timestamp, client_id)
	select 7,'2013-04-07 00:00:00',7,42,'2013-04-07 20:33:52.730',0
end

if not exists (select 1 from Time_Zone_Defn where time_zone_defn_id = -2147466915)
begin
	insert Time_Zone_Defn (time_zone_defn_id,name,last_modified_user_id,last_modified_timestamp,client_id)
	select -2147466915,'Pacific Standard Time',42,'2013-04-07 20:33:52.730',0
	insert Time_Zone_Defn_Time_Zone_DEA (time_zone_defn_id, start_date, time_zone_id, last_modified_user_id, last_modified_timestamp, client_id)
	select -2147466915,'2013-04-07 00:00:00',-2147466915,42,'2013-04-07 20:33:52.730',0
end

if not exists (select 1 from Time_Zone_Defn where time_zone_defn_id = 3)
begin
	insert Time_Zone_Defn (time_zone_defn_id,name,last_modified_user_id,last_modified_timestamp,client_id)
	select 3,'Hawaiian Standard Time',42,'2013-04-07 20:33:52.730',0
	insert Time_Zone_Defn_Time_Zone_DEA (time_zone_defn_id, start_date, time_zone_id, last_modified_user_id, last_modified_timestamp, client_id)
	select 3,'2013-04-07 00:00:00',3,42,'2013-04-07 20:33:52.730',0
end

if not exists (select 1 from Time_Zone_Defn where time_zone_defn_id = 4)
begin
	insert Time_Zone_Defn (time_zone_defn_id,name,last_modified_user_id,last_modified_timestamp,client_id)
	select 4,'Alaskan Standard Time',42,'2013-04-07 20:33:52.730',0
	insert Time_Zone_Defn_Time_Zone_DEA (time_zone_defn_id, start_date, time_zone_id, last_modified_user_id, last_modified_timestamp, client_id)
	select 4,'2013-04-07 00:00:00',4,42,'2013-04-07 20:33:52.730',0
end

