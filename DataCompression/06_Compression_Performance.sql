-- READ
SELECT p.Name AS ProductName, sum((OrderQty * UnitPrice) * (1.0 - UnitPriceDiscount)) as TotalRevenue
FROM Production.Product AS p
INNER JOIN Sales.SalesOrderDetailEnlarged AS sod
ON p.ProductID = sod.ProductID
group by p.Name
ORDER BY ProductName ASC;

-- READ
SELECT p.Name AS ProductName, sum((OrderQty * UnitPrice) * (1.0 - UnitPriceDiscount)) as TotalRevenue
FROM Production.Product AS p
INNER JOIN Sales.SalesOrderDetailEnlarged_ROW AS sod
ON p.ProductID = sod.ProductID
group by p.Name
ORDER BY ProductName ASC;

-- READ
SELECT p.Name AS ProductName, sum((OrderQty * UnitPrice) * (1.0 - UnitPriceDiscount)) as TotalRevenue
FROM Production.Product AS p
INNER JOIN Sales.SalesOrderDetailEnlarged_PAGE AS sod
ON p.ProductID = sod.ProductID
group by p.Name
ORDER BY ProductName ASC;

