/*****************************************************************************
*   FileName:  Create Enlarged AdventureWorks Tables.sql
*
*   Summary: Creates an enlarged version of the AdventureWorks database
*            for use in demonstrating SQL Server performance tuning and
*            execution plan issues.
*
*   Date: November 14, 2011
*
*   SQL Server Versions:
*         2008, 2008R2, 2012
*
******************************************************************************
*   Copyright (C) 2011 Jonathan M. Kehayias, SQLskills.com
*   All rights reserved.
*
*   For more scripts and sample code, check out
*      http://sqlskills.com/blogs/jonathan
*
*   You may alter this code for your own *non-commercial* purposes. You may
*   republish altered code as long as you include this copyright and give
*	due credit.
*
*
*   THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF
*   ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED
*   TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
*   PARTICULAR PURPOSE.
*
******************************************************************************/

-- POMFRET - Added database name to FROM statements so tables can be created in seperate db

USE SalesOrderLarge;
GO

IF OBJECT_ID('Sales.SalesOrderHeaderEnlarged_PAGE') IS NOT NULL
	DROP TABLE Sales.SalesOrderHeaderEnlarged_PAGE;
GO

CREATE TABLE Sales.SalesOrderHeaderEnlarged_PAGE
	(
	SalesOrderID int NOT NULL IDENTITY (1, 1) NOT FOR REPLICATION,
	RevisionNumber tinyint NOT NULL,
	OrderDate datetime NOT NULL,
	DueDate datetime NOT NULL,
	ShipDate datetime NULL,
	Status tinyint NOT NULL,
	OnlineOrderFlag dbo.Flag NOT NULL,
	SalesOrderNumber  AS (isnull(N'SO'+CONVERT([nvarchar](23),[SalesOrderID],0),N'*** ERROR ***')),
	PurchaseOrderNumber dbo.OrderNumber NULL,
	AccountNumber dbo.AccountNumber NULL,
	CustomerID int NOT NULL,
	SalesPersonID int NULL,
	TerritoryID int NULL,
	BillToAddressID int NOT NULL,
	ShipToAddressID int NOT NULL,
	ShipMethodID int NOT NULL,
	CreditCardID int NULL,
	CreditCardApprovalCode varchar(15) NULL,
	CurrencyRateID int NULL,
	SubTotal money NOT NULL,
	TaxAmt money NOT NULL,
	Freight money NOT NULL,
	TotalDue  AS (isnull(([SubTotal]+[TaxAmt])+[Freight],(0))),
	Comment nvarchar(128) NULL,
	rowguid uniqueidentifier NOT NULL ROWGUIDCOL,
	ModifiedDate datetime NOT NULL
	)  ON [PRIMARY]
GO

SET IDENTITY_INSERT Sales.SalesOrderHeaderEnlarged_PAGE ON
GO
INSERT INTO Sales.SalesOrderHeaderEnlarged_PAGE (SalesOrderID, RevisionNumber, OrderDate, DueDate, ShipDate, Status, OnlineOrderFlag, PurchaseOrderNumber, AccountNumber, CustomerID, SalesPersonID, TerritoryID, BillToAddressID, ShipToAddressID, ShipMethodID, CreditCardID, CreditCardApprovalCode, CurrencyRateID, SubTotal, TaxAmt, Freight, Comment, rowguid, ModifiedDate)
SELECT SalesOrderID, RevisionNumber, OrderDate, DueDate, ShipDate, Status, OnlineOrderFlag, PurchaseOrderNumber, AccountNumber, CustomerID, SalesPersonID, TerritoryID, BillToAddressID, ShipToAddressID, ShipMethodID, CreditCardID, CreditCardApprovalCode, CurrencyRateID, SubTotal, TaxAmt, Freight, Comment, rowguid, ModifiedDate
FROM AdventureWorks2017.Sales.SalesOrderHeader WITH (HOLDLOCK TABLOCKX)
GO
SET IDENTITY_INSERT Sales.SalesOrderHeaderEnlarged_PAGE OFF

GO
ALTER TABLE Sales.SalesOrderHeaderEnlarged_PAGE ADD CONSTRAINT
	PK_SalesOrderHeaderEnlarged_PAGE_SalesOrderID PRIMARY KEY CLUSTERED
	(
	SalesOrderID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO

CREATE UNIQUE NONCLUSTERED INDEX AK_SalesOrderHeaderEnlarged_PAGE_rowguid ON Sales.SalesOrderHeaderEnlarged_PAGE
	(
	rowguid
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

CREATE UNIQUE NONCLUSTERED INDEX AK_SalesOrderHeaderEnlarged_PAGE_SalesOrderNumber ON Sales.SalesOrderHeaderEnlarged_PAGE
	(
	SalesOrderNumber
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX IX_SalesOrderHeaderEnlarged_PAGE_CustomerID ON Sales.SalesOrderHeaderEnlarged_PAGE
	(
	CustomerID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX IX_SalesOrderHeaderEnlarged_PAGE_SalesPersonID ON Sales.SalesOrderHeaderEnlarged_PAGE
	(
	SalesPersonID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

IF OBJECT_ID('Sales.SalesOrderDetailEnlarged_PAGE') IS NOT NULL
	DROP TABLE Sales.SalesOrderDetailEnlarged_PAGE;
GO
CREATE TABLE Sales.SalesOrderDetailEnlarged_PAGE
	(
	SalesOrderID int NOT NULL,
	SalesOrderDetailID int NOT NULL IDENTITY (1, 1),
	CarrierTrackingNumber nvarchar(25) NULL,
	OrderQty smallint NOT NULL,
	ProductID int NOT NULL,
	SpecialOfferID int NOT NULL,
	UnitPrice money NOT NULL,
	UnitPriceDiscount money NOT NULL,
	LineTotal  AS (isnull(([UnitPrice]*((1.0)-[UnitPriceDiscount]))*[OrderQty],(0.0))),
	rowguid uniqueidentifier NOT NULL ROWGUIDCOL,
	ModifiedDate datetime NOT NULL
	)  ON [PRIMARY]
GO

SET IDENTITY_INSERT Sales.SalesOrderDetailEnlarged_PAGE ON
GO
INSERT INTO Sales.SalesOrderDetailEnlarged_PAGE (SalesOrderID, SalesOrderDetailID, CarrierTrackingNumber, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount, rowguid, ModifiedDate)
SELECT SalesOrderID, SalesOrderDetailID, CarrierTrackingNumber, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount, rowguid, ModifiedDate
FROM AdventureWorks2017.Sales.SalesOrderDetail WITH (HOLDLOCK TABLOCKX)
GO
SET IDENTITY_INSERT Sales.SalesOrderDetailEnlarged_PAGE OFF
GO
ALTER TABLE Sales.SalesOrderDetailEnlarged_PAGE ADD CONSTRAINT
	PK_SalesOrderDetailEnlarged_PAGE_SalesOrderID_SalesOrderDetailID PRIMARY KEY CLUSTERED
	(
	SalesOrderID,
	SalesOrderDetailID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE UNIQUE NONCLUSTERED INDEX AK_SalesOrderDetailEnlarged_PAGE_rowguid ON Sales.SalesOrderDetailEnlarged_PAGE
	(
	rowguid
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_SalesOrderDetailEnlarged_PAGE_ProductID ON Sales.SalesOrderDetailEnlarged_PAGE
	(
	ProductID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


BEGIN TRANSACTION


DECLARE @TableVar TABLE
(OrigSalesOrderID int, NewSalesOrderID int)

INSERT INTO Sales.SalesOrderHeaderEnlarged_PAGE
	(RevisionNumber, OrderDate, DueDate, ShipDate, Status, OnlineOrderFlag,
	 PurchaseOrderNumber, AccountNumber, CustomerID, SalesPersonID, TerritoryID,
	 BillToAddressID, ShipToAddressID, ShipMethodID, CreditCardID,
	 CreditCardApprovalCode, CurrencyRateID, SubTotal, TaxAmt, Freight, Comment,
	 rowguid, ModifiedDate)
OUTPUT inserted.Comment, inserted.SalesOrderID
	INTO @TableVar
SELECT RevisionNumber, DATEADD(dd, number, OrderDate) AS OrderDate,
	 DATEADD(dd, number, DueDate),  DATEADD(dd, number, ShipDate),
	 Status, OnlineOrderFlag,
	 PurchaseOrderNumber,
	 AccountNumber,
	 CustomerID, SalesPersonID, TerritoryID, BillToAddressID,
	 ShipToAddressID, ShipMethodID, CreditCardID, CreditCardApprovalCode,
	 CurrencyRateID, SubTotal, TaxAmt, Freight, SalesOrderID,
	 NEWID(), DATEADD(dd, number, ModifiedDate)
FROM AdventureWorks2017.Sales.SalesOrderHeader AS soh WITH (HOLDLOCK TABLOCKX)
CROSS JOIN (
		SELECT number
		FROM (	SELECT TOP 10 number
				FROM master.dbo.spt_values
				WHERE type = N'P'
				  AND number < 1000
				ORDER BY NEWID() DESC
			UNION
				SELECT TOP 10 number
				FROM master.dbo.spt_values
				WHERE type = N'P'
				  AND number < 1000
				ORDER BY NEWID() DESC
			UNION
				SELECT TOP 10 number
				FROM master.dbo.spt_values
				WHERE type = N'P'
				  AND number < 1000
				ORDER BY NEWID() DESC
			UNION
				SELECT TOP 10 number
				FROM master.dbo.spt_values
				WHERE type = N'P'
				  AND number < 1000
				ORDER BY NEWID() DESC
		  ) AS tab
) AS Randomizer
ORDER BY OrderDate, number

INSERT INTO Sales.SalesOrderDetailEnlarged_PAGE
	(SalesOrderID, CarrierTrackingNumber, OrderQty, ProductID,
	 SpecialOfferID, UnitPrice, UnitPriceDiscount, rowguid, ModifiedDate)
SELECT
	tv.NewSalesOrderID, CarrierTrackingNumber, OrderQty, ProductID,
	SpecialOfferID, UnitPrice, UnitPriceDiscount, NEWID(), ModifiedDate
FROM AdventureWorks2017.Sales.SalesOrderDetail AS sod
JOIN @TableVar AS tv
	ON sod.SalesOrderID = tv.OrigSalesOrderID
ORDER BY sod.SalesOrderDetailID

COMMIT

-- PAGE COMPRESS


-- PAGE COMPRESS
-- Apply compression to the CL
ALTER TABLE [Sales].[SalesOrderHeaderEnlarged_PAGE] REBUILD PARTITION = ALL
WITH (DATA_COMPRESSION = PAGE)

ALTER TABLE [Sales].[SalesOrderDetailEnlarged_PAGE] REBUILD PARTITION = ALL
WITH (DATA_COMPRESSION = PAGE)

-- Apply compression to the indexes
ALTER INDEX ALL
ON [Sales].[SalesOrderHeaderEnlarged_PAGE] REBUILD PARTITION = ALL
WITH (DATA_COMPRESSION = PAGE)

ALTER INDEX ALL
ON [Sales].[SalesOrderDetailEnlarged_PAGE] REBUILD PARTITION = ALL
WITH (DATA_COMPRESSION = PAGE)