﻿--PODUPITI
/*
Iz tabele Order Details baze Northwind dati prikaz ID narudžbe, ID proizvoda, jedinične cijene i srednje vrijednosti, 
te razliku cijene proizvoda u odnosu na srednju vrijednost cijene za sve proizvode u tabeli. Rezultat sortirati prema v
rijednosti razlike u rastućem redoslijedu.*/

use NORTHWND
go

select OrderID, ProductID, UnitPrice,
	(select AVG(UnitPrice) from [Order Details]) as srednja, 
	round (UnitPrice - (select avg(UnitPrice) from [Order Details] ),2) as razlika
from [Order Details] 
order by 4


/*
Iz tabele Products baze Northwind za sve proizvoda kojih ima na stanju dati prikaz ID proizvoda, naziv proizvoda, 
stanje zaliha i srednju vrijednost, te razliku stanja zaliha proizvoda u odnosu na srednju vrijednost stanja za sve 
proizvode u tabeli. Rezultat sortirati prema vrijednosti razlike u opadajućem redoslijedu.*/

/*
Upotrebom tabela Orders i Order Details baze Northwind prikazati ID narudžbe i kupca koji je kupio više od 10 komada proizvoda čiji je ID 15.*/

select OrderID, CustomerID
from Orders
where ( select Quantity from [Order Details]
		 where Orders.OrderID = [Order Details].OrderID and [Order Details].ProductID=15 ) > 10


/*
Upotrebom tabela sales i stores baze pubs prikazati ID i naziv prodavnice u kojoj je naručeno više od 1 komada publikacije čiji je ID 6871.
*/



--JOIN
/*
INNER JOIN
Rezultat upita su samo oni zapisi u kojima se podudaraju vrijednosti spojnog polja iz obje tabele.

LEFT OUTER JOIN
Lijevi spoj je inner join kojim su pridodati i oni zapisi koji postoje u "lijevoj" tabeli, ali ne i u "desnoj".
Kod lijevog spoja, na mjestu "povezne" kolone iz desne tabele bit će vraćena vrijednost NULL

RIGHT OUTER JOIN
Desni spoj je inner join kojim su pridodati i oni zapisi koji postoje u "desnoj" tabeli, ali ne i u "lijevoj".
Kod desnog spoja, na mjestu "povezne" kolone iz lijeve tabele bit će vraćena vrijednost NULL

FULL OUTER JOIN
Kod punog spoja obje tabele imaju ulogu „glavne“. 
U rezultatu će se naći svi zapisi iz obje tabele koji zadovoljavaju uslov, pri čemu će se u zapisima koji nisu upareni, na mjestu "poveznih" kolona iz obje tabele vratiti NULL vrijednost.
*/

/*
Iz tabela discount i stores baze pubs prikazati naziv popusta, ID i naziv prodavnice
*/
use pubs
go

select discounts.discounttype, stores.stor_id, stores.stor_name
from discounts inner join stores 
	ON  discounts.stor_id = stores.stor_id

/*
Iz tabela employee i jobs baze pubs prikazati ID i ime uposlenika, ID posla i naziv posla koji obavlja*/

select employee.emp_id, employee.fname, jobs.job_id, jobs.job_desc
from employee inner join jobs 
on employee.job_id = jobs.job_id
order by 3

/*
U svim upitima treba vratiti sljedeće kolone: OsobaID iz obje tabele, RedovniPrihodiID, Neto, VanredniPrihodiID, IznosVanrednogPrihoda
U bazi Prihodi upotrebom:
a) left outer joina iz tabela Redovni i Vanredni prihodi prikazati id osobe iz obje tabele, neto i iznos vanrednog prihoda, pri čemu će se isključiti zapisi u kojima je ID osobe iz tabele redovni prihodi NULL vrijednost, a rezultat sortirati u rastućem redoslijedu prema ID osobe iz tabele redovni prihodi
b) right outer joina iz  tabela Redovni i Vanredni prihodi prikazati id osobe iz obje tabele, neto i iznos vanrednog prihoda, pri čemu će se isključiti zapisi u kojima je ID osobe iz tabele redovni prihodi NULL vrijednost, a rezultat sortirati u rastućem redoslijedu prema ID osobe iz tabele vanredni prihodi
c) full outer joina prikazati i redovne i vanredne prihode osobe, a rezultat sortirati u rastućem redoslijedu prema ID osobe iz tabela redovni i vanredni prihodi
*/
alter authorization on database :: prihodi to sa
use prihodi

--a)
select RedovniPrihodi.OsobaID, RedovniPrihodi.RedovniPrihodiID, 
		RedovniPrihodi.Neto, 
		VanredniPrihodi.OsobaID, VanredniPrihodi.VanredniPrihodiID,
			 VanredniPrihodi.IznosVanrednogPrihoda
from RedovniPrihodi left join Osoba 
	ON RedovniPrihodi.OsobaID = Osoba.OsobaID
		LEFT OUTER JOIN VanredniPrihodi 
			ON Osoba.OsobaID = VanredniPrihodi.OsobaID 
where RedovniPrihodi.OsobaID is not null
order by 1


--b)
select RedovniPrihodi.OsobaID, RedovniPrihodi.RedovniPrihodiID, 
	RedovniPrihodi.Neto, 
		VanredniPrihodi.OsobaID, VanredniPrihodi.VanredniPrihodiID, 
		VanredniPrihodi.IznosVanrednogPrihoda
from RedovniPrihodi right join Osoba 
	ON RedovniPrihodi.OsobaID = Osoba.OsobaID
		RIGHT OUTER JOIN VanredniPrihodi 
			ON Osoba.OsobaID = VanredniPrihodi.OsobaID 
where VanredniPrihodi.OsobaID is not null
order by 4

--c)
select RedovniPrihodi.OsobaID, RedovniPrihodi.RedovniPrihodiID, RedovniPrihodi.Neto, 
		VanredniPrihodi.OsobaID, VanredniPrihodi.VanredniPrihodiID, VanredniPrihodi.IznosVanrednogPrihoda
from RedovniPrihodi full join Osoba 
	ON RedovniPrihodi.OsobaID = Osoba.OsobaID
		FULL OUTER JOIN VanredniPrihodi 
			ON Osoba.OsobaID = VanredniPrihodi.OsobaID 
order by 1



/*
Iz tabela Employees, EmployeeTerritories, Territories i Region baze Northwind prikazati prezime i ime uposlenika kao polje ime i prezime, teritoriju i regiju koju pokrivaju i stariji su od 30 godina.*/
use NORTHWND
select Employees.LastName + ' ' + Employees.FirstName,
	Territories.TerritoryDescription, Region.RegionDescription  
from Employees join EmployeeTerritories
	on Employees.EmployeeID = EmployeeTerritories.EmployeeID
		inner join Territories
			on EmployeeTerritories.TerritoryID = Territories.TerritoryID
				inner join Region
					on Territories.RegionID = Region.RegionID
--where year(getdate()) - year (Employees.BirthDate) > 30
where DATEDIFF( year, Employees.BirthDate, getdate()) > 30 

/*
Iz tabela Employee, Order Details i Orders baze Northwind prikazati ime i prezime uposlenika kao polje ime i prezime, jediničnu cijenu,
 količinu i ukupnu vrijednost pojedinačne narudžbe kao polje ukupno za sve narudžbe u 1997. godini, pri čemu će se rezultati sortirati
  prema novokreiranom polju ukupno.*/
select Employees.FirstName + ' ' + Employees.LastName,
[Order Details].UnitPrice, [Order Details].Quantity,
([Order Details].Quantity * ([Order Details].UnitPrice - [Order Details].UnitPrice * [Order Details].Discount)) as ukupno
from Employees join Orders
	on Employees.EmployeeID = Orders.EmployeeID
	INNER JOIN [Order Details] 
		ON Orders.OrderID = [Order Details].OrderID
		where year(Orders.OrderDate)=1997
order by 4

use NORTHWND
/*
Iz tabela Employee, Order Details i Orders baze Northwind prikazati ime uposlenika i ukupnu vrijednost svih narudžbi koje
 je taj uposlenik napravio u 1996. godini ako je ukupna vrijednost veća od 50000, pri čemu će se rezultati sortirati uzlaznim redoslijedom prema polju ime. 
 Vrijednost sume zaokružiti na dvije decimale.*/
select Employees.FirstName,
	SUM ([Order Details].Quantity * [Order Details].UnitPrice ) as ukupno
from Employees join Orders
	on Employees.EmployeeID = Orders.EmployeeID
	INNER JOIN [Order Details] 
		ON Orders.OrderID = [Order Details].OrderID
where year(Orders.OrderDate)=1996 
group by Employees.FirstName
having SUM ([Order Details].Quantity * [Order Details].UnitPrice ) > 50000
order by 1

/*
Iz tabela Categories, Products i Suppliers baze Northwind prikazati naziv isporučitelja (dobavljača),
 mjesto i državu isporučitelja (dobavljača) i naziv(e) proizvoda iz kategorije napitaka (pića) kojih na 
 stanju ima više od 30 jedinica. Rezultat upita sortirati po državi.*/

select CompanyName, City, Country
from Suppliers join Products ON Suppliers.SupplierID = Products.SupplierID 
		inner join Categories ON Products.CategoryID = Categories.CategoryID
			where Categories.CategoryID =1 and Products.UnitsInStock>30
order by 3

/*
U tabeli Customers baze Northwind ID kupca je primarni ključ. U tabeli Orders baze Northwind ID kupca je vanjski ključ.
Dati izvještaj:
a) koliko je ukupno kupaca evidentirano u obje tabele (lista bez ponavljanja iz obje tabele)
a.1) koliko je ukupno kupaca evidentirano u obje tabele
b) da li su svi kupci obavili narudžbu
c) koji kupci nisu napravili narudžbu*/

--kod koristenja ovih fja (union, except, intersect) broj polja kolona u prvom i drugom upitu mora biti isti 

--a
select CustomerID
from Customers
	union
select CustomerID
from Orders

--a1
select CustomerID
from Customers
	union all
select CustomerID
from Orders

--b
select CustomerID
from Customers
	intersect
select CustomerID
from Orders

--c
select CustomerID
from Customers
	except
select CustomerID
from Orders

/*
a) Provjeriti u koliko zapisa (slogova) tabele Orders nije unijeta vrijednost u polje regija kupovine.

b) Upotrebom tabela Customers i Orders baze Northwind prikazati ID kupca pri čemu u polje regija kupovine 
nije unijeta vrijednost, uz uslov da je kupac obavio narudžbu (kupac iz tabele Customers postoji u tabeli Orders). 
Rezultat sortirati u rastućem redoslijedu.

c) Upotrebom tabela Customers i Orders baze Northwind prikazati ID kupca pri čemu u polje regija kupovine nije 
unijeta vrijednost i kupac nije obavio ni jednu narudžbu (kupac iz tabele Customers ne postoji u tabeli Orders).
Rezultat sortirati u rastućem redoslijedu.*/

--a 
select count(*)
from Orders
where ShipRegion is null

--b
select CustomerID
from Customers
intersect
select CustomerID
from Orders
where ShipRegion is null
order by 1
--57

--c
select CustomerID
from Customers
except
select CustomerID
from Orders
where ShipRegion is null
order by 1
--34

/*
Iz tabele HumanResources.Employee baze AdventureWorks2014 prikazati po 5 najstarijih zaposlenika muškog, odnosno, ženskog pola 
uz navođenje sljedećih podataka: radno mjesto na kojem se nalazi, datum rođenja, korisnicko ime i godine starosti. Korisničko ime 
je dio podatka u LoginID. Rezultate sortirati prema polu uzlaznim, a zatim prema godinama starosti silaznim redoslijedom.*/

use AdventureWorks2014

select top 5 JobTitle, BirthDate, Gender,
	substring(LoginID, CHARINDEX('\', LoginID) + 1, 10) as kor_ime
from HumanResources.Employee
where Gender='M'
UNION
select top 5 JobTitle, BirthDate, Gender,
	substring(LoginID, CHARINDEX('\', LoginID) + 1, 10) as kor_ime
from HumanResources.Employee
where Gender='F'
order by 3 asc, 2 desc

--CHARINDEX koristi se da bi nasli, odvojili neke dijelove

select top 5 JobTitle, BirthDate, Gender,
	RIGHT	(LoginID, len( LoginID) - 16) as kor_ime
from HumanResources.Employee
where Gender='F'

/*
Iz tabele HumanResources.Employee baze AdventureWorks2014 prikazati po 2 zaposlenika sa najdužim stažom bez obzira da li su u braku
 ili ne i obavljaju poslove inžinjera uz navođenje sljedećih podataka: radno mjesto na kojem se nalazi, datum zaposlenja i bračni status. 
 Ako osoba nije u braku plaća dodatni porez, inače ne plaća. Rezultate sortirati prema bračnom statusu uzlaznim, a zatim prema stažu silaznim redoslijedom.*/

select top 2 JobTitle, HireDate, MaritalStatus, 'plaća' as dod_porez 
from HumanResources.Employee
where MaritalStatus='S' and JobTitle like '%engineer%'
	and JobTitle not like '%engineering%'
UNION
select top 2 JobTitle, HireDate, MaritalStatus, 'ne plaća' as dod_porez 
from HumanResources.Employee
where MaritalStatus='M' and JobTitle like '%engineer%'
	and JobTitle not like '%engineering%'
order by 3 asc, 2 desc


/*
Iz tabela HumanResources.Employee i Person.Person prikazati po 5 osoba koje se nalaze na 1, odnosno, 4.  organizacionom nivou, 
uposlenici su i žele primati email ponude od AdventureWorksa uz navođenje sljedećih polja: ime i prezime osobe kao jedinstveno polje,
 organizacijski nivo na kojem se nalazi i da li prima email promocije. Pored ovih uvesti i polje koje će sadržavati poruke: Ne prima, 
 Prima selektirane i Prima. Sadržaj novog polja ovisi o vrijednosti polja EmailPromotion. Rezultat sortirati prema organizacijskom nivou
  i dodatno uvedenom polju.*/

select top 5 Person.Person.FirstName + ' ' + Person.Person.LastName, HumanResources.Employee.OrganizationLevel, 'Ne prima' as Status_email
from HumanResources.Employee INNER JOIN Person.Person 
	ON HumanResources.Employee.BusinessEntityID = Person.Person.BusinessEntityID
where HumanResources.Employee.OrganizationLevel IN (1, 4) and 
		Person.Person.EmailPromotion = 0
UNION
select top 5 Person.Person.FirstName + ' ' + Person.Person.LastName, HumanResources.Employee.OrganizationLevel, 'Prima selektirane' as Status_email
from HumanResources.Employee INNER JOIN Person.Person 
	ON HumanResources.Employee.BusinessEntityID = Person.Person.BusinessEntityID
where HumanResources.Employee.OrganizationLevel IN (1, 4) and 
		Person.Person.EmailPromotion = 1
UNION
select top 5 Person.Person.FirstName + ' ' + Person.Person.LastName, HumanResources.Employee.OrganizationLevel, 'Prima' as Status_email
from HumanResources.Employee INNER JOIN Person.Person 
	ON HumanResources.Employee.BusinessEntityID = Person.Person.BusinessEntityID
where HumanResources.Employee.OrganizationLevel IN (1, 4) and 
		Person.Person.EmailPromotion = 2
order by 3, 2

/*
Iz tabela Sales.SalesOrderDetail i Production.Product prikazati 10 najskupljih stavki prodaje uz navođenje polja: naziv proizvoda, 
količina, cijena i iznos. Cijenu i iznos zaokružiti na dvije decimale. Iz naziva proizvoda odstraniti posljednji dio koji sadržava 
cifre i zarez. U rezultatu u polju količina na broj dodati 'kom.', a u polju cijena i iznos na broj dodati 'KM'.*/

