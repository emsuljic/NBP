/*
a) U okviru baze AdventureWorks kopirati tabele Sale.Store, Sales.Customer, 
Sales.SalesTerritoryHistory i Sales.SalesPerson 
u tabele istih naziva a koje će biti u šemi vjezba. Nakon kopiranja u novim
 tabelama definirati iste PK i FK kojima su definirani odnosi među tabelama.
*/

create schema vjezba 
go

select * 
into vjezba.Store
from Sales.Store

select *
into vjezba.Customer
from Sales.Customer

select *
into vjezba.SalesTerritoryHistory
from Sales.SalesTerritoryHistory

select *
into vjezba.Person
from Sales.SalesPerson

alter table vjezba.Store
add constraint PK_store primary key (BusinessEntityID)

alter table vjezba.Customer
add constraint PK_Customer primary key (CustomerID)

alter table vjezba.SalesTerritoryHistory
add constraint PK_SalesTerritoryHistory primary key (BusinessEntityID, TerritoryID, StartDate)

alter table vjezba.Person
add constraint PK_SalesPerson primary key (BusinessEntityID)


/*
c) Dodati tabele u dijagram
*/


/*
b) Definirati sljedeća ograničenja (prva dva samo za tabele Customer i SalesPerson): 
	1. ModifiedDate kolone -					defaultna vrijednost je aktivni datum
	2. rowguid -								defaultna vrijednost slučajno generisani niz znakova
	3. SalesQuota u tabeli SalesPerson -		defaultna vrijednost 0.00
												zabrana unosa vrijednosti manje od 0.00
	4. EndDate u tabeli SalesTerritoryHistory - zabrana unosa starijeg datuma od StartDate
*/

alter table vjezba.Customer
add constraint DF_ModifedDate_c default(getdate()) for ModifiedDate

alter table vjezba.Customer
add constraint DF_rowguid_c default (newid()) for rowguid

alter table vjezba.Person
add constraint DF_ModifiedDate_s default (getdate()) for ModifiedDate

alter table vjezba.Person
add constraint DF_rowguid_s default (newid()) for rowguid

alter table vjezba.Person 
add constraint DF_SalesQuota_ default (0.00) for SalesQuota

alter table vjezba.Person
add constraint CK_SalesQuota check (SalesQuota>=0.00)

alter table vjezba.SalesTerritoryHistory
add constraint CK_SalesTerritoryHistory_EndDate check (EndDate >= StartDate)


--CHECK provjera nesto vezano za ovu kolonu salesquota



/*
U tabeli Customer:
a) dodati stalno pohranjenu kolonu godina koja će preuzimati godinu iz kolone ModifiedDate
*/

alter table vjezba.Customer
add godina as year(ModifiedDate)


/*ograniciti duzinu kolone rowguid na 10 znakova, a zatim postaviti defaultnu vrijednost
na 10 slucajno generisanih znakova*/

alter table vjezba.Customer
drop constraint DF_rowguid_c

alter table vjezba.Customer
alter column rowguid char (40)

update vjezba.Customer
set rowguid = LEFT(rowguid, 10)

alter table vjezba.Customer
add constraint CK_Lenrowguid check (len(rowguid)=10) 
--ogranieno na 10 znakova unosa

alter table vjezba.Customer
add constraint DF_rowguid default (left (newid(), 10)) for rowguid

/*
c) obrisati PK tabele, a zatim definirati kolonu istog naziva koja će 
biti PK identity sa početnom vrijednošću 1 i inkrementom 2
*/

alter table vjezba.Customer
drop constraint PK_Customer

alter table vjezba.Customer
drop column CustomerID

alter table vjezba.Customer
add CustomerID int identity (1,2)

alter table vjezba.Customer
add CustomerID int constraint PK_Customer primary key identity (1,2)

select CustomerID, PersonID, StoreID, TerritoryID, AccountNumber, rowguid, ModifiedDate, godina
from vjezba.Customer

DBCC CHECKIDENT ('vjezba.Customer', RESEED, 1) 

/*
d) izvrsiti insert podataka iz tabele Sales.Customer sa ocuvanjem identity karaktera kolone CustomerID u vjezba.Customer
*/

insert into vjezba.Customer
select PersonID, StoreID, TerritoryID, AccountNumber, LEFT(rowguid, 10)
from Sales.Customer

/*
e) kreirati upit za prikaz zapisa u kojima je StoreID veći od 500, 
a zatim pokrenuti upit sa uključenim vremenom i planom izvršavanja
*/

set statistics time on
select *
from vjezba.Customer
where StoreID > 500
order by StoreID
set statistics time off


/*
f) nad kolonom StoreID kreirati nonclustered indeks, a zatim pokrenuti 
upit sa uključenim vremenom i planom izvršavanja
*/
create nonclustered index IX_store_id
on vjezba.Customer (StoreID)

set statistics time on
select *
from vjezba.Customer
where StoreID > 500
order by StoreID
set statistics time off

drop index IX_store_id 
on vjezba.Customer

/*
g) kreirati upit za prikaz zapisa u kojima je TerritoryID veći od 1, a zatim pokrenuti upit sa uključenim vremenom i planom izvršavanja
*/

set statistics time on 
select *
from vjezba.Customer
where TerritoryID>1
order by TerritoryID
set statistics time off


/*
h) nad kolonom TerritoryID kreirati nonclustered indeks, a zatim pokrenuti upit sa uključenim vremenom i planom izvršavanja
*/
create nonclustered index IX_TerritoryID
on vjezba.Customer (TerritoryID)

set statistics time on 
select *
from vjezba.Customer
where TerritoryID>1
order by TerritoryID
set statistics time off

drop index IX_TerritoryID 
on vjezba.Customer

/*
northwind
Koristeći tabele Order Details i Products kreirati upit kojim će se dati prikaz naziva proizvoda, 
jedinične cijene i količine uz uslov da se prikažu samo oni proizvodi koji počinju slovima A ili C. 
Uključiti prikaz vremena i plana izvršavanja.
*/
use NORTHWND

set statistics time on
select Products.ProductName, [Order Details].UnitPrice, [Order Details].Quantity
from [Order Details] JOIN Products ON  [Order Details].ProductID = Products.ProductID
where Products.ProductName like '[AC]%'
set statistics time off


/*
northwind
Koristeći tabele Order i Customers kreirati upit kojim će se dati prikaz naziva kompanije, 
poštanskog broja, datuma narudžbe i datuma isporuke uz uslov da se prikažu samo oni proizvodi
 za koje je razlika OrderDate i ShippedDate pozitivna. Uključiti prikaz vremena i plana izvršavanja.
*/

set statistics time on
select Customers.CompanyName, Customers.PostalCode, Orders.OrderDate, Orders.ShippedDate
from Orders JOIN Customers ON Orders.CustomerID = Customers.CustomerID
where DAY(OrderDate) - Day(ShippedDate) > 0
set statistics time off

