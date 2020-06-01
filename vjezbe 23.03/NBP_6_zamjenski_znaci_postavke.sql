/*
ZAMJENSKI ZNAKOVI
% 		- mijenja bilo koji broj znakova (tj. % se odnosi na to da on zamjenjuje bilo koji znak i kolko god ih ima)
_ 		- mijenja taèno jedan znak (tacno jedan znak mijenja tj. koristimo ako se trazi ono da pocinje nekim slovom pa je drugo bilo koje eh tu stavimo _)

ne koristimo iskljucivo kod stringova i testualnih dijelova nego i u svakoj situaciji kada trebamo izdvojiti dio stringa 

PRETRAŽIVANJE

[ListaZnakova]	-	pretražuje po bilo kojem znaku iz navedene liste pri èemu
					rezultat SADRŽI bilo koji od navedenih znakova
[^ListaZnakova]	-	pretražuje po bilo kojem znaku koji je naveden u listi pri èemu
					rezultat NE SADRŽI bilo koji od navedenih znakova (znakovi koji se odbacuju/ne sadrzi taj znak)
[A-C]			-	pretražuje po svim znakovima u intervalu izmeðu navedenih 
					ukljuèujuæi i navedene znakove, pri èemu rezultat SADRŽI navedene znakove
[^A-C]			-	pretražuje po svim znakovima u intervalu izmeðu navedenih 
					ukljuèujuæi i navedene znakove, pri èemu rezultat NE SADRŽI navedene znakove
*/

use NORTHWND
/*
U bazi Northwind iz tabele Customers prikazati ime kompanije kupca i kontakt telefon i to samo onih koji u svome imenu posjeduju rijeè „Restaurant“. Ukoliko naziv kompanije sadrži karakter (-), kupce izbaciti iz rezultata upita.*/
select CompanyName, Phone
from Customers
--where CompanyName like '%Restaurant%' and CompanyName not like '%-%'
where CompanyName like '%Restaurant%' and CompanyName like '%[^-]%'


/*
U bazi Northwind iz tabele Products prikazati proizvode èiji naziv poèinje slovima „C“ ili „G“, drugo slovo može biti bilo koje, a treæe slovo u nazivu je „A“ ili „O“. */
select ProductName 
from Products
where ProductName like '[CG]_[AO]%'
--sa uglastim zagradama omugucavamo da izvrsimo skracivanje pisanja koda CG znaci da se na pocetku nalazi ili C ili G / A ili O


/*
U bazi Northwind iz tabele Products prikazati listu proizvoda èiji naziv poèinje slovima „L“ ili  „T“ ili je ID proizvoda = 46.
 Lista treba da sadrži samo one proizvode èija se cijena po komadu kreæe izmeðu 10 i 50. Upit napisati na dva naèina.*/
select ProductName 
from Products
where (ProductName like '[LT]%' or ProductID = 46) and UnitPrice between 10 and 50


/*
U bazi Northwind iz tabele Suppliers prikazati ime isporuèitelja, državu i fax pri èemu isporuèitelji dolaze iz Španije ili Njemaèke, 
a nemaju unešen (nedostaje) broj faksa. Formatirati izlaz polja fax u obliku 'N/A' ukoliko nije unijeta vrijednost u polje FAX.*/
select  CompanyName, Country, ISNULL (Fax, 'N/A') as fax
from Suppliers
--where Country in ('Germany', 'Spain') and Fax is null
where (Country like 'Germany' or Country like 'Spain') and Fax is null



/*
Iz tabele Poslodavac dati pregled kolona PoslodavacID i Naziv pri èemu naziv poslodavca poèinje slovom B. 
*/
use prihodi
go

select PoslodavacID, Naziv
from Poslodavac
where Naziv like '[B]%'


/*
Iz tabele Poslodavac dati pregled kolona PoslodvacID i Naziv pri èemu naziv poslodavca poèinje slovom B, 
drugo može biti bilo koje slovo, treæe je b i ostatak naziva mogu èiniti sva slova.
*/
select PoslodavacID, Naziv
from Poslodavac
where Naziv like 'B_b%'

/*
Iz tabele Država dati pregled kolone Drzava pri èemu naziv države završava slovom a. Rezultat sortirati u rastuæem redoslijedu.
*/
select Drzava
from Drzava
where Drzava like '%a'

/*
Iz tabele Osoba dati pregled svih osoba kojima i ime i prezime poèinju slovom a. Dati prikaz OsobaID, Prezime i Ime. 
Rezultat sortirati po prezimenu i imenu u rastuæem redoslijedu.
*/
select OsobaID, PrezIme, Ime 
from Osoba
where PrezIme like 'A%' and Ime like 'A%'
--moze i sa uglastim a i ne mora

/*
Iz tabele Poslodavac dati pregled svih poslodavaca u èijem nazivu se na kraju ne nalaze slova m i e. Dati prikaz PoslodavcID i Naziv.
*/

select PoslodavacID, Naziv
from Poslodavac
where Naziv like '%[^me]'

/*
Iz tabele Osoba dati pregled svih osoba kojima se prezime završava suglasnikom. Dati prikaz OsobaID, Prezime i Ime. 
Rezultat sortirati po prezimenu u opadajuæem redoslijedu.
*/

select OsobaID, PrezIme, Ime 
from Osoba
where PrezIme like '%[^aeiou]'

/*
Iz tabele Osoba dati pregled svih osoba kojima ime poèinje bilo kojim od prvih 10 slova engleskog alfabeta. Dati prikaz OsobaID, Prezime i Ime. 
Rezultat sortirati po prezimenu u opadajuæem redoslijedu.
*/
select OsobaID, PrezIme, Ime
from Osoba
where Ime like '[A-J]%'


/*
Iz tabele Osoba dati pregled kolona OsobaID, Prezime, Ime i Adresa uz uslov da se prikažu samo oni zapisi koji poèinju bilo kojom cifrom u intervalu 1-9 kod adrese.
*/
select OsobaID, PrezIme, Ime, Adresa
from  Osoba
where Adresa like '[1-9]%'


/*
Iz tabele Osoba dati pregled kolona OsobaID, Prezime, Ime i Adresa uz uslov da se prikažu samo oni zapisi koji ne poèinju bilo kojom cifrom u intervalu 1-9.
*/
select OsobaID, PrezIme, Ime, Adresa
from  Osoba
where Adresa like '[^1-9]%'