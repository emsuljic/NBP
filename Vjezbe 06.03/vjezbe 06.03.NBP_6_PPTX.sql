use AdventureWorks2014


select *
from Person.Address


select AddressLine1, City, PostalCode
from Person.Address


select AddressLine1, City, PostalCode
from Person.Address
wHERE City = 'Ottawa'

select PurchaseOrderID, OrderQty, UnitPrice
from Purchasing.PurchaseOrderDetail
WHERE OrderQty>10

select PurchaseOrderID, DueDate, OrderQty, UnitPrice
from Purchasing.PurchaseOrderDetail
where DueDate > '2011-06-01'
order by 2

select PurchaseOrderID, DueDate, OrderQty*UnitPrice AS Total
from Purchasing.PurchaseOrderDetail

select PurchaseOrderID, DueDate, LineTotal, OrderQty*UnitPrice AS Total
from Purchasing.PurchaseOrderDetail