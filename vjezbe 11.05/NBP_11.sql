create database radna
use radna

/*Primarni ključ je kompozitni i sastoji se od kolona UposlenikID i Kanton.*/

create table UposlenikZDK
(
	UposlenikID int not null,
	Kanton int not null constraint CK_ZDK check (Kanton=1),
	NacionalniID nvarchar (20) not null,
	LoginID nvarchar (20) not null,
	RadnoMjesto nvarchar (20) not null,
	constraint PK_ZDK primary key (UposlenikID, Kanton) 
)

create table UposlenikHNK
(
	UposlenikID int not null,
	Kanton int not null constraint CK_HNK check (Kanton=2),
	NacionalniID nvarchar (20) not null,
	LoginID nvarchar (20) not null,
	RadnoMjesto nvarchar (20) not null,
	constraint PK_HNK primary key (UposlenikID, Kanton) 
)

/*
Kreirati dijeljeni pogled (partitioned view) view_part_UposlenikKantoni koji će podatke koji se unose u njega distribuirati u tabele UposlenikZDK i UposlenikHNK. 
Nakon kreiranja u pogled ubaciti 4 podatka, po dva za svaku od tabela. (Tabela UposlenikZDK ima oznaku 1, a UposlenikHNK oznaku 2).
*/

go
create view view_part_UposlenikKantoni as
select UposlenikID, Kanton, NacionalniID, LoginID, RadnoMjesto
from UposlenikZDK
union all
select UposlenikID, Kanton, NacionalniID, LoginID, RadnoMjesto
from UposlenikHNK
go

insert into  view_part_UposlenikKantoni
values (10, 1, 'zdk1', 'ze1', 'domacin_zdk_1')

insert into view_part_UposlenikKantoni
values (11, 1, 'zdk2', 'ze2', 'domacin_zdk_2')

insert into view_part_UposlenikKantoni
values (100, 2, 'hnk1', 'mo1', 'domacin_hnk_1')

insert into view_part_UposlenikKantoni
values (101, 2, 'hnk2', 'mo2', 'domacin_hnk_2')

select * from view_part_UposlenikKantoni

select * from UposlenikHNK
select * from UposlenikZDK

/*
Kreirati tabele Kvartal1 i Kvatal2 koje će formirati pogled view_part_ProdajaKvartali. Obje tabele će sadržavati polja ProdajaID (int), NazivKupca nvarchar (20), Kvartal (int). Sva polja su obavezan unos. Tabela Kvartal1 će se označiti brojem 1, a tabela Kvartal2 brojem 2.
Kreirati dijeljeni pogled (partitioned view) view_part_ProdajaKvartali koji će podatke koji se unose u njega distribuirati u tabele Kvartal1 i Kvartal2.
Nakon kreiranja u pogled ubaciti 4 podatka, po dva za svaku od tabela. Primarni ključ je kompozitni i sastoji se od kolona UposlenikID i Kanton. */

create table Kvartal1
(
	ProdajaID int not null,
	NazivKupca nvarchar (20) not null,
	Kvartal int constraint CK_kvartal1 check (Kvartal=1),
	constraint PK_kvartal1 primary key (ProdajaID, Kvartal)
)

create table Kvartal2
(
	ProdajaID int not null,
	NazivKupca nvarchar (20) not null,
	Kvartal int constraint CK_kvartal2 check (Kvartal=2),
	constraint PK_kvartal2 primary key (ProdajaID, Kvartal)
)

go
create view view_kvartal as
select ProdajaID, NazivKupca, Kvartal
from Kvartal1
union all
select ProdajaID, NazivKupca, Kvartal
from Kvartal2
go

insert into view_kvartal
values (1, 'kupac_1', 1)

insert into view_kvartal
values (2, 'kupac_2', 1)

insert into view_kvartal
values (100, 'kupac_3', 2)

insert into view_kvartal
values (101, 'kupac_4', 2)

select * from view_kvartal
select * from Kvartal1
select * from Kvartal2

/*
Kreirati proceduru nad tabelama HumanResources.Employee i Person.Person baze AdventureWorks2014 kojom će se
 dati prikaz polja BusinessEntityID, FirstName i LastName. Proceduru podesiti da se rezultati sortiraju po BusinessEntityID.
*/
use AdventureWorks2014
go
create  procedure HumanResources.proc_emp_per as
begin 
select e.BusinessEntityID, p.FirstName, p.LastName, e.BirthDate
from HumanResources.Employee e join Person.Person p 
on e.BusinessEntityID = p.BusinessEntityID
--where year (e.BirthDate) between 1950 and 1970
order by 1
end

exec HumanResources.proc_emp_per

/*
Kreirati proceduru nad tabelama HumanResources.Employee i Person.Person kojom će se definirati sljedeći ulazni parametri: EmployeeID, FirstName, LastName, Gender. 
Proceduru kreirati tako da je prilikom izvršavanja moguće unijeti bilo koji broj parametara (možemo ostaviti bilo koje polje bez unijetog parametra), te da procedura daje rezultat ako je zadovoljena bilo koja od vrijednosti koje su navedene kao vrijednosti parametara.
Nakon kreiranja pokrenuti proceduru za sljedeće vrijednosti parametara: 
1. EmployeeID = 20, 
2. LastName = Miller
3. LastName = Abercrombie, Gender = M  
*/

go
create procedure proc_emp_per
(
	@EmployeeID int = null,
	@FirstName nvarchar (40) = null,
	@LastName nvarchar (40) = null,
	@Gender char (1) = null
)
as
begin
select e.BusinessEntityID, p.FirstName, p.LastName, e.Gender
from HumanResources.Employee e join Person.Person p
on e.BusinessEntityID = p.BusinessEntityID
where e.BusinessEntityID  = @EmployeeID or 
	  p.FirstName = 	@FirstName or
	  p.LastName = @LastName or
	  e.Gender = @Gender
end

exec proc_emp_per @EmployeeID = 20
exec proc_emp_per @LastName = 'Miller'
exec proc_emp_per @LastName = 'Abercrombie', @Gender = 'M'

/*
Proceduru HumanResources.proc_EmployeesParameters koja je kreirana nad tabelama HumanResources.Employee i Person.Person izmijeniti tako da je prilikom izvršavanja moguće unijeti bilo koje vrijednosti za prva tri parametra (možemo ostaviti bilo koje od tih polja bez unijete vrijednosti), a da vrijednost četvrtog parametra bude F, odnosno, izmijeniti tako da se dobija prikaz samo osoba ženskog pola.
Nakon izmjene pokrenuti proceduru za sljedeće vrijednosti parametara:
1. EmployeeID = 52, 
2. LastName = Miller */

go
alter procedure proc_emp_per
(
	@EmployeeID int = null,
	@FirstName nvarchar (40) = null,
	@LastName nvarchar (40) = null,
	@Gender char (1) = 'F'
)

as
begin
select e.BusinessEntityID, p.FirstName, p.LastName, e.Gender
from HumanResources.Employee e join Person.Person p
on e.BusinessEntityID = p.BusinessEntityID
where (e.BusinessEntityID = @EmployeeID or
	  p.FirstName = @FirstName or
	  p.LastName = @LastName) and
	  e.Gender = @Gender
end
go

exec proc_emp_per @EmployeeID = 52
exec proc_emp_per @LastName = 'Miller'


/*
Koristeći tabele Sales.SalesOrderHeader i Sales.SalesOrderDetail kreirati pogled view_promet koji će se sastojati
 od kolona CustomerID, SalesOrderID, ProductID i proizvoda OrderQty i UnitPrice. 
*/

go
create view view_promet as
select soha.CustomerID, soda.SalesOrderID, soda.ProductID,
	soda.OrderQty * soda.UnitPrice as proizvod
from Sales.SalesOrderHeader soha join Sales.SalesOrderDetail soda
on soha.SalesOrderID = soda.SalesOrderID
go

select * from view_promet
order by 3

/*
Koristeći pogled view_promet kreirati pogled view_promet_cust_ord koji neće sadržavati kolonu ProductID i vršit će sumiranje kolone ukupno.
*/

go
create view view_promet_cust_ord as
select CustomerID, SalesOrderID, sum (proizvod) as suma
from view_promet
group by CustomerID, SalesOrderID
go

select * from view_promet_cust_ord
order by 1, 2


/*
Nad pogledom view_promet_cust_ord kreirati proceduru kojom će se definirati ulazni parametri: CustomerID, SalesOrderID i suma.
Proceduru kreirati tako da je prilikom izvršavanja moguće unijeti bilo koji broj parametara (možemo ostaviti bilo koje polje bez unijetog parametra), te da procedura daje rezultat ako je zadovoljena bilo koja od vrijednosti koje su navedene kao vrijednosti parametara.
Nakon kreiranja pokrenuti proceduru za vrijednost parametara CustomerID = 11019.
Obrisati proceduru, a zatim postaviti uslov da procedura vraća samo one zapise u kojima je suma manje od 100, pa ponovo pokrenuti za istu vrijednost parametra.
*/
go
create procedure proc_suma
(
	@CustomerID int = null, 
	@SalesOrderID int = null, 
	@suma money = null
)

as
begin
select * 
from view_promet_cust_ord
where (CustomerID = @CustomerID or 
	  SalesOrderID = @SalesOrderID or 
	  suma = @suma) and
	  suma<100
end 

exec proc_suma @CustomerID = 11019