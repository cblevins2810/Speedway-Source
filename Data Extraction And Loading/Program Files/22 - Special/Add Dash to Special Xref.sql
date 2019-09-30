begin transaction

select xref_code, * from retail_auto_combo
where xref_code not like '%-%'

update retail_auto_combo
set xref_code = xref_code + '-'
where xref_code not like '%-%'

select xref_code, * from retail_auto_combo
where xref_code not like '%-%'

commit transaction