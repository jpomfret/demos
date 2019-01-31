Use SalesOrderLarge
-- Lesson in T-SQL Bad practices
	-- Functions in the WHERE Clause - LEFT() - Forces a table scan, LIKE 'ASDF%' would be able to use an index
	-- OPTION (MAXDOP 1) - Force only 1 CPU usage, keeps this test fair, probably best to presume the SQL engine knows best
	-- DBCC FREEPROCCACHE -- Removes all elements from the plan cache
	-- DBCC CLEANBUFFERS -- Removes all clean buffers from the buffer pool

-- Turn on CPU and IO stats
SET STATISTICS TIME ON
SET STATISTICS IO ON

DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS

select sod.CarrierTrackingNumber, soh.SalesOrderID, soh.orderdate, soh.Freight, sod.LineTotal
from sales.SalesOrderHeaderEnlarged soh
inner join sales.SalesOrderDetailEnlarged sod
	on soh.SalesOrderID = sod.SalesOrderID
where LEFT(sod.CarrierTrackingNumber,4) = 'D0CE'
OPTION (MAXDOP 1)

--  SQL Server Execution Times:
--    CPU time = 58 ms,  elapsed time = 57 ms.
-- 
-- (1435 rows affected)
-- Table 'SalesOrderHeaderEnlarged'. Scan count 0, logical reads 7773, physical reads 1, read-ahead reads 419, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
-- Table 'SalesOrderDetailEnlarged'. Scan count 1, logical reads 50791, physical reads 3, read-ahead reads 52243, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
-- 
--  SQL Server Execution Times:
--    CPU time = 3191 ms,  elapsed time = 3745 ms.


DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS

select sod.CarrierTrackingNumber, soh.SalesOrderID, soh.orderdate, soh.Freight, sod.LineTotal
from sales.SalesOrderHeaderEnlarged_ROW soh
inner join sales.SalesOrderDetailEnlarged_ROW sod
	on soh.SalesOrderID = sod.SalesOrderID
where LEFT(CarrierTrackingNumber,4) = 'D0CE'
OPTION (MAXDOP 1)

--  SQL Server Execution Times:
--    CPU time = 8 ms,  elapsed time = 7 ms.
-- 
-- (1435 rows affected)
-- Table 'SalesOrderHeaderEnlarged_ROW'. Scan count 0, logical reads 7228, physical reads 1, read-ahead reads 360, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
-- Table 'SalesOrderDetailEnlarged_ROW'. Scan count 1, logical reads 35677, physical reads 1, read-ahead reads 35669, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
-- 
--  SQL Server Execution Times:
--    CPU time = 1254 ms,  elapsed time = 1270 ms.



DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS

select sod.CarrierTrackingNumber, soh.SalesOrderID, soh.orderdate, soh.Freight, sod.LineTotal
from sales.SalesOrderHeaderEnlarged_PAGE soh
inner join sales.SalesOrderDetailEnlarged_PAGE sod
	on soh.SalesOrderID = sod.SalesOrderID
where LEFT(CarrierTrackingNumber,4) = 'D0CE'
OPTION (MAXDOP 1)

-- SQL Server Execution Times:
--    CPU time = 16 ms,  elapsed time = 15 ms.
-- 
-- (1435 rows affected)
-- Table 'SalesOrderHeaderEnlarged_PAGE'. Scan count 0, logical reads 7201, physical reads 1, read-ahead reads 352, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
-- Table 'SalesOrderDetailEnlarged_PAGE'. Scan count 1, logical reads 24866, physical reads 1, read-ahead reads 24864, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
-- 
--  SQL Server Execution Times:
--    CPU time = 1158 ms,  elapsed time = 1191 ms.

