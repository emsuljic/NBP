/*
Kreirati proceduru Narudzba nad tabelama Customers, Products, Order Details i Order baze Northwind kojom će se 
definirati sljedeći ulazni parametri: ContactName, ProductName, UnitPrice, Quantity i Discount. Proceduru kreirati tako da je 
prilikom izvršavanja moguće unijeti bilo koji broj parametara (možemo ostaviti bilo koje parametar bez unijete vrijednosti), 
te da procedura daje rezultat ako je unijeta vrijednost bilo kojeg parametra.
Nakon kreiranja pokrenuti proceduru za sljedeće vrijednos
Nakon kreiranja pokrenuti proceduru za sljedeće vrijednosti parametara:
1. ContactName = Mario Pontes
2. OrderID = 10253
3. Quantity = 10	ili Discount = 0.15
4. UnitPrice = 20
*/

use NORTHWND

go
create procedure narudzba
(
--parametri
	@ContactName nvarchar (30) = null,
	@ProductName nvarchar (30) =null,
	@UnitPrice money = null,
	@Quantity int = null,
	@Discount real = null
)
as
begin
--upit
select c.ContactName, p.ProductName, od.UnitPrice, od.Quantity, od.Discount
from Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
		join [Order Details] od on O.OrderID = od.OrderID
			join Products p ON od.ProductID = p.ProductID
--navesti kolone na koje se referencijraju nasi parametri
where c.ContactName = @ContactName or
		p.ProductName = @ProductName or
		od.UnitPrice = @UnitPrice or
		od.Quantity = @Quantity or 
		od.Discount = @Discount
end 
go

exec narudzba @ContactName = 'Mario Pontes'
--32 zapisa

exec narudzba @Quantity = 10, @Discount =0.15
--331 zapisa

exec narudzba @UnitPrice = 20
--15 zapisa


/*
Kreirati proceduru nad tabelama Production.Product, Production.ProductSubcategory, Production.ProductListPriceHistory, Purchasing.ProductVendor
 kojom će se definirati parametri: p_name za naziv proizvoda, Color, ps_name za naziv potkategorije, ListPrice sa zaokruživanjem na dvije decimale, 
 AverageLeadTime, MinOrderQty, MaxOrderQty i Razlika kao razliku maksimalne i minimalne naručene količine. Dati odgovarajuće nazive. 
Proceduru kreirati tako da je prilikom izvršavanja moguće unijeti bilo koji broj parametara (možemo ostaviti bilo koje parametar bez unijete vrijednosti),
 te da procedura daje rezultat ako je unijeta vrijednost bilo kojeg parametra. Zapisi u proceduri trebaju biti sortirani po vrijednostima parametra ListPrice.
Nakon kreiranja pokrenuti proceduru za sljedeće vrijednosti parametara:
1. MaxOrderQty = 1000
2. Razlika = 350
3. Color = Red i naziv potkategorije = Helmets
*/

use AdventureWorks2014

go 
create procedure proc_subcat
(
	@p_name nvarchar (40) = null,
	@Color nvarchar (15) = null,
	@ps_name nvarchar (50) = null,
	@ListPrice money = null,
	@AverageLeadTime int = null,
	@MinOrderQty int = null,
	@MaxOrderQty int = null,
	@Razlika int = null
)
as 
begin
select p.Name, p.Color, ps.Name as potkat, round(plph.ListPrice, 2) cijena, pv.AverageLeadTime, pv.MinOrderQty, pv.MaxOrderQty,
		pv.MaxOrderQty - pv.MinOrderQty as razlika 
from Purchasing.ProductVendor pv join Production.Product p 
	ON  pv.ProductID = p.ProductID
	JOIN Production.ProductListPriceHistory plph
		ON plph.ProductID = p.ProductID
			JOIN Production.ProductSubcategory ps 
				ON ps.ProductSubcategoryID = p.ProductSubcategoryID
where p.Name = @p_name or 
	  p.Color = @Color or 
	  ps.Name = @ps_name or
	  plph.ListPrice = @ListPrice or
	  pv.AverageLeadTime = @AverageLeadTime or 
	  pv.MinOrderQty = @MinOrderQty or
	  pv.MaxOrderQty = @MaxOrderQty or 
	  pv.MaxOrderQty - pv.MinOrderQty = @Razlika
order by 4
end


/*
Izvršiti izmjenu kreirane procedure tako da rpsoljeđuje samo one zapise u kojima je Razlika veća od 500.
Nakon kreiranja pokrenuti proceduru bez postavljanja vrijednosti za bilo koji parametar, a zatim za sljedeće vrijednosti parametara:
1. MinOrderQty = 100 
2. Color = Red
3. ps_name= Helmets
*/



/*
Koristeći tabelu Sales.Customer kreirati proceduru proc_account_number kojom će se definirati parametar br_cif_account za pregled broja zapisa po broju cifara u koloni AccountNumber. Proceduru kreirati tako da je prilikom izvršavanja moguće unijeti bilo koji broj parametara (možemo ostaviti bilo koje parametar bez unijete vrijednosti), te da procedura daje rezultat ako je unijeta vrijednost bilo kojeg parametra. Procedura treba da vrati broj cifara (1-, 2- cifreni) i ukupan broj zapisa po cif
Procedura treba da vrati broj cifara (1-, 2- cifreni) i ukupan broj zapisa po cifrenosti.
Nakon kreiranja zasebno pokrenuti proceduru za 1-, 2-. 3- i 5-cifrene brojeve.*/


go
create view view_acc_numb
as
select len( cast ( SUBSTRING(AccountNumber, CHARINDEX('W', AccountNumber)+1, 8) as int )) as cifrenost, 
		count(*) uk_broj
from Sales.Customer
group by len( cast ( SUBSTRING(AccountNumber, CHARINDEX('W', AccountNumber)+1, 8) as int ))
go


go
create procedure proc_account_number
(
	@br_cif_account int = null	
)
as
begin
select *
from view_acc_numb
where cifrenost = @br_cif_account
end

exec proc_account_number @br_cif_account = 2


--TRIGERI
/*
U bazi radna kreirati tabele ocjena (student_id int, predmet_id int i ocjena int) i 
ocjena_logovi (student_id, predmet_id, datum_pristupa datetime i opis char (15)).
*/

use radna

create table ocjena
(
	student_id int, 
	predmet_id int,
	ocjena int
)

create table ocjena_logovi
(
	student_id int, 
	predmet_id int, 
	datum_pristupa datetime,
	opis char (15)
)


/*
Nad tabelom ocjena kreirati okidač ins_del_ocjena kojim će se evidentirati datum i vrijeme izvršenja insert,
odnosno, delete akcije, te opis izvedene akcije.
*/

go
create trigger ins_del_ocjena 
on ocjena --naziv tabele nad kojom se kreira trigger
after insert, delete -- pokrece se trigger nad tabelom ocjena nakon sto se izvrse insert ili delete
as 
begin
	insert into ocjena_logovi
	select  i.student_id, i.predmet_id, GETDATE(), 'insert'
	from	inserted as i
	union all
	select d.student_id, d.predmet_id, GETDATE(), 'delete'
	from deleted as d
end


/*
Nad tabelom ocjena kreirati okidač update_ocjena kojim će se evidentirati datum i vrijeme izvršenja update akcije, 
te opis izvedene akcije.
*/

go
create trigger update_ocjena 
on ocjena
after update
as
begin
	insert into ocjena_logovi 
	select	i.student_id, i.predmet_id, GETDATE(), 'update'
	from    inserted as i
end

/*U tabelu ocjena unijeti 5 zapisa*/

insert into ocjena
values
(1, 10, 8),
(1, 11, 9),
(2, 10, 10),
(1, 100, 7),
(2, 100, 9)

select * from ocjena
select * from ocjena_logovi

--provjera delete-a

delete ocjena
where ocjena = 7 and student_id=1


/*
Izvrsiti update tabele ocjena tako sto ce se predmet_id=10 postaviti na 20
*/

update ocjena
set predmet_id = 20
where predmet_id = 10

select * from ocjena
select * from ocjena_logovi

/*
Nad tabelom ocjena kreirati okidače kojim će se omogućiti :
a) brisanje podataka
b) update podataka
*/


--a)
go
create trigger zabr_brisanja
on ocjena
instead of delete --kazemo da se to ne moze se uraditi u ovom slucaju delete
as
begin 
	select 'brisanje nije moguce' upozorenje
	--print 'brisanje nije moguce'
	rollback
end

--provjera
delete ocjena
where ocjena = 8 

select * from ocjena
select * from ocjena_logovi

--b)
go
create trigger zabr_update
on ocjena
instead of update --kazemo da se to ne moze se uraditi u ovom slucaju update
as
begin 
	select 'update nije moguce' upozorenje
	rollback
end

--provjera
update ocjena
set predmet_id = 10
where predmet_id = 20

select * from ocjena
select * from ocjena_logovi



/*
Kreirati bazu test, a zatim u njoj kreirati DDL okidač (trigger) koji će onemogućavati kreiranje, izmjenu i brisanje tabela i pogleda.
Okidač treba da daje poruku 'Kreiranje, brisanje i izmjene tabela i pogleda nisu dozvoljeni!'.
*/

create database test 
use Test


--ako kreiramo trigger nad bazom, ne navodimo je, samo je aktiviramo
go
create trigger preventiva
on database
for create_table, create_view, drop_table, drop_view, alter_table, alter_view
as
begin 
	print 'nista nije moguce uraditi'
	rollback
end


/*kreirati tableu test_tab sa kolonom id int, a nakon toga */
create table test_tab 
(
	id int
)

/**/
disable trigger

/**/
