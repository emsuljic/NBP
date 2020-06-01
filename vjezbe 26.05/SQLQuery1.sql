use radna1

/*
U bazu radna iz baze AdventureWorks2014 šeme Production prekopirati tabele 
Product, WorkOrder i WorkOrderRouting. Zadržati iste nazive tabela. 
Tabele smjestiti u defaultnu šemu.
*/

select * 
into Product
from AdventureWorks2014.Production.Product

select *
into WorkOrder
from AdventureWorks2014.Production.WorkOrder

select *
into WorkOrderRouting 
from AdventureWorks2014.Production.WorkOrderRouting


/*
U kopiranim tabelama u bazi radna postaviti iste PK i potrebne FK kako 
bi se ostvarila veza između tabela.
*/


alter table Product
add constraint PK_product primary key (ProductID)

alter table WorkOrder
add constraint PK_workOrder primary key (WorkOrderID)

alter table WorkOrder
add constraint FK_workOrder_product foreign key (ProductID) references Product (ProductID)

alter table WorkOrderRouting
add constraint PK_workOrderRouting primary key (WorkOrderID, ProductID, OperationSequence)

alter table WorkOrderRouting 
add constraint FK_workOrderRouting foreign key (WorkOrder) references WorkOrder (WorkOrderID)


/*
a) U tabeli Product kreirati ograničenje nad kolonom ListPrice kojim će 
biti onemogućen unos negativnog podatka.
b) U tabeli WorkOrder kreirati ograničenje nad kolonom EndDate kojim će se 
onemogućiti unos podatka manjeg od StartDate.
*/

alter table Product 
add constraint CK_ListPrice check (ListPrice>=0)

alter table WorkOrder 
add constraint CK_WorkOrder check (EndDate >= StartDate)


/*
Kreirati proceduru koja će izmijeniti podatke u koloni LocationID tabele 
WorkOrderRouting po sljedećem principu:
	10 -> A
	20 -> B
	30 -> C
	40 -> D
	45 -> E
	50 -> F
	60 -> G
*/

alter table WorkOrderRouting
alter column LocationID char (2)

go 
create procedure proc_location
as
begin
update WorkOrderRouting
set LocationID = 'A'
where LocationID = '10'
update WorkOrderRouting
set LocationID = 'B'
where LocationID = '20'
update WorkOrderRouting
set LocationID = 'C'
where LocationID = '30'
update WorkOrderRouting
set LocationID = 'D'
where LocationID = '40'
update WorkOrderRouting
set LocationID = 'E'
where LocationID = '45'
update WorkOrderRouting
set LocationID = 'F'
where LocationID = '50'
update WorkOrderRouting
set LocationID = 'G'
where LocationID = '60'
end



/*
Obrisati ograničenje kojim se definisala veza između tabela Product i WorkOrder.
*/

alter table WorkOrder
drop constraint [FK_workOrder_product]

/*
Podaci u koloni ProductNumber imaju formu AB-1234. 
Neka slova označavaju klasu podatka. Dati informaciju koliko različitih klasa 
postoji.
*/

select count(distinct LEFT(ProductNumber, 2))
from Product

/*
a) U tabeli Product kreirati kolonu klasa u koju će se smještati klase 
kolone ProductNumber pri čemu u kolonu neće biti moguće pohraniti više od dva znaka.
b) Novoformiranu kolonu popuniti klasama iz kolone ProductNumber
*/

alter table Product
add klasa char (5)

alter table Product
add constraint CK_klasa check (len(klasa)<=2)

select klasa from Product

--

update Product 
set klasa = left(ProductNumber, 2)


/*
Kreirati tabelu Cost u kojoj će biti kolone WorkOrderID i PlannedCost tabele 
WorkOrderRouting. 
Nakon toga dodati izračunatu (stalno pohranjenu) kolonu fening u kojoj će biti 
vrijednost feninga iz kolone PlannedCost.
Vrijednost feninga mora biti izražena kao cijeli broj (ne prihvata se oblik 0.20).
*/

select WorkOrderID, PlannedCost
into Cost
from WorkOrderRouting

alter table Cost
add fening as convert(int, (PlannedCost - floor(PlannedCost))*100)

--moze i ovako
alter table Cost
add fening as cast ((PlannedCost - floor (PlannedCost)) * 100 as int )

select * 
from Cost

/*
U tabeli Cost dodati novu kolonu klasa u kojoj će biti oznaka 1 ako 
je vrijednost feninga manja od 50, odnosno, 2 ako je vrijednost feninga 
veća ili jednaka od 50.
*/

alter table Cost
add klasa int 

go
create procedure proc_klasa_fen
as
begin
update Cost
set klasa = 1
where fening < 50
update Cost
set klasa = 2
where fening >= 50
end
go

exec proc_klasa_fen


/*
U tabeli Product se nalazi kolona ProductLine. Prebrojati broj pojavljivanja 
svake od vrijednosti iz ove kolone, 
a zatim dati informaciju koliko je klasa čiji je broj pojavljivanja manji, 
a koliko veći od srednje vrijednosti broja pojavljivanja.
*/

go
create view view_br_klasa
as
select ProductLine, count(*) as ukupno
from Product
group by ProductLine
go

select 'manje', count(*)
from view_br_klasa
where ukupno < (select AVG(ukupno) from view_br_klasa)
union
select 'veće', count (*)
from view_br_klasa
where ukupno > (select avg(ukupno) from view_br_klasa)

/*
Kreirati proceduru kojom će se u tabeli Product za ReorderPoint koji su manji 
od 100 izvršiti uvećanje za unijetu vrijednost parametra povecanje.
*/

go 
create procedure proc_uvecanje
(
	@pocevanje int = null
)
as 
begin
update Product
set ReorderPoint = ReorderPoint + @pocevanje
where ReorderPoint < 100
end 

exec proc_uvecanje @pocevanje =100

select * from Product

/*
Kreirati proceduru kojom će se u tabeli Product vršiti brisanje zapisa prema 
unijetoj vrijednosti ProductSubcategoryID.
*/

go
create procedure proc_delete
(
	@brisanje int
)
as
begin
	delete Product
	where  ProductSubcategoryID = @brisanje
end

exec proc_delete 1


/*
Kreirati proceduru kojom će se u tabeli Product vršiti izmjena postojećeg u 
proizvoljni naziv boje. Npr. Black preimenovati u crna.
*/

go
create procedure proc_color
(
	@Color		nvarchar (15) = null,
	@new_color	nvarchar (15) = null
)
as
begin
	update Product
	set    Color = @new_color
	where  Color =  @Color
end
go

select *
from Product

exec proc_color 'Black', 'crna'