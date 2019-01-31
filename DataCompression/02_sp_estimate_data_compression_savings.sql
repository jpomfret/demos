
Use AdventureWorks2017

-- 1) sp_estimate_data_compression_savings
-- 5 seconds


-- Row compression 
exec sp_estimate_data_compression_savings 'Sales','SalesOrderDetail',NULL,NULL,'ROW'
-- index id 7 - NC Unique index on rowguid
-- Index 1 - 10048KB --> 7040KB

-- Page compression
exec sp_estimate_data_compression_savings 'Sales','SalesOrderDetail',NULL,NULL,'PAGE'
-- Index 1 - 10048KB --> 4840KB

-- 2) SSMS GUI
-- Right click on table or index > Storage > Manage Compression

