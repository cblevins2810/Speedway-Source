/* Add the default set of services.  This is to avoid manual UI work */
DECLARE @ClientId INT
SELECT @ClientId = MAX(Client_id) FROM Rad_Sys_Client


INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, -2147481038, N'a', 42, CAST(N'2018-10-02T08:25:24.810' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, -2147480416, N'a', 42, CAST(N'2018-10-02T08:25:24.500' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, -2147476467, N'a', 42, CAST(N'2018-10-02T08:25:24.860' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, -2147442861, N'a', 42, CAST(N'2018-10-02T08:25:25.140' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, -2147436911, N'a', 42, CAST(N'2018-10-02T08:25:24.577' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, -2147435456, N'a', 42, CAST(N'2018-10-02T08:25:24.967' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, -2147432329, N'a', 42, CAST(N'2018-10-02T08:25:24.953' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, -2147392558, N'a', 42, CAST(N'2018-10-02T08:25:24.687' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, -2147392557, N'a', 42, CAST(N'2018-10-02T08:25:24.513' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 200, N'a', 42, CAST(N'2018-09-27T13:42:30.307' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 18220, N'a', 42, CAST(N'2018-09-27T13:42:30.307' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 18222, N'a', 42, CAST(N'2018-09-27T13:42:30.307' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 18225, N'a', 42, CAST(N'2018-10-02T08:22:03.160' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 18226, N'a', 42, CAST(N'2018-09-27T13:33:51.930' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 18227, N'a', 42, CAST(N'2018-09-27T13:33:51.917' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 18228, N'a', 42, CAST(N'2018-09-27T13:42:30.307' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 18229, N'a', 42, CAST(N'2018-09-27T13:42:30.307' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 18237, N'a', 42, CAST(N'2018-09-27T13:42:30.320' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 18242, N'a', 42, CAST(N'2018-09-27T13:42:30.320' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 18246, N'a', 42, CAST(N'2018-09-27T13:42:30.320' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 18247, N'a', 42, CAST(N'2018-09-27T13:42:30.320' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 18257, N'a', 42, CAST(N'2018-09-27T13:42:30.320' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 18268, N'a', 42, CAST(N'2018-09-27T13:42:30.320' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 18271, N'a', 42, CAST(N'2018-10-02T08:22:03.173' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 18272, N'a', 42, CAST(N'2018-10-02T08:22:03.300' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 18273, N'a', 42, CAST(N'2018-10-02T08:22:03.363' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 18286, N'a', 42, CAST(N'2018-10-02T08:25:24.547' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 18287, N'a', 42, CAST(N'2018-09-27T13:42:30.320' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 18492, N'a', 42, CAST(N'2018-09-27T13:42:30.320' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 18602, N'a', 42, CAST(N'2018-09-27T13:42:30.320' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 18607, N'a', 42, CAST(N'2018-10-02T08:25:24.983' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 18610, N'a', 42, CAST(N'2018-09-27T13:42:30.320' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 18615, N'a', 42, CAST(N'2018-09-27T13:42:30.400' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 18616, N'a', 42, CAST(N'2018-09-27T13:42:30.400' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38617, N'a', 42, CAST(N'2018-09-27T13:42:30.400' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38619, N'a', 42, CAST(N'2018-09-27T13:42:30.400' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38623, N'a', 42, CAST(N'2018-10-02T08:22:03.317' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38624, N'a', 42, CAST(N'2018-10-02T08:22:03.127' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38625, N'a', 42, CAST(N'2018-09-27T13:42:30.400' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38627, N'a', 42, CAST(N'2018-09-27T13:42:30.400' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38628, N'a', 42, CAST(N'2018-09-27T13:42:30.400' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38629, N'a', 42, CAST(N'2018-09-27T13:42:30.400' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38630, N'a', 42, CAST(N'2018-09-27T13:42:30.400' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38634, N'a', 42, CAST(N'2018-09-27T13:42:30.400' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38649, N'a', 42, CAST(N'2018-10-02T08:22:03.283' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38650, N'a', 42, CAST(N'2018-10-02T08:22:03.330' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38651, N'a', 42, CAST(N'2018-09-27T13:42:30.400' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38657, N'a', 42, CAST(N'2018-10-02T08:25:24.530' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38661, N'a', 42, CAST(N'2018-09-27T13:42:30.400' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38662, N'a', 42, CAST(N'2018-09-27T13:42:30.400' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38663, N'a', 42, CAST(N'2018-09-27T13:42:30.400' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38669, N'a', 42, CAST(N'2018-10-02T08:25:24.733' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38670, N'a', 42, CAST(N'2018-10-02T08:25:24.203' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38671, N'a', 42, CAST(N'2018-10-02T08:25:24.263' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38673, N'a', 42, CAST(N'2018-10-02T08:25:24.437' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38674, N'a', 42, CAST(N'2018-09-27T13:42:30.413' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38682, N'a', 42, CAST(N'2018-09-27T13:42:30.413' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38683, N'a', 42, CAST(N'2018-09-27T13:42:30.413' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38685, N'a', 42, CAST(N'2018-09-27T13:42:30.413' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38686, N'a', 42, CAST(N'2018-09-27T13:42:30.413' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38695, N'a', 42, CAST(N'2018-09-27T13:42:30.413' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38696, N'a', 42, CAST(N'2018-09-27T13:42:30.413' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38702, N'a', 42, CAST(N'2018-09-27T13:42:30.413' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38711, N'a', 42, CAST(N'2018-09-27T13:42:30.413' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38717, N'a', 42, CAST(N'2018-09-27T13:42:30.413' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38718, N'a', 42, CAST(N'2018-09-27T13:42:30.413' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38743, N'a', 42, CAST(N'2018-09-27T13:42:30.413' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38745, N'a', 42, CAST(N'2018-09-27T13:42:30.413' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38747, N'a', 42, CAST(N'2018-10-02T08:25:24.187' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38794, N'a', 42, CAST(N'2018-09-27T13:42:30.413' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38802, N'a', 42, CAST(N'2018-10-02T08:22:03.220' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38803, N'a', 42, CAST(N'2018-09-27T13:42:30.413' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38804, N'a', 42, CAST(N'2018-09-27T13:42:30.413' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38807, N'a', 42, CAST(N'2018-10-02T08:25:24.280' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38808, N'a', 42, CAST(N'2018-09-27T13:42:30.413' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38811, N'a', 42, CAST(N'2018-09-27T13:42:30.413' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38814, N'a', 42, CAST(N'2018-09-27T13:42:30.413' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38816, N'a', 42, CAST(N'2018-09-27T13:42:30.413' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38817, N'a', 42, CAST(N'2018-09-27T13:42:30.413' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38822, N'a', 42, CAST(N'2018-10-02T08:25:24.843' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38823, N'a', 42, CAST(N'2018-10-02T08:25:24.467' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38825, N'a', 42, CAST(N'2018-09-27T13:42:30.413' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38826, N'a', 42, CAST(N'2018-10-02T08:25:24.920' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38831, N'a', 42, CAST(N'2018-09-27T13:42:30.413' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38835, N'a', 42, CAST(N'2018-10-02T08:25:24.827' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38837, N'a', 42, CAST(N'2018-10-02T08:25:25.077' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38840, N'a', 42, CAST(N'2018-09-27T13:42:30.413' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38859, N'a', 42, CAST(N'2018-09-27T13:42:30.510' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38870, N'a', 42, CAST(N'2018-09-27T13:42:30.510' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38873, N'a', 42, CAST(N'2018-10-02T08:25:24.797' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38874, N'a', 42, CAST(N'2018-10-02T08:25:24.937' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38882, N'a', 42, CAST(N'2018-10-02T08:25:24.453' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38892, N'a', 42, CAST(N'2018-10-02T08:22:03.207' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38897, N'a', 42, CAST(N'2018-10-02T08:22:03.190' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38901, N'a', 42, CAST(N'2018-09-27T13:42:30.510' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38905, N'a', 42, CAST(N'2018-10-02T08:25:25.123' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38906, N'a', 42, CAST(N'2018-09-27T13:42:30.510' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38908, N'a', 42, CAST(N'2018-10-02T08:25:25.060' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38909, N'a', 42, CAST(N'2018-09-27T13:42:30.510' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38913, N'a', 42, CAST(N'2018-10-02T08:25:24.310' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38915, N'a', 42, CAST(N'2018-10-02T08:25:24.750' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38916, N'a', 42, CAST(N'2018-10-02T08:25:24.297' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38917, N'a', 42, CAST(N'2018-10-02T08:25:24.717' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38918, N'a', 42, CAST(N'2018-09-27T13:42:30.510' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38920, N'a', 42, CAST(N'2018-10-02T08:25:24.170' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38933, N'a', 42, CAST(N'2018-09-27T13:42:30.510' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38935, N'a', 42, CAST(N'2018-09-27T13:42:30.510' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38936, N'a', 42, CAST(N'2018-10-02T08:25:24.593' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38937, N'a', 42, CAST(N'2018-10-02T08:25:24.233' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38938, N'a', 42, CAST(N'2018-10-02T08:25:24.703' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38939, N'a', 42, CAST(N'2018-10-02T08:25:24.250' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38940, N'a', 42, CAST(N'2018-10-02T08:25:24.640' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38943, N'a', 42, CAST(N'2018-10-02T08:25:25.110' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38947, N'a', 42, CAST(N'2018-09-27T13:42:30.510' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38953, N'a', 42, CAST(N'2018-09-27T13:42:30.510' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38962, N'a', 42, CAST(N'2018-10-02T08:25:25.047' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38965, N'a', 42, CAST(N'2018-10-02T08:25:24.657' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38966, N'a', 42, CAST(N'2018-10-02T08:22:03.237' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38967, N'a', 42, CAST(N'2018-10-02T08:25:24.890' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38973, N'a', 42, CAST(N'2018-10-02T08:25:24.560' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38978, N'a', 42, CAST(N'2018-10-02T08:25:24.780' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38979, N'a', 42, CAST(N'2018-10-02T08:25:24.623' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38981, N'a', 42, CAST(N'2018-10-02T08:25:24.907' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 38997, N'a', 42, CAST(N'2018-10-02T08:22:03.253' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 39004, N'a', 42, CAST(N'2018-10-02T08:25:25.030' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 39013, N'a', 42, CAST(N'2018-10-02T08:25:25.013' AS DateTime), NULL)
INSERT [dbo].[Rad_Sys_Client_Service] ([client_id], [service_id], [status_code], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (@ClientId, 39034, N'a', 42, CAST(N'2018-09-27T13:42:30.510' AS DateTime), NULL)
