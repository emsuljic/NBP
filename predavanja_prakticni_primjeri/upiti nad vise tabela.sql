use AdventureWorks2014
go

--proizvodi sa njima pripadajucim komentarima
select P.Name, PR.Comments
from Production.Product AS P 
	INNER JOIN Production.ProductReview AS PR 
	ON P.ProductID = PR.ProductID

select P.ProductNumber, R.Comments 
from Production.Product P 
	LEFT OUTER JOIN Production.ProductReview R
	ON P.ProductID = R.ProductID
order by R.Comments desc
-- zapisi i sa jedne i druge strane 
-- lijevi vanjski spoj 
-- da sve proizvede koji imaju komentar i one koji nemaju komentar 
-- znaci dat ce i te proizvode samo sto ce imati NULL  na komentaru (LIJEVI JOIN)
-- lijeva tabela Product 
-- desna tabela ProductReview

select P.ProductNumber, R.Comments
from Production.Product P
	RIGHT OUTER JOIN Production.ProductReview R
	ON P.ProductID = R.ProductID
--ovdje imamo desni outer join- svi zajednicki zapisi 
--i plus oni komentari koji nemaju proizvoda
-- vratit ce isto kao iprethodni jer nma niti jednog komentara da postoji 
-- a da nema svog proizvoda
-- iz desne tabele svi oni koji nemaju korespodenta u lijevoj


select P.ProductNumber, R.Comments
from Production.Product P
	FULL OUTER JOIN Production.ProductReview R
	ON P.ProductID = R.ProductID
--FULL OUTER JOIN - daj sve zajednicke i sve lijeve koji ne postoje u desnoj 
--i sve desne koji ne postoje u lijevoj tabeli 

--kombinacija jednog zapisa iz lijeve tabele sa svim zapisima iz desne tabele
select P.ProductNumber, R.Comments
from Production.Product P
	cross join Production.ProductReview R 
-- vidimo i u rezultatu da se ponavljaju neki dakle kombinuje svaki sa svakim
 
 select P.Name AS Product, L.Name AS Location, I.Quantity
 from Production.Product P 
	INNER JOIN Production.ProductInventory I
	ON P.ProductID = I.ProductID
		INNER JOIN Production.Location L
			ON L.LocationID = I.LocationID
-- spajamo 3 tabele i uzimamo tu neke podatke u select-u

--varijacija unutarnjeg spoja tabele same sa sobom:
select P1.Name, P1.ListPrice 
from Production.Product AS P1
	INNER JOIN Production.Product AS P2
	ON P1.ProductSubcategoryID = P2.ProductSubcategoryID
GROUP BY P1.Name, P1.ListPrice
HAVING P1.ListPrice > AVG (P2.ListPrice)
--dakle pravi dvije identicne tabele da bi mogao izracunati poslije u havingu
--samo promijenimo alijas P1 i P2 da bi se mogle te tabele razlikovati po necemu
--dakle uslov je: daj one proizvode cija je cijena po komadu veca od prosjecne cijene svih artikala 
--prosjecnu cijenu svih artikala racuna u toj drugoj tabeeli P2
--dakle u select imamo ime proizvoda i listPrice (za koji smo postavili uslov u HAVING)

select P.Name AS Product, V.Name AS Vendor, M.Name AS Measure
from Production.Product P
	INNER JOIN Purchasing.ProductVendor PV
	 ON P.ProductID = PV.ProductID
		INNER JOIN Purchasing.Vendor V
			ON PV.BusinessEntityID = V.BusinessEntityID
				INNER JOIN Production.UnitMeasure M
					ON M.UnitMeasureCode = PV.UnitMeasureCode
--kompleksniji JOIN nad vise tabela
--potrebno je pogledati dijagram za ove tabele
-- da bi se shvatilo o cemu se radi 


select ProductModelID AS [Product ID], ModifiedDate AS [Date Of Modification]
from Production.ProductModelProductDescriptionCulture
UNION
	select ProductModelID AS [Product ID], ModifiedDate AS [Date Of Modification]
	from Production.ProductModel

--ovdje imamo dva nezavisna query-a jedan iznad UNION jedan ispod UNION 
--ista im je struktura redoslijed, samo se razlikuje tabela 
--kada pokrenemo pojedinacno ove query-e dobijemo jako puno zapisa za svaki
--medjutim kada pokrenemo sa UNION dobijemo jako malo zapisa
--STA SE DESILO??? ->>> UNION eliminise duplikate i tako smo smanjili broj zapisa
--unija--

select ProductModelID AS [Product ID], ModifiedDate AS [Date Of Modification]
from Production.ProductModelProductDescriptionCulture
EXCEPT
	select ProductModelID AS [Product ID], ModifiedDate AS [Date Of Modification]
	from Production.ProductModel
--isti query samo sa EXCEPT
--ova funkcije EXCEPT je zapravo razlika 
--eliminise zapise koji postoje u lijevoj iz desne tabele (bukvalno oduzima)
--izbaci elementee koji postoje u oba skupa
--razlika--

select ProductModelID AS [Product ID], ModifiedDate AS [Date Of Modification]
from Production.ProductModelProductDescriptionCulture
INTERSECT
	select ProductModelID AS [Product ID], ModifiedDate AS [Date Of Modification]
	from Production.ProductModel
--daje nam zapise koji postoje u oba query-a dakle ne radi se o tabelama nego query-ima
--presjek

--JOIN OPERATORI SE FOKUSIRAJU NA TABELE
-- UNION, EXCEPT, INTERSECT->FOKUSIRAJU SE NA QUERY-E, RAZLICITE UPITE KOMBINUJU I DAJU REZULTAT


select top 10 P.Name AS Product, L.Name AS Location, I.Quantity
from Production.Product P
INNER JOIN Production.ProductInventory I
ON P.ProductID = I.ProductID 
	INNER JOIN Production.Location L
	ON L.LocationID = I.LocationID
	order by I.Quantity asc

	--daj prvih deset TOP 10
	--JOIN 3 tabele 
	--s tim da se radi order po kolicini ASC tih artikala
	--AKO KAZEMO ASC DAT CE OD POCETKA 10
	--AKO KAZEMO DESC DAT CE S KRAJA 10 

select Name as Product
from Production.Product tablesample (40 percent)

--RANDOM
--od kolicine podataka koji postoje u ovoj tabeli navedenoj 
--kazemu mu tablesample 40 percent
-- dakle daj nam 40% od te tabele random podataka