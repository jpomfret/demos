RAISERROR(N'Did you mean to run the whole thing?',20,1) WITH LOG
GO

USE CompressTest

DROP TABLE IF EXISTS employee

CREATE TABLE employee (
employeeId bigint PRIMARY KEY,
firstName char(100),
lastName char(100),
address1 char(250),
city char(50)
)

INSERT INTO employee
values	(1, 'Alex','Young','2 Sand Run','Akron'),
		(2, 'Richard','Young','77 High St.','Akron'),
		(3, 'Alexis','Young','1 First Ave.','Richfield')

SELECT * FROM employee

-- Find pages in Employee table
DBCC IND ('CompressTest', 'employee', 1);
-- can also use sys.dm_db_database_page_allocations

-- PAGETYPE
	-- 1 = DATA
	-- 2 = INDEX
	-- 10 = IAM PAGE

-- TF to output in messages instead of event log
DBCC TRACEON (3604);
GO
DBCC PAGE('CompressTest',1,456,3)
-- pminlen - size of fixed length records		-- 512
-- m_slotCnt - records on the page				-- 3
-- m_freeCnt - bytes of free space on the page	-- 6545

ALTER TABLE employee REBUILD PARTITION = ALL
WITH (DATA_COMPRESSION = ROW)

-- Find pages in Employee table
DBCC IND ('CompressTest', 'employee', 1);

DBCC PAGE('CompressTest',1,376,3)
-- pminlen - size of fixed length records		-- 5
-- m_slotCnt - records on the page				-- 3
-- m_freeCnt - bytes of free space on the page	-- 7971


ALTER TABLE employee REBUILD PARTITION = ALL
WITH (DATA_COMPRESSION = PAGE)

-- Find pages in Employee table
DBCC IND ('CompressTest', 'employee', 1);

DBCC PAGE('CompressTest',1,432,3)
-- pminlen - size of fixed length records		-- 5
-- m_slotCnt - records on the page				-- 3
-- m_freeCnt - bytes of free space on the page	-- 7971


-- Each row PAGE compressed is about 40 bytes
-- 7971 free / 40 = 200 ish

INSERT INTO employee (employeeId, firstName,lastName, address1, city)
SELECT TOP 200 BusinessEntityID, FirstName, LastName, AddressLine1, CITY FROM AdventureWorks2016.HumanResources.vEmployee WHERE BusinessEntityID > 3

-- Find pages in Employee table
DBCC IND ('CompressTest', 'employee', 1);

DBCC PAGE('CompressTest',1,432,3)
-- pminlen - size of fixed length records		-- 5
-- m_slotCnt - records on the page				-- 3
-- m_freeCnt - bytes of free space on the page	-- 7971
