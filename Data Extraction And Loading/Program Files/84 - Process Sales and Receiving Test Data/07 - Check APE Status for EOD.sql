select top 100 * from APE_Execution_Queue as q
left join APE_Execution_Document as d
on   q.execution_guid = d.execution_doc_guid
--where convert(varchar(5000), execution_doc) like '%10001715%'
--where execution_status_code = 'e'
where execution_queued_timestamp > '2019-05-14 09:20:13.070'
--and execution_status_code = 'e'
--and execution_moniker  like '%SCM_IM_POS%'
--and execution_moniker not like '%RadXML%'
--and execution_moniker like '%eod%'

--and execution_status_code = 'c'
--where convert(varchar(5000), execution_doc) like '%10001933%'
order by execution_queued_timestamp desc