/*
1. Kreirati bazu podataka radna.
PRIMJER ISPITNIH ZADATAKA
*/
create database radna
use radna

/*2. Vodeæi raèuna o strukturi tabela kreirati odgovarajuæe veze (vanjske kljuèeve) 
nema navedenih vanjskih kljuceva, a negdje ni primarni (MI MORAMO ZAKLJUCITI SAMI)

a) Kreirati tabelu autor koja æe se sastojati od sljedeæih polja:
	au_id		varchar(11)	primarni kljuè
	au_lname	varchar(40)	
	au_fname	varchar(20)	
	phone		char(15)	
	address		varchar(40)	obavezan unos
	city		varchar(20)	obavezan unos
	state		char(2)	obavezan unos
	zip			char(5)	obavezan unos
	contract	bit	
*/

create table autor 
(
	au_id		varchar(11) ,
	au_lname	varchar(40),
	au_fname	varchar(20),	
	phone		char(15),	
	address 	varchar(40) ,	
	city		varchar(20) ,	
	state		char(2) ,	
	zip			char(5) ,	
	contract	bit
	constraint PK_autor primary key (au_id)
)

/*
b) Kreirati tabelu naslov koja æe se sastojati od sljedeæih polja:
	title_id	varchar(6), primarni kljuè
	title		varchar(80)	
	type		char(12)	
	pub_id		char(4)	obavezan unos
	price		money	obavezan unos
	advance		money	obavezan unos
	royalty		int	obavezan unos
	ytd_sales	int	obavezan unos
	notes		varchar(200)	obavezan unos
	pubdate		datetime	
		
*/
create table naslov
(
	title_id	varchar(6) , 
	title		varchar(80),
	type		char(12),	
	pub_id		char(4) ,
	price		money ,
	advance		money ,
	royalty		int	,
	ytd_sales	int	,
	notes		varchar(200) ,	
	pubdate		datetime,
	constraint PK_naslov primary key (title_id)
)

/*
c) Kreirati tabelu naslov_autor koja æe se sastojati od sljedeæih polja:
	au_id		varchar(11)	
	title_id	varchar(6)	
	au_ord		tinyint	obavezan unos
	royaltyper	int	obavezan unos
*/
create table naslov_autor 
(
	au_id		varchar(11),
	title_id	varchar(6),	
	au_ord		tinyint	,
	royaltyper	int	,
	constraint PK_naslov_autor primary key (au_id, title_id),
	constraint FK_naslov_autor_autor foreign key (au_id) references autor (au_id),
	constraint FK_naslov_autor_naslov foreign key (title_id) references naslov (title_id)
)

/*
3. Insert (import) podataka.
	a) u tabelu autori podatke iz tabele authors baze pubs, ali tako da se u koloni phone tabele autor prve 3 cifre smjeste u zagradu.
	b) u tabelu naslovi podatke iz tabele titles baze pubs, ali tako da se izvrši zaokruživanje vrijednosti (podaci ne smiju imati decimalne vrijednosti) 
	u koloni price
	c) u tabelu naslov_autor podatke iz tabele titleauthor baze pubs, pri èemu æe se u koloni au_ord vrijednosti iz tabele titleauthor zamijeniti na sljedeæi naèin:
	1 -> 101
	2 -> 102
	3 -> 103

	TABELU KOJA JE SPOJNA POSLJEDNJU POPUNJAVAMO BEZ OBZIRA NA REDOSLIJED ZADATAKA KOJI ZADAN 
*/

--a)
insert into autor 
select   au_id, au_lname, au_fname ,'(' + left(phone, 3) + ')' + substring(phone, 4, 9),	address, city, state, zip, contract	
from pubs.dbo.authors
--naziv baze.naziv sheme.naziv tabele ovo navodimo zato sto smo trenutno u bazi radna a povlacimo podatke iz baze pubs 
--kada povlacimo podatke iz druge baze moramo navesti koja je to baza 
--'(' + left(phone, 3) + ')' + substring(phone, 4, 9) da dodamo zagrade na prva tri broja i ostatak prepise pomocu substring 
--prebacili smo ovim upitom 23 zapisa u nasu tabelu autor iz tabele authors(pubs)
select SUBSTRING (phone, 5, 8)
from pubs.dbo.authors

--b)
insert into naslov
select title_id, title, type, pub_id, round(price, 0), advance, royalty, ytd_sales, notes, pubdate
from pubs.dbo.titles
--zaokruzivanje, pri cemu ta zaokruzena vrijednost nece imati niti jedno decimalno mjesto 

select * from naslov -- ovdje nema decimalne vrijednosti (20.00) vako je zbog tipa podatka 
select * from pubs.dbo.titles --ovdje vidimo da ima decimalne


--c)
insert into naslov_autor
select au_id, title_id, 100 + au_ord, royaltyper
from pubs.dbo.titleauthor

select *from naslov_autor
/*
4. Izvršiti update podataka u koloni contract tabele autor po sljedeæem pravilu:
	0 -> ostaviti prazno
	1 -> DA
*/

alter table autor
alter column contract char(2) 
--sa alter promijenimo ovako tip podatka u odredjenom koloni 

update autor
set contract = 'DA'
where contract='1'
--nece moci ovako bez alter table jer nije isti tip podatka
--set 
update autor
set contract = 'NE'
where contract='0' --sada mora apostrofe ovdje staviti jer smo promijenili tip podatka
select * from autor
/*



5. Kopirati tabelu sales iz baze pubs u tabelu prodaja u bazi radna.
*/

select * -- kopira sve 
into radna.dbo.prodaja -- ide u bazu radna 
from pubs.dbo.sales -- ide iz ove baze

/*
6. Kopirati tabelu autor u tabelu autor1, izbrisati sve podatke, a nakon toga u tabelu autor1 importovati podatke iz 
tabele autor uz uslov da ID autora zapoèinje brojevima 1, 2 ili 3 i da autor ima zakljuèen ugovor (contract).
*/
use radna 
go

--kopiranjem vrsimo kopiranje i strukture i svih podataka iz te tabele (podrazumijeva kolone polja a ne PK I FK)
--ako radimo kopiranje prvi ide select
--ako radimo prenos podataka prvi ide insert pa select

select *
into autor_1
from autor

delete autor_1

insert into autor_1
select *
from autor
where au_id like '[123]%' and contract = 1


/* 
7. U tabelu autor1 importovati podatke iz tabele autor uz uslov da adresa poèinje cifrom 3, a na treæem mjestu se nalazi cifra 1.
*/



/*
8. Kopirati tabelu naslov u tabelu naslov1, izbrisati sve podatke, a nakon toga u tabelu naslov1 importovati podatke iz tabele naslov na naèin da se cijena (price) koriguje na sljedeæi naèin:
	- naslov èija je cijena veæa ili jednaka 15 KM cijenu smanjiti za 20% (podaci trebaju biti zaokruženi na 2 decimale)
	- naslov èija je cijena manja od 15 KM cijenu smanjiti za 15% (podaci trebaju biti zaokruženi na 2 decimale)
*/


/*
9. Kopirati tabelu naslov_autor u tabelu naslov_autor1, a nakon toga u tabelu naslov_autor1 dodati novu kolonu isbn.
*/

select *
into naslov_autor1
from naslov_autor;

alter table naslov_autor1
add isbn varchar(10);

--dodavanje izracunate kolone (dodatno uradjeno)
alter table naslov_autor1
add kolona as left (title_id, 2)

select* from naslov_autor1

/*
10. Kolonu isbn popuniti na naèin da se iz au_id preuzmu prve 3 cifre i srednja crta, te se na to dodaju posljednje 4 cifre iz title_id.
*/

update naslov_autor1
set isbn = LEFT (au_id, 4) + RIGHT (title_id, 4)

/*
11. U tabelu autor1 dodati kolonu sifra koja æe se popunjavati sluèajno generisanim nizom znakova, pri èemu je broj znakova ogranièen na 15.
*/
--random generisani znakovi select newid() on se sastoji od ukupno 36 znakova
							select newid() 


alter table autor_1
add sifra as left (newid(),15)

select * from autor_1




/*
12. Tabelu Order Details iz baze Northwind kopirati u tabelu detalji_narudzbe.
*/

/*
13. U tabelu detalji_narudzbe dodati izraèunate kolone cijena_s_popustom i ukupno. cijena_s_popustom æe se raèunati pomoæu kolona UnitPrice i Discount, a ukupno pomoæu kolona Quantity i cijena_s_popustom. Obje kolone trebaju biti formirani kao numerièki tipovi sa dva decimalna mjesta.
*/

/*
14. U tabelu detalji_narudzbe izvršiti insert podataka iz tabele Order Details baze Northwind.
*/






/*
15. Kreirati tabelu uposlenik koja æe se sastojati od sljedeæih polja:
	uposlenikID	cjelobrojna vrijednost, primarni kljuè, automatsko punjenje sa inkrementom 1 i poèetnom vrijednošæu 1
	emp_id		char(9)	
	fname		varchar(20)	
	minit		char(1)	
	lname		varchar(30)	
	job_id		smallint	
	job_lvl		tinyint	
	pub_id		char(4)	
	hire_date	datetime, defaultna vrijednost je aktivni datum	
*/

/*
16. U sve kolone tabele uposlenik osim hire_date insertovati podatke iz tabele employee baze pubs.
*/


/*
17. U tabelu uposlenik dodati kolonu sifra velièine 10 unicode karaktera, a nakon toga kolonu sifra popuniti sluèajno generisanim karakterima, uz uslov d
*/

