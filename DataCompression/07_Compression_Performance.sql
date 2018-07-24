
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

select soh.SalesOrderID, *
from sales.SalesOrderHeaderEnlarged soh
inner join sales.SalesOrderDetailEnlarged sod
	on soh.SalesOrderID = sod.SalesOrderID
where LEFT(CarrierTrackingNumber,4) = 'D0CE'
OPTION (MAXDOP 1)


DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS

select soh.SalesOrderID, soh.orderdate, soh.Freight, sod.LineTotal
from sales.SalesOrderHeaderEnlarged_ROW soh
inner join sales.SalesOrderDetailEnlarged_ROW sod
	on soh.SalesOrderID = sod.SalesOrderID
where LEFT(CarrierTrackingNumber,4) = 'D0CE'
OPTION (MAXDOP 1)


DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS

select soh.SalesOrderID, *
from sales.SalesOrderHeaderEnlarged_PAGE soh
inner join sales.SalesOrderDetailEnlarged_PAGE sod
	on soh.SalesOrderID = sod.SalesOrderID
where LEFT(CarrierTrackingNumber,4) = 'D0CE'
OPTION (MAXDOP 1)
