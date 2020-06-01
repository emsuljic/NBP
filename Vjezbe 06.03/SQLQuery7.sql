use AdventureWorks2014

select PurchaseOrderID, DueDate, LineTotal, OrderQty*UnitPrice AS Total
from Purchasing.PurchaseOrderDetail