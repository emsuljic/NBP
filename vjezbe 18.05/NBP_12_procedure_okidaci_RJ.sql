/*
Kreirati proceduru Narudzba nad tabelama Customers, Products, Order Details i Order baze Northwind kojom će se definirati sljedeći ulazni parametri: ContactName, ProductName, UnitPrice, Quantity i Discount. Proceduru kreirati tako da je prilikom izvršavanja moguće unijeti bilo koji broj parametara (možemo ostaviti bilo koji parametar bez unijete vrijednosti), te da procedura daje rezultat ako je unijeta vrijednost bilo kojeg parametra.
Nakon kreiranja pokrenuti proceduru za sljedeće vrijednosti parametara:
1. ContactName = Mario Pontes
2. Quantity = 10 ili Discount = 0.15
3. UnitPrice = 20
*/
use NORTHWND
go
create procedure narudzba 
(
	@ContactName nvarchar (50) = null,
	@ProductName nvarchar (50) = null,
	@UnitPrice money = null,
	@Quantity int = null,
	@Discount real = null
)
as
begin
select	c.ContactName, p.ProductName, od.UnitPrice, od.Quantity, od.Discount
from	Customers c join Orders o
on		c.CustomerID = o.CustomerID
		join [Order Details] od
		on o.OrderID = od.OrderID
			join Products p
			on od.ProductID = p.ProductID
where	c.ContactName = @ContactName or
		p.ProductName = @ProductName or
		od.UnitPrice = @UnitPrice or
		od.Quantity = @Quantity or
		od.Discount = @Discount
end

exec narudzba @ContactName = 'Mario Pontes'
--32
exec narudzba @Quantity = 10, @Discount = 0.15
--331
exec narudzba @UnitPrice = 20
--15





/*
Kreirati proceduru nad tabelama Production.Product, Production.ProductSubcategory,
 Production.ProductListPriceHistory, Purchasing.ProductVendor kojom će se definirati 
 parametri: p_name za naziv proizvoda, Color, ps_name za naziv potkategorije, ListPrice
  sa zaokruživanjem na dvije decimale, AverageLeadTime, MinOrderQty, MaxOrderQty i Razlika 
  kao razliku maksimalne i minimalne naručene količine. Dati odgovarajuće nazive. Proceduru
   kreirati tako da je prilikom izvršavanja moguće unijeti bilo koji broj parametara 
   (možemo ostaviti bilo koje parametar bez unijete vrijednosti), te da procedura daje 
   rezultat ako je unijeta vrijednost bilo kojeg parametra. Zapisi u proceduri trebaju
    biti sortirani po vrijednostima parametra ListPrice.
Nakon kreiranja pokrenuti proceduru za sljedeće vrijednosti parametara:
1. MaxOrderQty = 1000
2. Razlika = 350
3. Color = Red i naziv potkategorije = Helmets
*/
use AdventureWorks2014
go
create procedure proc_subcat
(
	@p_name nvarchar (50) = null,
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
select	p.Name, p.Color, ps.Name potkategorija, ROUND (plph.ListPrice,2) cijena,
		pv.AverageLeadTime,	pv.MinOrderQty, pv.MaxOrderQty,
		pv.MaxOrderQty - pv.MinOrderQty as razlika
from	Purchasing.ProductVendor pv join Production.Product p
on		pv.ProductID = p.ProductID
		join Production.ProductListPriceHistory plph
		on plph.ProductID = p.ProductID
			join Production.ProductSubcategory ps
			on ps.ProductSubcategoryID = p.ProductSubcategoryID
where	p.Name = @p_name or
		p.Color = @Color or
		ps.Name = @ps_name or
		plph.ListPrice = @ListPrice or
		pv.AverageLeadTime = @AverageLeadTime or
		pv.MinOrderQty = @MinOrderQty or
		pv.MaxOrderQty = @MaxOrderQty or
		pv.MaxOrderQty - pv.MinOrderQty = @Razlika
end

exec proc_subcat @MaxOrderQty = 1000
--63

exec proc_subcat @Razlika = 350
--4
exec proc_subcat @Color = Red, @ps_name=Helmets
--9



/*
Izvršiti izmjenu kreirane procedure tako da prosljeđuje samo one zapise u kojima je razlika veća od 500.
Nakon kreiranja pokrenuti proceduru bez postavljanja vrijednosti za bilo koji parametar, a zatim za sljedeće vrijednosti parametara:
1. MinOrderQty = 100 
2. Color = Red
3. ps_name= Helmets
*/
go
alter procedure proc_subcat
(
	@p_name nvarchar (50) = null,
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
select	p.Name, p.Color, ps.Name potkategorija, ROUND (plph.ListPrice,2) cijena,
		pv.AverageLeadTime,	pv.MinOrderQty, pv.MaxOrderQty,
		pv.MaxOrderQty - pv.MinOrderQty as razlika
from	Purchasing.ProductVendor pv join Production.Product p
on		pv.ProductID = p.ProductID
		join Production.ProductListPriceHistory plph
		on plph.ProductID = p.ProductID
			join Production.ProductSubcategory ps
			on ps.ProductSubcategoryID = p.ProductSubcategoryID
where	pv.MaxOrderQty - pv.MinOrderQty > 500 and
		(p.Name = @p_name or
		p.Color = @Color or
		ps.Name = @ps_name or
		plph.ListPrice = @ListPrice or
		pv.AverageLeadTime = @AverageLeadTime or
		pv.MinOrderQty = @MinOrderQty or
		pv.MaxOrderQty = @MaxOrderQty)	
end

exec proc_subcat @MinOrderQty = 100
--63

exec proc_subcat @Color = Red, @ps_name=Helmets
--3

exec proc_subcat @ps_name=Helmets


/*
Koristeći tabelu Sales.Customer kreirati proceduru proc_account_number kojom će se definirati parametar br_cif_account za pregled broja zapisa po broju cifara u koloni AccountNumber. Proceduru kreirati tako da je prilikom izvršavanja moguće unijeti bilo koji broj parametara (možemo ostaviti bilo koje parametar bez unijete vrijednosti), te da procedura daje rezultat ako je unijeta vrijednost bilo kojeg parametra. Procedura treba da vrati broj cifara (1-, 2- cifreni) i ukupan broj zapisa po cifrenosti.
Nakon kreiranja zasebno pokrenuti proceduru za 1-, 2-, 3- i 5-cifrene brojeve.
*/
go
create view view_cifrenost 
as
select 	len (cast (SUBSTRING (AccountNumber, charindex ('W', AccountNumber) + 1, 8) as int)) as cifrenost,
		count (*) as uk_broj
from	Sales.Customer
group by len (cast (SUBSTRING (AccountNumber, charindex ('W', AccountNumber) + 1, 8) as int))
go

go
create procedure proc_cifrenost
(
	@br_cif_account int = null
)
as
begin
select	*
from	view_cifrenost
where	cifrenost = @br_cif_account
end

exec proc_cifrenost @br_cif_account = 5


/*
U bazi radna kreirati tabele ocjena (student_id int, predmet_id int i ocjena int) i ocjena_logovi (student_id, predmet_id, datum_pristupa datetime i opis char (15)).
*/

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
Nad tabelom ocjena kreirati okidač ins_del_ocjena kojim će se evidentirati datum i vrijeme izvršenja insert, odnosno, delete akcije, te opis izvedene akcije.
*/
go
create trigger ins_del_ocjena
on ocjena
after insert, delete 
as
begin
	insert into ocjena_logovi
	select	i.student_id, i.predmet_id, GETDATE (), 'insert'
	from	inserted as i
	union all
	select	d.student_id, d.predmet_id, GETDATE (), 'delete'
	from	deleted as d
end


/*
Nad tabelom ocjena kreirati okidač update_ocjena kojim će se evidentirati datum i vrijeme izvršenja update akcije, te opis izvedene akcije.
*/
go 
create trigger update_ocjena
on ocjena
for update 
as
begin
	insert into ocjena_logovi
	select	i.student_id, i.predmet_id, GETDATE (), 'update'
	from	inserted as i
end

/*
U tabelu ocjena unijeti 5 zapisa. 
Iz tabele izbrisati zapis predmet_id = 11 i student_id = 1
*/
insert into ocjena
values 
(1, 10, 10),
(1, 11, 9),
(2, 10, 7),
(2, 13, 8),
(1, 13, 9)


select * from ocjena
select * from ocjena_logovi	

delete	ocjena
where	predmet_id = 11 and student_id = 1


/*
Izvršiti update tabele ocjena tako što će se predmet_id = 10 postaviti na 20.
*/
update ocjena
set predmet_id = 20
where predmet_id = 10
