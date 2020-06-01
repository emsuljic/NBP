use AdventureWorks2014

select PurchaseOrderID, DueDate, OrderQty, UnitPrice
from Purchasing.PurchaseOrderDetail
where DueDate > '2011-06-01'
order by 2