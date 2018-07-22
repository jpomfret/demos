param (
    $tableAppend = ''
)

Import-Module dbatools

$server = 'localhost\sql2016'
$sourceDatabase = 'AdventureWorks2016'
$insertDatabase = 'SalesOrderLarge'

#$tableAppend = '_ROW'

$insertHeaderQuery = ("
INSERT INTO Sales.SalesOrderHeaderEnlarged{0} (RevisionNumber, OrderDate, DueDate, ShipDate, Status, OnlineOrderFlag, PurchaseOrderNumber, AccountNumber, CustomerID, SalesPersonID, TerritoryID, BillToAddressID, ShipToAddressID, ShipMethodID, CreditCardID, CreditCardApprovalCode, CurrencyRateID, SubTotal, TaxAmt, Freight, Comment, rowguid, ModifiedDate)
OUTPUT inserted.Comment AS OrigSalesOrderId, inserted.SalesOrderID as NewSalesOrderId
SELECT RevisionNumber, OrderDate, DueDate, ShipDate, Status, OnlineOrderFlag, PurchaseOrderNumber, AccountNumber, CustomerID, SalesPersonID, TerritoryID, BillToAddressID, ShipToAddressID, ShipMethodID, CreditCardID, CreditCardApprovalCode, CurrencyRateID, SubTotal, TaxAmt, Freight, '{0}', newid(), getdate()
FROM AdventureWorks2016.Sales.SalesOrderHeader
WHERE SalesOrderID = '{1}'" -f $tableAppend, $order)

$insertDetailQuery = ("
INSERT INTO Sales.SalesOrderDetailEnlarged{0} (SalesOrderId, CarrierTrackingNumber, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount, rowguid, ModifiedDate)
SELECT '{1}', CarrierTrackingNumber, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount, newid(), getdate()
FROM AdventureWorks2016.Sales.SalesOrderDetail sod
WHERE SalesOrderID = '{2}'" -f $tableAppend, $header.NewSalesOrderId, $header.OrigSalesOrderId)


## GET 100 ORDER NUMBER IDS
$orders = Invoke-SqlCmd2 -ServerInstance $server `
            -Database $sourceDatabase `
            -Query 'Select top 100 SalesOrderId From Sales.SalesOrderHeader' |
select-Object -Expand SalesOrderId

$headerTime = @()
$detailTime = @()
## LOOP THROUGH
foreach($order in $orders) {
    Write-Verbose ("Processing Order Id: {0}" -f $order)

    $start = get-date
    ## INSERT INTO HEADER
    $header = Invoke-Sqlcmd2 -ServerInstance $server -Database $insertDatabase -Query $insertHeaderQuery
    $timeDiff = [int]$($(get-date) - $start).TotalMilliseconds
    Write-Verbose ("--Insert into header took: {0}" -f $timeDiff)
    $headerTime += $timeDiff

    ## INSERT INTO DETAIL
    $null = Invoke-Sqlcmd2 -ServerInstance $server -Database $insertDatabase -Query $insertDetailQuery
    $timeDiff = [int]$($(get-date) - $start).TotalMilliseconds
    Write-Verbose ("--Insert into header took: {0}" -f $timeDiff)
    $detailTime += $timeDiff

}

$test = switch($tableAppend) {
    '' {'Regular'}
    '_ROW' { 'Row' }
    '_PAGE' { 'Page' }
}

$headerTime | Measure-Object -Average | Select-Object @{l='Test';e={$test}}, @{l='Insert';e={'Header'}}, average
$detailTime | Measure-Object -Average | Select-Object @{l='Test';e={$test}}, @{l='Insert';e={'Detail'}}, average

