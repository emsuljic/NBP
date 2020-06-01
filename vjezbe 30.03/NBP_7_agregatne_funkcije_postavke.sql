/*
Iz tabele Order Details u bazi Northwind prikazati narudžbe sa najmanjom i najvećom naručenom količinom, prebrojani broj narudžbi, ukupna suma naručenih proizvoda, 
te srednju vrijednost naručenih proizvoda.
*/

use NORTHWND
go

select MIN(Quantity) as minim, max(Quantity) as maxim, count(Quantity) as prebroj, sum(Quantity) as suma, avg(Quantity) as srednja
from [Order Details]

select OrderID, sum(UnitPrice)
from [Order Details]
group by OrderID

select * from [Order Details]

select OrderID, sum(Freight)
from Orders
group by OrderID

--ovdje nema potrebe raditi group by jer je u ovoj tabeli PK ID 

select sum(Freight)
from Orders
--ako se trazi samo suma, a ne suma po necemu, trazi se samo jedan rekord rezultat sume

/*
Iz tabele Order Details u bazi Northwind prikazati narudžbe sa najmanjom i najvećom ukupnom novčanom vrijednošću.*/
*/
--novcana vr. se mora izracunat qty unit_price discount

select MIN(Quantity * (UnitPrice - UnitPrice*Discount)), MAX(Quantity * (UnitPrice - UnitPrice*Discount))
from [Order Details]

/*
Iz tabele Order Details u bazi Northwind prikazati broj narudžbi (prebrojati) sa odobrenim popustom.
*/
select COUNT(*)
--da se skrati pisanje, ovako je sa *
--ili napisati count(Quantity)
from [Order Details]
where Discount>0



/*
Iz tabele Orders u bazi Northwind prikazati ukupan trošak prevoza ako je veći od 1000 za robu koja se kupila u Francuskoj, Njemačkoj ili Švicarskoj. 
Rezultate prikazati po državama.
*/

select ShipCountry, SUM(Freight) as trosak_prevoza
from Orders
where ShipCountry in ('France', 'Germany', 'Switzerland')
group by ShipCountry
having sum(Freight)>1000
--uslov nad kolonama where ide prije gruop by 


/*
Iz tabele Orders u bazi Northwind prikazati sve kupce po ID-u kod kojih ukupni troškovi prevoza nisu prešli 7500 
pri čemu se rezultat treba sortirati opadajućim redoslijedom po visini troškova prevoza.
*/

select CustomerID, sum(Freight)
from Orders 
group by CustomerID
having sum(Freight) <=7500
order by 2 desc
--having nakon group by

