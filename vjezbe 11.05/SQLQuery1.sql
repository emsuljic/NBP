create database radna1
use radna1

﻿/*
Kreirati tabele UposlenikZDK i UposlenikHNK koje će formirati pogled 
view_part_UposlenikKantoni. Obje tabele će sadržavati polja UposlenikID,
 NacionalniID, LoginID, RadnoMjesto i Kanton. Sva polja su obavezan unos.
  Tabela UposlenikZDK će se označiti brojem 1, a tabela UposlenikHNK brojem 2.
*/
/*Primarni ključ je kompozitni i sastoji se od kolona UposlenikID i Kanton.*/

create table UposlenikZDK1
(
	UposlenikID int not null,
	Kanton int not null constraint CK_ZDK check  (Kanton = 1),
	NacionalniID nvarchar (20) not null,
	LoginID nvarchar (20) not null, 
	RadnoMjesto nvarchar (20) not null,
	constraint PK_ZDK1 primary key (UposlenikID, Kanton)
)

create table UposlenikHNK1
(
	UposlenikID int not null,
	Kanton int not null constraint CK_HNK check  (Kanton = 2),
	NacionalniID nvarchar (20) not null,
	LoginID nvarchar (20) not null, 
	RadnoMjesto nvarchar (20) not null,
	constraint PK_HNK1 primary key (UposlenikID, Kanton)
)

/*
Kreirati dijeljeni pogled (partitioned view) view_part_UposlenikKantoni
 koji će podatke koji se unose u njega distribuirati u tabele UposlenikZDK 
 i UposlenikHNK. 
Nakon kreiranja u pogled ubaciti 4 podatka, po dva za svaku od tabela.
 (Tabela UposlenikZDK ima oznaku 1, a UposlenikHNK oznaku 2).
*/


go
create view view_part_UposlenikKantoni1 as
select UposlenikID, Kanton, NacionalniID, LoginID, RadnoMjesto
from UposlenikZDK1
union all
select UposlenikID, Kanton, NacionalniID, LoginID, RadnoMjesto
from UposlenikHNK1
go

select * from view_part_UposlenikKantoni1

insert into view_part_UposlenikKantoni1
values (10, 1, 'zdk1', 'ze1', 'domacinZDK1')

insert into view_part_UposlenikKantoni1
values (11, 1, 'zdk2', 'ze2', 'domacinZDK2')

insert into view_part_UposlenikKantoni1
values (100, 2, 'hnk1', 'mo1', 'domacinHNK1')

insert into view_part_UposlenikKantoni1
values (101, 2, 'hnk2', 'mo2', 'domacinHNK2')


/*
Kreirati tabele Kvartal1 i Kvatal2 koje će formirati pogled view_part_ProdajaKvartali.
Obje tabele će sadržavati polja ProdajaID, NazivKupca, Kvartal. Sva polja su obavezan
 unos. Tabela Kvartal1 će se označiti brojem 1, a tabela Kvartal2 brojem 2.
Kreirati dijeljeni pogled (partitioned view) view_part_ProdajaKvartali koji će
 podatke koji se unose u njega distribuirati u tabele Kvartal1 i Kvartal2.
Nakon kreiranja u pogled ubaciti 4 podatka, po dva za svaku od tabela. 
(Tabela Kvartal1 ima oznaku 1, a Kvartal2 oznaku 2).
*/

create table Kvratal1
(
	ProdajaID int not null,
	NazivKupca nvarchar (20) not null,
	Kvartal int constraint CK_kvartal1 check (Kvartal = 1),
	constraint PK_kvartal1 primary key (ProdajaID, Kvartal)
)

create table Kvratal2
(
	ProdajaID int not null,
	NazivKupca nvarchar (20) not null,
	Kvartal int constraint CK_kvartal2 check (Kvartal = 2),
	constraint PK_kvartal2 primary key (ProdajaID, Kvartal)
)

go
create view view_part_ProdajaKvartali as
select ProdajaID, NazivKupca, Kvartal
from Kvratal1
union all
select ProdajaID, NazivKupca, Kvartal
from Kvratal2
go

select * from view_part_ProdajaKvartali

insert into view_part_ProdajaKvartali
values (1, 'kupac_1', 1)

insert into view_part_ProdajaKvartali
values (2, 'kupac_2', 1)

insert into view_part_ProdajaKvartali
values (11, 'kupac_11', 2)

insert into view_part_ProdajaKvartali
values (12, 'kupac_12', 2)


/*
Kreirati proceduru nad tabelama HumanResources.Employee i Person.Person 
baze AdventureWorks2014 kojom će se
 dati prikaz polja BusinessEntityID, FirstName i LastName. Proceduru 
 podesiti da se rezultati sortiraju po BusinessEntityID.
*/

use AdventureWorks2014
go
create procedure HumanResources.proc_emp_per1 as
begin 
select e.BusinessEntityID, p.FirstName, p.LastName
from HumanResources.Employee e JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
order by 1
end

exec HumanResources.proc_emp_per1


/*
Kreirati proceduru nad tabelama HumanResources.Employee i Person.Person 
kojom će se definirati sljedeći ulazni parametri: EmployeeID, FirstName, 
LastName, Gender. 
Proceduru kreirati tako da je prilikom izvršavanja moguće unijeti bilo 
koji broj parametara (možemo ostaviti bilo koje polje bez unijetog parametra), 
te da procedura daje rezultat ako je zadovoljena bilo koja od vrijednosti koje
 su navedene kao vrijednosti parametara.
Nakon kreiranja pokrenuti proceduru za sljedeće vrijednosti parametara: 
1. EmployeeID = 20, 
2. LastName = Miller
3. LastName = Abercrombie, Gender = M  
*/

go
create procedure proc_emp_per1
(
	@EmployeeID int = null,
	@FirstName nvarchar (40) = null,
	@LastName nvarchar (40) = null,
	@Gender char (1) = null
)
as 
begin 
select e.BusinessEntityID, p.FirstName, p.LastName, e.Gender
from HumanResources.Employee e JOIN Person.Person p 
		ON e.BusinessEntityID = p.BusinessEntityID
where e.BusinessEntityID = @EmployeeID or
	  p.FirstName = @FirstName or
	  p.LastName = @LastName or
	  e.Gender = @Gender 
end

exec proc_emp_per1 @EmployeeID=20
exec proc_emp_per1 @LastName = 'Miller'
exec proc_emp_per1 @LastName = 'Miller', @Gender = 'M'


/*
Proceduru HumanResources.proc_EmployeesParameters koja je 
kreirana nad tabelama HumanResources.Employee i Person.Person izmijeniti 
tako da je prilikom izvršavanja moguće unijeti bilo koje vrijednosti 
za prva tri parametra (možemo ostaviti bilo koje od tih polja bez unijete vrijednosti),
a da vrijednost četvrtog parametra bude F, odnosno, izmijeniti tako da se dobija 
prikaz samo osoba ženskog pola.
Nakon izmjene pokrenuti proceduru za sljedeće vrijednosti parametara:
1. EmployeeID = 52, 
2. LastName = Miller */

go
alter procedure proc_emp_per1
(
	@EmployeeID int = null,
	@FirstName nvarchar (40) = null,
	@LastName nvarchar (40) = null,
	@Gender char (1) = 'F'
)
as
begin
select e.BusinessEntityID, p.FirstName, p.LastName, e.Gender
from  HumanResources.Employee e JOIN Person.Person p ON
		e.BusinessEntityID = p.BusinessEntityID
where (e.BusinessEntityID = @EmployeeID or
	   p.FirstName = @FirstName or 
	   p.LastName = @LastName) and 
	   e.Gender = @Gender
end
go

exec proc_emp_per1 @EmployeeID = 52
exec proc_emp_per1 @LastName = 'Miller'

/*
Koristeći tabele Sales.SalesOrderHeader i Sales.SalesOrderDetail 
kreirati pogled view_promet koji će se sastojati
od kolona CustomerID, SalesOrderID, ProductID i proizvoda OrderQty i UnitPrice. 
*/

go
create view view_promet1 as 
select h.CustomerID, d.SalesOrderID, d.ProductID, d.OrderQty * d.UnitPrice as proizvod
from Sales.SalesOrderHeader h JOIN  Sales.SalesOrderDetail d
	ON  h.SalesOrderID =  d.SalesOrderID
go

select * from view_promet1 
order by 3

/*
Koristeći pogled view_promet kreirati pogled view_promet_cust_ord
 koji neće sadržavati kolonu ProductID i vršit će sumiranje kolone ukupno.
*/
go
create view view_promet_cust1 as 
select CustomerID, SalesOrderID, sum(proizvod) as suma
from view_promet1
group by CustomerID, SalesOrderID
go

select * from view_promet_cust1

/*
Nad pogledom view_promet_cust_ord kreirati proceduru 
kojom će se definirati ulazni parametri: CustomerID, SalesOrderID i suma.
Proceduru kreirati tako da je prilikom izvršavanja 
moguće unijeti bilo koji broj parametara 
(možemo ostaviti bilo koje polje bez unijetog parametra), 
te da procedura daje rezultat ako je zadovoljena bilo koja 
od vrijednosti koje su navedene kao vrijednosti parametara.
Nakon kreiranja pokrenuti proceduru za vrijednost parametara
 CustomerID = 11019.
Obrisati proceduru, a zatim postaviti uslov da procedura 
vraća samo one zapise u kojima je suma manje od 100, pa ponovo 
pokrenuti za istu vrijednost parametra.
*/

go
create procedure proc_suma1
(
	@CustomerID		int = null,
	@SalesOrderID	int = null,
	@suma			money =null
)
as
begin
select * 
from view_promet_cust1
where CustomerID = @CustomerID or
	  SalesOrderID = @SalesOrderID or
	  suma = @suma
end

exec proc_suma1 @CustomerID = 11019


go
create procedure proc_suma1
(
	@CustomerID		int = null,
	@SalesOrderID	int = null,
	@suma			money =null
)
as
begin
select * 
from view_promet_cust1
where (CustomerID = @CustomerID or
	  SalesOrderID = @SalesOrderID or
	  suma = @suma) and 
	  suma < 100
end

exec proc_suma1 @CustomerID = 11019