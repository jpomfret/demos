
Use AdventureWorks2016

-- 1) sp_estimate_data_compression_savings
-- 2 seconds


-- Row compression 
exec sp_estimate_data_compression_savings 'Sales','SalesOrderDetail',NULL,NULL,'ROW'
-- index id 7 - NC Unique index on rowguid

-- Page compression
exec sp_estimate_data_compression_savings 'Sales','SalesOrderDetail',NULL,NULL,'PAGE'

-- 2) SSMS GUI
-- Right click on table or index > Storage > Manage Compression

