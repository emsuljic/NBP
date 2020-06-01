/*
Koristeći tabele Employee, Order Details i Orders baze Northwind kreirati pogled view_Employee2 
koji će sadržavati ime uposlenika i sumu vrijednost svih narudžbi koje je taj uposlenik napravio
 u 1996. godini ako je ukupna vrijednost veća od 5000, pri čemu će se rezultati sortirati 
 uzlaznim redoslijedom prema polju ime.
*/
USE NORTHWND

go
create view view_emp_sum as  
select e.FirstName, SUM((od.UnitPrice - od.UnitPrice * od.Discount) * od.Quantity) as suma
from Employees e join Orders o on e.EmployeeID = o.EmployeeID 
	join [Order Details] od on o.OrderID = od.OrderID 
where year(o.OrderDate) = 1996
group by e.FirstName
having sum((od.UnitPrice - od.UnitPrice * od.Discount) * od.Quantity) > 5000
go

select * from view_emp_sum
where suma>20000
order by 2

/*
Koristeći tabele Orders i Order Details kreirati pogled koji će sadržavati
 polja: Orders.EmployeeID, [Order Details].ProductID i suma po UnitPrice.
*/

go
create view view_ord_det as
select o.EmployeeID, od.ProductID, sum(od.UnitPrice) as suma
from Orders o join [Order Details] od  
	on o.OrderID = od.OrderID
group bY o.EmployeeID, od.ProductID
go

select * from view_ord_det

/*
Koristeći prethodno kreirani pogled izvršiti ukupno sumiranje po uposlenicima.
 Sortirati po ID uposlenika.
*/

select EmployeeID, SUM(suma)
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
from Categories as c join Products p 
on c.CategoryID = p.CategoryID
join Suppliers as s
on s.SupplierID = p.SupplierID
go

/*
Koristeći prethodno kreirani pogled prebrojati broj proizvoda po kompanijama. Sortirati po nazivu kompanije.
*/
select CompanyName, count (ProductName) br_proizvoda
from view_cat_prod_supp
group by CompanyName
order by 2 asc

/*
Koristeći prethodno kreirani pogled prebrojati broj proizvoda po kategorijama. Sortirati po nazivu kategorije.
*/
select CategoryName, count (*) br_proizv
from view_cat_prod_supp
group by CategoryName
order by 2 asc


/*
Koristeći bazu Northwind kreirati pogled view_supp_ship koji će sadržavati polja: Suppliers.CompanyName, Suppliers.City i Shippers.CompanyName. 
*/
go
create view view_sup_shipp as
select s.CompanyName as dobavljac, s.City, sh.CompanyName as prevoznik
from Suppliers s join Products p 
on s.SupplierID = p.SupplierID
	join [Order Details] od on 
	p.ProductID = od.ProductID
	join Orders o on
	od.OrderID = o.OrderID
	join Shippers sh on
	sh.ShipperID = o.ShipVia
go

/*
Koristeći pogled view_supp_ship kreirati upit kojim će se prebrojati broj kompanija po prevoznicima.
*/

select dobavljac, count(*) br_proiz
from view_sup_shipp
group by dobavljac
order by 1

/*
Koristeći pogled view_supp_ship kreirati upit kojim će se prebrojati broj prevoznika po kompanijama. 
Uslov je da se prikažu one kompanije koje su imale ili ukupan broj prevoza manji od 30 ili veći od 150. 
Upit treba da sadrži naziv kompanije, prebrojani broj prevoza i napomenu "nizak promet" za kompanije ispod 30 prevoza,
odnosno, "visok promet" za kompanije preko 150 prevoza. Sortirati prema vrijednosti ukupnog broja prevoza.
*/

select dobavljac, count(prevoznik), 'nizak promet' status_prevoza
from view_sup_shipp
group by dobavljac
having COUNT(prevoznik) < 30 
union
select dobavljac, count(prevoznik), 'visok promet' status_prevoza
from view_sup_shipp
group by dobavljac
having COUNT(prevoznik) > 150
order by 2


/*
Koristeći tabele Products i Order Details kreirati pogled view_prod_price koji će sadržavati naziv proizvoda i sve različite cijene po kojima se prodavao. 
*/

go
create view view_prod_price as
select distinct p.ProductName, od.UnitPrice
from Products p join [Order Details] od 
on p.ProductID = od.ProductID
go

select * from view_prod_price

/*
Koristeći pogled view_prod_price dati pregled srednjih vrijednosti cijena proizvoda.
*/
select ProductName, avg(UnitPrice) sr_vr
from view_prod_price
group by ProductName

