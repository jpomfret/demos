CREATE DATABASE [AdventureWorks2017] ON
(FILENAME = '/var/opt/sqlserver/AdventureWorks2017.mdf'),
(FILENAME = '/var/opt/sqlserver/AdventureWorks2017_log.ldf') FOR ATTACH;

GO

-- for bug with masking when unique indexes exist
Use AdventureWorks2017
SET QUOTED_IDENTIFIER ON
DROP INDEX [AK_Employee_NationalIDNumber] ON [HumanResources].[Employee]
DROP INDEX [AK_Employee_rowguid] ON [HumanResources].[Employee]
ALTER TABLE [Purchasing].[PurchaseOrderHeader] DROP CONSTRAINT [FK_PurchaseOrderHeader_Employee_EmployeeID]
ALTER TABLE [Sales].[SalesPerson] DROP CONSTRAINT [FK_SalesPerson_Employee_BusinessEntityID]
ALTER TABLE [HumanResources].[JobCandidate] DROP CONSTRAINT [FK_JobCandidate_Employee_BusinessEntityID]
ALTER TABLE [HumanResources].[EmployeePayHistory] DROP CONSTRAINT [FK_EmployeePayHistory_Employee_BusinessEntityID]
ALTER TABLE [HumanResources].[EmployeeDepartmentHistory] DROP CONSTRAINT [FK_EmployeeDepartmentHistory_Employee_BusinessEntityID]
ALTER TABLE [Production].[Document] DROP CONSTRAINT [FK_Document_Employee_Owner]
ALTER TABLE [HumanResources].[Employee] DROP CONSTRAINT [PK_Employee_BusinessEntityID] WITH ( ONLINE = OFF )
DROP INDEX [AK_Employee_LoginID] ON [HumanResources].[Employee]
GO


Use Master
CREATE DATABASE DatabaseAdmin
GO

ALTER DATABASE [AdventureWorks2017] SET RECOVERY FULL ;

BACKUP DATABASE [AdventureWorks2017] TO DISK = N'C:\var\opt\backups\AdventureWorks2017.bak'
WAITFOR DELAY '00:00:05';
BACKUP DATABASE [AdventureWorks2017] TO DISK = N'C:\var\opt\backups\AdventureWorks2017.diff' WITH DIFFERENTIAL
WAITFOR DELAY '00:00:05';
BACKUP LOG [AdventureWorks2017] TO DISK = N'C:\var\opt\backups\AdventureWorks2017.log'