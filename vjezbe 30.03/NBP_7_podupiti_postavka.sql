/*
SELECT column-names
  FROM table-name1
 WHERE value IN (SELECT column-name
                   FROM table-name2 
                  WHERE condition
	ZA VISE VRIJEDNOSTI <, >

SELECT column-names
  FROM table-name1
 WHERE value = (SELECT column-name
                   FROM table-name2 
                  WHERE condition
	VRACA JEDNU VRIJEDNOST 

SELECT column1 = (SELECT column-name FROM table-name WHERE condition),
       column-names
  FROM table-name
 WEHRE condition


 SELECT FirstName, LastName, 
       OrderCount = (SELECT COUNT(O.Id) FROM [Order] O WHERE O.CustomerId = C.Id)
  FROM Customer C 
  --provjerava jesu li iste vrijednosti
  */



--northwind

use NORTHWND
go


/*
Koristeći tabelu Order Details kreirati upit kojim će se odrediti razlika između:
a) minimalne i maksimalne vrijednosti UnitPrice.
b) maksimalne i srednje vrijednosti UnitPrice
*/




/*
Koristeći tabelu Order Details kreirati upit kojim će se odrediti srednje vrijednosti UnitPrice po narudžbama.
*/

/*
Koristeći tabelu Order Details kreirati upit kojim će se prebrojati broj narudžbi po OrderID kojima je UnitPrice:
a) za 20 KM veća od minimalne vrijednosti UniPrice
b) za 10 KM manja od maksimalne vrijednosti UniPrice
*/

select OrderID, UnitPrice, MIN (UnitPrice)
from [Order Details]
where UnitPrice > (select min(UnitPrice) + 20 from [Order Details])
group by OrderID, UnitPrice

select OrderID, count (*)
FROM [Order Details]
where UnitPrice < (select MAX (UnitPrice) - 10 from [Order Details])
group by OrderID



/*
Koristeći tabelu Order Details kreirati upit kojim će se dati pregled zapisa kojima se UnitPrice nalazi u rasponu od +10 KM u 
odnosu na minimum i -10 u odnosu na maksimum. Upit traba da sadrži OrderID, UnitPrice.
*/
SELECT
	OrderID,
	UnitPrice
FROM [Order Details]
WHERE UnitPrice BETWEEN		
		(SELECT MIN(UnitPrice)+10 FROM dbo.[Order Details]) 
					AND (SELECT MAX(UnitPrice)-10 FROM dbo.[Order Details])



/*
Koristeći tabelu Orders kreirati upit kojim će se prebrojati broj naručitelja kojima se Freight nalazi u rasponu od 10 KM u odnosu na srednju vrijednost Freighta. Upit traba da sadrži CustomerID i ukupan broj po CustomerID.
*/

select CustomerID, count(*) as prebrojano
from Orders
where Freight between 
	(select avg(Freight) - 10 from Orders) 
			and (select avg(Freight) from Orders) + 10
group by CustomerID
order by 2 desc


/*
Koristeći tabele Orders i Order Details kreirati upit kojim će se dati pregled ukupnih količina ostvarenih po OrderID.
*/
select O.OrderID, sum_kol = 
	(select sum(Quantity) from [Order Details] as OD 
			where O.OrderID = OD.OrderID)
from Orders as O


/*
Koristeći tabele Orders i Employees kreirati upit kojim će se dati pregled ukupno realiziranih narudžbi po uposleniku.
Upit treba da sadrži prezime i ime uposlenika, te ukupan broj narudžbi.
*/

 SELECT E.LastName, E.FirstName,
       br_narudzbi = (SELECT COUNT(*) FROM [Orders] WHERE Orders.EmployeeID = E.EmployeeID )
  FROM Employees as E
  order by 3

/*
Koristeći tabele Orders i Order Details kreirati upit kojim će se dati pregled narudžbi kupca u kojima je naručena količina veća od 10.
Upit treba da sadrži CustomerID i Količinu, te ukupan broj narudžbi.
*/



/*
Koristeći tabelu Products kreirati upit kojim će se dati pregled proizvoda kojima je stanje na stoku veće od srednje vrijednosti stanja na stoku. Upit treba da sadrži ProductName i UnitsInStock.
*/

/*
Koristeći tabelu Products kreirati upit kojim će se prebrojati broj proizvoda po dobavljaču kojima je stanje na stoku veće od srednje vrijednosti stanja na stoku. Upit treba da sadrži SupplierID i ukupan broj proizvoda.
*/

/*
Iz tabele Order Details baze Northwind dati prikaz ID narudžbe, ID proizvoda i jedinične cijene, te razliku cijene proizvoda
u odnosu na srednju vrijednost cijene za sve proizvode u tabeli. Rezultat sortirati prema vrijednosti razlike
u rastućem redoslijedu.*/

/*
Iz tabele Products baze Northwind za sve proizvoda kojih ima na stanju dati prikaz ID proizvoda, 
naziv proizvoda i stanje zaliha, te razliku stanja zaliha proizvoda u odnosu na srednju vrijednost 
stanja za sve proizvode u tabeli. Rezultat sortirati prema vrijednosti razlike u 
opadajućem redoslijedu.*/

/*
Upotrebom tabela Orders i Order Details baze Northwind prikazati ID narudžbe i kupca koji je kupio
više od 10 komada proizvoda čiji je ID 15.*/

/*
Upotrebom tabela sales i stores baze pubs prikazati ID i naziv prodavnice u kojoj je naručeno
više od 1 komada publikacije čiji je ID 6871.*/

