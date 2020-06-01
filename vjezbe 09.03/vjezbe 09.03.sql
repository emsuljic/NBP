use AdventureWorks2014

-- zadatak11
select p.PurchaseOrderID, p.OrderQty, p.UnitPrice, p.RejectedQty
from Purchasing.PurchaseOrderDetail AS p
where OrderQty>10 OR (UnitPrice<1000 and RejectedQty>10)

--zadatak12
select BusinessEntityID, NationalIDNumber, OrganizationNode, OrganizationLevel, JobTitle
from HumanResources.Employee 
where JobTitle like '%man%' and OrganizationLevel<3
--voditi racuna o ovom skracivanju manager na man 

--zadatak12b
select BusinessEntityID, NationalIDNumber, OrganizationNode, OrganizationLevel, JobTitle
from HumanResources.Employee 
where JobTitle like 'acc%' or JobTitle like 'fi%'

--zadatak 13a
create schema vjezbe --kreiramo šemu vjezbe
--mogu biti 2 u potpunosti iste tabele pod dvije scheme
create table vjezbe.zadruga --nazivScheme.nazivTabele
(
	KupovinaID int NOT NULL, --nazivi kolona, tipovi podataka, 
	--NOT NULL deklariramo da li je u tu kolonu obavezan ili nijeobavezan unos 
	--obavezan unos NOT NULL
	--NULL
	--ostaviti prazno
	BrKom int NOT NULL,
	JedCijena decimal (8,2) NOT NULL, -- (8,2) 8 mjeste, 2 mjesta za decimale
	Ukupno AS (BrKom * JedCijena) --computed kolona
)

--mi kreiramo tabelu
create table proizvod
(
	proizvodID int NOT NULL,
	jed_cijena decimal(8,2),
	stanje_na_skladistu int,
	stanje_zaliha AS (jed_cijena*stanje_na_skladistu) 
)

--umetanje vrijednosti u kolone

INSERT vjezbe.zadruga (KupovinaID, BrKom, JedCijena) VALUES (1, 2, 5.2)

INSERT vjezbe.zadruga (KupovinaID, BrKom, JedCijena) VALUES (2, 4, 0.55)
--insert / tabela / (kolone u koje vrsimo insert podatke) / values (navodimo vrijednosti, vodimo racuna o tipu podatka int decimalni...)
--morali smo unijeti vrijednost tamo gdje nam je NOT NULL, jer bi doslo do greske

--kolonu ukupno iz ove tabele ne stavljamo u insert i ne dajemo neku vrijednost jer je ukupno calculeted 
--tako i za bilo koju drugu kolonu koja je izracunata dakle ne mozemo joj davati vrijednosti
--izracunatu i onu koja je pod identitiy ne navodimo u INSERT izrazu

select*
from vjezbe.zadruga


--  vjezbe 16.03.2020. nastavlja se

--update tabele moze bit sa uslovom ili bez ikakvog uslova

UPDATE vjezbe.zadruga
SET JedCijena =3.9
where KupovinaID=1
--u SET postavljamo naziv kolone i njenu novu vrijednost 

UPDATE vjezbe.zadruga
SET BrKom=3
where KupovinaID=2

DELETE vjezbe.zadruga
where KupovinaID =1 