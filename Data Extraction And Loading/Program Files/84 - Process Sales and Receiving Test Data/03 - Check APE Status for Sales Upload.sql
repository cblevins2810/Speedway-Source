select top 100 * from APE_Execution_Queue as q
left join APE_Execution_Document as d
on   q.execution_guid = d.execution_doc_guid
--where execution_status_code = 'e'
where execution_moniker like '%RadXML%'
and   execution_moniker like '%job%'
and execution_queued_timestamp > '2019-05-14 09:10:13.070'
and execution_status_code in ('q', 'e','p')
order by execution_queued_timestamp desc