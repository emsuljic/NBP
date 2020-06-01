/*
Koristeći tabele Employee, Order Details i Orders baze Northwind kreirati pogled view_Employee2 
koji će sadržavati ime uposlenika i sumu vrijednost svih narudžbi koje je taj uposlenik napravio
 u 1996. godini ako je ukupna vrijednost veća od 5000, pri čemu će se rezultati sortirati 
 uzlaznim redoslijedom prema polju ime.
*/

use NORTHWND

go
create view view_Employee2 as
select Employees.FirstName, SUM (([Order Details].UnitPrice - [Order Details].UnitPrice*[Order Details].Discount)*[Order Details].Quantity) as suma
from Employees JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID 
		JOIN [Order Details] ON [Order Details].OrderID = Orders.OrderID
where YEAR(Orders.OrderDate) = 1996
group by  Employees.FirstName
having SUM (([Order Details].UnitPrice - [Order Details].UnitPrice*[Order Details].Discount)*[Order Details].Quantity) > 5000

/*
Koristeći tabele Orders i Order Details kreirati pogled koji će sadržavati
 polja: Orders.EmployeeID, [Order Details].ProductID i suma po UnitPrice.
*/

create view view_ord_det as
select o.EmployeeID, od.ProductID, SUM (od.UnitPrice) Suma
from Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID
group by o.EmployeeID, od.ProductID

select * from view_ord_det

/*
Koristeći prethodno kreirani pogled izvršiti ukupno sumiranje po uposlenicima.
 Sortirati po ID uposlenika.
*/

select EmployeeID, SUM (Suma)
from view_ord_det
group by EmployeeID
order by 1

/*
Koristeći tabele Categories, Products i Suppliers kreirati pogled 
koji će sadržavati polja: CategoryName, ProductName i CompanyName. 
*/

go
create view view_cat_prod_supp as
select c.CategoryName, p.ProductName, s.CompanyName
from Categories c JOIN Products p ON c.CategoryID = p.CategoryID 
		JOIN Suppliers s ON s.SupplierID = p.SupplierID
go


/*
Koristeći prethodno kreirani pogled prebrojati broj proizvoda po kompanijama. Sortirati po nazivu kompanije.
*/

select CompanyName, count(ProductName) br_proizvoda
from view_cat_prod_supp
group by CompanyName
order by 1


/*
Koristeći prethodno kreirani pogled prebrojati broj proizvoda po kategorijama. Sortirati po nazivu kategorije.
*/

select CategoryName, COUNT(*) br_proizvoda
from view_cat_prod_supp
group by CategoryName
order by 1

/*
Koristeći bazu Northwind kreirati pogled view_supp_ship koji će sadržavati polja: Suppliers.CompanyName, Suppliers.City i Shippers.CompanyName. 
*/

go
create view view_supp_ship as 
select s.CompanyName dobavljac, s.City, sh.CompanyName as prevoznik
from Suppliers s JOIN Products p ON s.SupplierID = p.SupplierID 
		JOIN [Order Details] od ON od.ProductID = p.ProductID 
			JOIN Orders o ON o.OrderID = od.OrderID
				JOIN Shippers sh ON sh.ShipperID = o.ShipVia

/*
Koristeći pogled view_supp_ship kreirati upit kojim će se prebrojati 
broj kompanija po prevoznicima.
*/

select dobavljac, count(*) br_kompanija
from view_supp_ship
group by dobavljac


/*
Koristeći pogled view_supp_ship kreirati upit kojim će se prebrojati broj prevoznika po kompanijama. 
Uslov je da se prikažu one kompanije koje su imale ili ukupan broj prevoza manji od 30 ili veći od 150. 
Upit treba da sadrži naziv kompanije, prebrojani broj prevoza i napomenu "nizak promet" za kompanije ispod 30 prevoza,
odnosno, "visok promet" za kompanije preko 150 prevoza. Sortirati prema vrijednosti ukupnog broja prevoza.
*/

select dobavljac, count (prevoznik), 'nizak promet'
from view_supp_ship 
group by dobavljac
having count(prevoznik) < 30
UNION
select dobavljac, count (prevoznik), 'visok promet'
from view_supp_ship 
group by dobavljac
having count(prevoznik) > 150


/*
Koristeći tabele Products i Order Details kreirati pogled view_prod_price koji će 
sadržavati naziv proizvoda i sve različite cijene po kojima se prodavao. 
*/

go
create view view_prod_price as
select ProductName, od.UnitPrice
from Products p JOIN [Order Details] od 
		ON p.ProductID = od.ProductID

select * from view_prod_price

/*
Koristeći pogled view_prod_price dati pregled srednjih vrijednosti cijena proizvoda.
*/

select ProductName, AVG(UnitPrice) as srednja_vr
from view_prod_price
group by ProductName