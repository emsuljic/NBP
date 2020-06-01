use AdventureWorks2014

select PurchaseOrderID, DueDate, OrderQty*UnitPrice AS Total
from Purchasing.PurchaseOrderDetail
