use AdventureWorks2014

select PurchaseOrderID, OrderQty, UnitPrice
from Purchasing.PurchaseOrderDetail
WHERE OrderQty>10