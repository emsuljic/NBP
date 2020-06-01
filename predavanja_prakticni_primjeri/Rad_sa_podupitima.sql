use AdventureWorks2014
go
--subquery su nezavisni


--1.
SELECT LastName, FirstName --vanjski upis
FROM Person.Person
WHERE Title IN
	(SELECT DISTINCT Title --unutarnji upit 
	FROM Person.Person
	WHERE Title IS NOT NULL)
ORDER BY LastName
--uzima title posebnim query-em
--daje nam samo one osobe koje imaju neki title


--2.
SELECT LastName, FirstName --vanjski upis
FROM Person.Person
WHERE Title =
	(SELECT DISTINCT Title --unutarnji upit 
	FROM Person.Person
	WHERE Title IS NOT NULL)
ORDER BY LastName
--ovaj nece raditi jer smo stavili Title= 
--jer se ocekuje jedna vrijednost, a mi mu prosjljedjujemo unutarnjim upitom listu title-a
--dakle ne poklapa se i nece raditi 
 
 SELECT LastName, FirstName --outer query
 From Person.Person
 WHERE Title IN ('Sr.', 'Mrs.', 'Sra.', 'Ms.', 'Ms', 'Mr.')
 ORDER BY LastName
 --ovaj ce raditi isto kao prvi 
 --medjutim puno je lakse uraditi na prvi nacin jer ne znamo mi koje su sve title pristune u bazi
 --ne mozemo ih sve izdvojiti ovako pa je lakse podupitom posebne liste svih title

 --4
 SELECT LastName, FirstName 
 FROM Person.Person
 WHERE Title=
	(Select distinct Title
	from Person.Person
	WHERE Title='Ms.')
order by LastName
--daje nam sve one gdje je title 'Ms.'


--5.
--prva verzija sa subquery
select Name 
from Production.ProductSubcategory
where ProductCategoryID IN 
	(SELECT ProductCategoryID
	FROM Production.ProductCategory
	where Name='Bikes')

--6.
--druga verzija sa join
select PS.Name
from Production.ProductSubcategory AS PS
INNER JOIN Production.ProductCategory AS PC
ON PC.ProductCategoryID = PS.ProductCategoryID
WHERE PC.Name = 'Bikes'


--7.
SELECT Name, Weight,
	(Select avg(weight) FROM Production.Product) AS 'Average',
	Weight - (Select avg(Weight) FROM Production.Product) AS 'Difference'
FROM Production.Product
WHERE  Weight is not null and Weight>800
order by Weight desc
--prvim subquery uzimamo prosjecnu tezinu
--drugim subquery od stvarne tezine oduzimamo prosjecnu 
--u uslov stavljamo da nije null vrijednost i da je ta tezina veca od 800
-- subquery pored sto se nalazi u from i where sekciji moze biti i u selectu kao zaseban query ondnosno kao expression (izraz)


--8.

Select * From Person.Person

SELECT LastName
FROM Person.Person
WHERE LastName = ( SELECT LastName
	FROM Person.Person
	WHERE LastName = 'Abbas')
Order by LastName



SELECT LastName
FROM Person.Person
WHERE Title = ( SELECT Title
	FROM Person.Person
	WHERE LastName = 'Abbas')
Order by LastName


--9.
SELECT SalesOrderID, CustomerID
FROM sales.SalesOrderHeader AS SOH
WHERE 10>(SELECT OrderQty
	FROM Sales.SalesOrderDetail AS SOD
	WHERE SOH.SalesOrderID = SOD.SalesOrderID
	AND SOD.ProductID=778)
--vanjski prosljedjuje vrijednost unutarnjem upitu
--ako postoji zapis iz soh u sod onda prosljedjuje gleda je li manji od 10 
--vrsti sve dok ne dodje do kraja daje sve rezultate gdje je manje od 10 i gje ima spojno mjesto ID-ova


--10.
--jednostavnije napisan query 9.

Select Name, ListPrice 
from Production.Product AS P1
--daje sve artikle i njihovu cijenu po komadu

--11
select avg(ListPrice)
from Production.Product AS P2
--prosjecna vrijednost svih ListPrice

--12.
select Name, ListPrice
from Production.Product AS P1
where 3500 <(Select AVG(ListPrice) 
			FROM Production.Product AS P2 
			where P1.ProductID = P2.ProductID)
--uzima prosjecnu vrijdnost u unutarnjem query-u 
--VALUE SE PROSJELJEDUJE U UNUTARNJI
--uzima se srednja cijena tamo gdje je id vanjsog jednak id unutarnjeg query-a