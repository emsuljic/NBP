use AdventureWorks2014
go

select top 100 * from Production.Product

select ListPrice, Size, DaysToManufacture
from Production.Product
-- Size na nekoliko mjesta ima NULL vrijednost 

select max(ListPrice) AS MaxListPrice, min (ListPrice) AS MinListPrice,
	avg(convert(int, Size)) AS AvgProductSize,
	sum(DaysToManufacture) AS TotalDaysToManafacture
from Production.Product
where isnumeric (Size) = 1
--morali smo u where staviti ovu funkciju 'isnumeric' koja vraca true ili false
--zasto? zato sto u koloni Size imamo vrijednosti koje nisu tipa int 
--pa stoga da bismo dobili rezultat avg funkcije u select-u stavili smo uslov da je Size numeric

select min(SellEndDate), MAX(SellEndDate)
from Production.Product

select count(*), count (SellEndDate)
from Production.Product
--* prebroji sve zapise rez=504
--SellEndDate rez=98 zato sto count ne broji NULL vrijednosti kojih ima u ovoj koloni 

select count(Weight) AS CountOfWeights, avg(Weight) AS Average
from Production.Product

select count(*), count(Weight), avg(Weight), avg(isnull(Weight, 0))
from Production.Product
--count(*) prebroji sve rekorde/zapise
--count(Weight) prebroji koliko je ovih weight
--avg(dadne nam prosjecnu vr. weight) ALI BEZ ONIH NULL VRIJEDNOSTI
--avg(isnull(Weight, 0)) dadne nam avg svih zapisa sada jer smo funkcijom isnull promijenili sve zapise gdje smo imali NULL vrijednost u 0

select * from Purchasing.PurchaseOrderDetail

select sum(OrderQty) AS TotalOrderQty 
from Purchasing.PurchaseOrderDetail
where ProductID=1 and DueDate< '2014-06-14'
-- daj nam sumu svih order kolicina kao alijas TotalOrderQty
--ali pod uslovom gdje je ProductID=1 i datum manji od navedenog

select count(EmployeeID) AS NumberOfOrders, sum(SubTotal) AS TtoalProfit,
	avg (Freight) AS AverageFreight, max(TaxAmt) AS MaxTax
from Purchasing.PurchaseOrderHeader
where EmployeeID=255 and DATEDIFF(day, OrderDate, ShipDate)<10
--count prebroj sve empleyeeID dakle sve narudzbe da prebroji koje je taj employee ostvario
--sum -sumiraj SubTotal (koliko je kupac u toj narudzi platio novca, tj koliko je pojedini zaposlenik donio profita)
--avg -srednja vrijednost tog podatka
--max -maksimalno placeno poreza iz svih narudzi koje je zaposlenik odradio
--filtriranje tamo gdje nam je EmployeeID =255
--datediff funkcija pravi razliku dva datuma u vremenskoj jedinci koju mi definisemo(day, month, year)
--sto znaci zapravo da nam izbaci one gdje je isporuka trajala ispod 10 dana 

select ProductID, count(ProductID) AS ProductSales, sum(LineTotal) AS Profit
from Purchasing.PurchaseOrderDetail
order by ProductID 
--sa samo ovim javit ce se error ZASTO?
--jer ako u selectu imamo agregatne funkcije nad nekim atributom koji je u selectu
--tada moramo uraditi GROUP BY prema tom atributu
select ProductID, count(ProductID) AS ProductSales, sum(LineTotal) AS Profit
from Purchasing.PurchaseOrderDetail
group by ProductID
order by ProductID 
--oredr by -> sortira
--group by -> grupise one kolone koje nisu u funkcijama za agregaciju
--sada ovaj query RADI


select sum (OrderQty) AS TotalOrderQty
from Purchasing.PurchaseOrderDetail
having sum(OrderQty)>1000
--kao uslov stavljamo funkciju za agregaciju pomocu HAVING
--daje nam sumu OrderQty
--u runTime nad ovom sumom koju kreira i onda ce je ponovo sumirati i testira u letu izlaz >1000
--da smo umjesto having koristili where imali bi error (JER WHERE NE PODRZAVA AGREGATNE FUNKCIJE)


select ProductID, LocationID, sum (Quantity) as TotalQuantity
from Production.ProductInventory
group by ProductID, LocationID
order by ProductID, LocationID desc
--GROUP BY moze imati i vise kolona odjednom
--grupira po produktu i po lokaciji
--da imamo u selectu 100 kolona od tih 100 samo je jedna npr avg a ostaih 99 su van agregacije, moramo navesti sve u group by



