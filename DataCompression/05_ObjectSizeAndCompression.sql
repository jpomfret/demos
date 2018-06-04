SELECT
	schema_name(obj.SCHEMA_ID) as SchemaName,
	obj.name as TableName,
	ind.name as IndexName,
	ind.type_desc as IndexType,
	pas.row_count as NumberOfRows,
	pas.used_page_count as UsedPageCount,
	(pas.used_page_count * 8)/1024 as SizeUsedMB,
	par.data_compression_desc as DataCompression,
	(pas.reserved_page_count * 8)/1024 as SizeReservedMB
FROM sys.objects obj
INNER JOIN sys.indexes ind
	ON obj.object_id = ind.object_id
INNER JOIN sys.partitions par
	ON par.index_id = ind.index_id
	AND par.object_id = obj.object_id
INNER JOIN sys.dm_db_partition_stats pas
	ON pas.partition_id = par.partition_id
WHERE obj.schema_id <> 4
	--AND schema_name(obj.schema_id) = 'schemaName'
	AND obj.name = 'SalesOrderDetail'
ORDER BY SizeUsedMB desc

-- End of Demo 1