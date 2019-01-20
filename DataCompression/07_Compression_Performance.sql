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

--SQL Server parse and compile time: 
--   CPU time = 7 ms, elapsed time = 12 ms.
--
--(1400 rows affected)
--Table 'SalesOrderHeaderEnlarged'. Scan count 0, logical reads 7664, physical reads 1, read-ahead reads 80, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
--Table 'SalesOrderDetailEnlarged'. Scan count 1, logical reads 73824, physical reads 1, read-ahead reads 73991, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
--
-- SQL Server Execution Times:
--   CPU time = 3052 ms,  elapsed time = 3813 ms.


DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS

select sod.CarrierTrackingNumber, soh.SalesOrderID, soh.orderdate, soh.Freight, sod.LineTotal
from sales.SalesOrderHeaderEnlarged_ROW soh
inner join sales.SalesOrderDetailEnlarged_ROW sod
	on soh.SalesOrderID = sod.SalesOrderID
where LEFT(CarrierTrackingNumber,4) = 'D0CE'
OPTION (MAXDOP 1)

--SQL Server parse and compile time: 
--   CPU time = 7 ms, elapsed time = 13 ms.
--
--(1435 rows affected)
--Table 'SalesOrderHeaderEnlarged_ROW'. Scan count 0, logical reads 6847, physical reads 7, read-ahead reads 320, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
--Table 'SalesOrderDetailEnlarged_ROW'. Scan count 1, logical reads 35677, physical reads 1, read-ahead reads 35682, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
--
-- SQL Server Execution Times:
--   CPU time = 1384 ms,  elapsed time = 1415 ms.


DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS

select sod.CarrierTrackingNumber, soh.SalesOrderID, soh.orderdate, soh.Freight, sod.LineTotal
from sales.SalesOrderHeaderEnlarged_PAGE soh
inner join sales.SalesOrderDetailEnlarged_PAGE sod
	on soh.SalesOrderID = sod.SalesOrderID
where LEFT(CarrierTrackingNumber,4) = 'D0CE'
OPTION (MAXDOP 1)

--SQL Server parse and compile time: 
--   CPU time = 6 ms, elapsed time = 28 ms.
--
--(1435 rows affected)
--Table 'SalesOrderHeaderEnlarged_PAGE'. Scan count 0, logical reads 7176, physical reads 1, read-ahead reads 352, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
--Table 'SalesOrderDetailEnlarged_PAGE'. Scan count 1, logical reads 24866, physical reads 1, read-ahead reads 24864, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
--
-- SQL Server Execution Times:
--   CPU time = 1381 ms,  elapsed time = 1389 ms.
