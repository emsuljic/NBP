/*
ZAMJENSKI ZNAKOVI
% 		- mijenja bilo koji broj znakova (tj. % se odnosi na to da on zamjenjuje bilo koji znak i kolko god ih ima)
_ 		- mijenja ta�no jedan znak (tacno jedan znak mijenja tj. koristimo ako se trazi ono da pocinje nekim slovom pa je drugo bilo koje eh tu stavimo _)

ne koristimo iskljucivo kod stringova i testualnih dijelova nego i u svakoj situaciji kada trebamo izdvojiti dio stringa 

PRETRA�IVANJE

[ListaZnakova]	-	pretra�uje po bilo kojem znaku iz navedene liste pri �emu
					rezultat SADR�I bilo koji od navedenih znakova
[^ListaZnakova]	-	pretra�uje po bilo kojem znaku koji je naveden u listi pri �emu
					rezultat NE SADR�I bilo koji od navedenih znakova (znakovi koji se odbacuju/ne sadrzi taj znak)
[A-C]			-	pretra�uje po svim znakovima u intervalu izme�u navedenih 
					uklju�uju�i i navedene znakove, pri �emu rezultat SADR�I navedene znakove
[^A-C]			-	pretra�uje po svim znakovima u intervalu izme�u navedenih 
					uklju�uju�i i navedene znakove, pri �emu rezultat NE SADR�I navedene znakove
*/

use NORTHWND
/*
U bazi Northwind iz tabele Customers prikazati ime kompanije kupca i kontakt telefon i to samo onih koji u svome imenu posjeduju rije� �Restaurant�. Ukoliko naziv kompanije sadr�i karakter (-), kupce izbaciti iz rezultata upita.*/
select CompanyName, Phone
from Customers
--where CompanyName like '%Restaurant%' and CompanyName not like '%-%'
where CompanyName like '%Restaurant%' and CompanyName like '%[^-]%'


/*
U bazi Northwind iz tabele Products prikazati proizvode �iji naziv po�inje slovima �C� ili �G�, drugo slovo mo�e biti bilo koje, a tre�e slovo u nazivu je �A� ili �O�. */
select ProductName 
from Products
where ProductName like '[CG]_[AO]%'
--sa uglastim zagradama omugucavamo da izvrsimo skracivanje pisanja koda CG znaci da se na pocetku nalazi ili C ili G / A ili O


/*
U bazi Northwind iz tabele Products prikazati listu proizvoda �iji naziv po�inje slovima �L� ili  �T� ili je ID proizvoda = 46.
 Lista treba da sadr�i samo one proizvode �ija se cijena po komadu kre�e izme�u 10 i 50. Upit napisati na dva na�ina.*/
select ProductName 
from Products
where (ProductName like '[LT]%' or ProductID = 46) and UnitPrice between 10 and 50


/*
U bazi Northwind iz tabele Suppliers prikazati ime isporu�itelja, dr�avu i fax pri �emu isporu�itelji dolaze iz �panije ili Njema�ke, 
a nemaju une�en (nedostaje) broj faksa. Formatirati izlaz polja fax u obliku 'N/A' ukoliko nije unijeta vrijednost u polje FAX.*/
select  CompanyName, Country, ISNULL (Fax, 'N/A') as fax
from Suppliers
--where Country in ('Germany', 'Spain') and Fax is null
where (Country like 'Germany' or Country like 'Spain') and Fax is null



/*
Iz tabele Poslodavac dati pregled kolona PoslodavacID i Naziv pri �emu naziv poslodavca po�inje slovom B. 
*/
use prihodi
go

select PoslodavacID, Naziv
from Poslodavac
where Naziv like '[B]%'


/*
Iz tabele Poslodavac dati pregled kolona PoslodvacID i Naziv pri �emu naziv poslodavca po�inje slovom B, 
drugo mo�e biti bilo koje slovo, tre�e je b i ostatak naziva mogu �initi sva slova.
*/
select PoslodavacID, Naziv
from Poslodavac
where Naziv like 'B_b%'

/*
Iz tabele Dr�ava dati pregled kolone Drzava pri �emu naziv dr�ave zavr�ava slovom a. Rezultat sortirati u rastu�em redoslijedu.
*/
select Drzava
from Drzava
where Drzava like '%a'

/*
Iz tabele Osoba dati pregled svih osoba kojima i ime i prezime po�inju slovom a. Dati prikaz OsobaID, Prezime i Ime. 
Rezultat sortirati po prezimenu i imenu u rastu�em redoslijedu.
*/
select OsobaID, PrezIme, Ime 
from Osoba
where PrezIme like 'A%' and Ime like 'A%'
--moze i sa uglastim a i ne mora

/*
Iz tabele Poslodavac dati pregled svih poslodavaca u �ijem nazivu se na kraju ne nalaze slova m i e. Dati prikaz PoslodavcID i Naziv.
*/

select PoslodavacID, Naziv
from Poslodavac
where Naziv like '%[^me]'

/*
Iz tabele Osoba dati pregled svih osoba kojima se prezime zavr�ava suglasnikom. Dati prikaz OsobaID, Prezime i Ime. 
Rezultat sortirati po prezimenu u opadaju�em redoslijedu.
*/

select OsobaID, PrezIme, Ime 
from Osoba
where PrezIme like '%[^aeiou]'

/*
Iz tabele Osoba dati pregled svih osoba kojima ime po�inje bilo kojim od prvih 10 slova engleskog alfabeta. Dati prikaz OsobaID, Prezime i Ime. 
Rezultat sortirati po prezimenu u opadaju�em redoslijedu.
*/
select OsobaID, PrezIme, Ime
from Osoba
where Ime like '[A-J]%'


/*
Iz tabele Osoba dati pregled kolona OsobaID, Prezime, Ime i Adresa uz uslov da se prika�u samo oni zapisi koji po�inju bilo kojom cifrom u intervalu 1-9 kod adrese.
*/
select OsobaID, PrezIme, Ime, Adresa
from  Osoba
where Adresa like '[1-9]%'


/*
Iz tabele Osoba dati pregled kolona OsobaID, Prezime, Ime i Adresa uz uslov da se prika�u samo oni zapisi koji ne po�inju bilo kojom cifrom u intervalu 1-9.
*/
select OsobaID, PrezIme, Ime, Adresa
from  Osoba
where Adresa like '[^1-9]%'