--16.03.2020.
--kreiranje baze podataka sa tabela a u okviru te baze


/*
1. Kreirati bazu podataka publikacije
*/
create database publikacije
go
use publikacije

/*
2. Uvažavajuæi DIJAGRAM uz definiranje primarnih i vanjskih kljuèeva, te veza (relationship) izmeðu tabela, kreirati sljedeæe tabele:

a) autor
	-	autor_ID		cjelobrojna vrijednost	primarni kljuè
	-	autor_ime		15 unicode karaktera	
	-	autor_prezime	20 unicode karaktera	
	-	grad_autora_ID	cjelobrojna vrijednost	
	-	spol			1 karakter	

*/

create table autor 
(
	autor_ID int constraint PK_autor primary key not null,
	--ako stavimo primary key autom. je NOT NULL kolona
	autor_ime nvarchar (15) null,
	--null ->znaci moze ostat prazno polje, ne mora bti popunjeno, ako ne napisemo null podrazumijeva se da je null
	--nvarchar ->unicode karakteri, (n-national (č,ć,š..))
	autor_prezime nvarchar (20),
	grad_autora_ID int,
	spol char (1),
	constraint FK_autor_grad foreign key (grad_autora_ID) references grad (grad_ID) --references prema cemu je FK koja tabela i koji atribut
)
--dr nacin za PK 


create table autor1 
(
	autor_ID int not null,
	autor_ime nvarchar (15) null,
	autor_prezime nvarchar (20),
	grad_autora_ID int,
	spol char (1),
	constraint PK_autor_1 primary key (autor_ID)
)
DELETE autor1
/*
b) citalac
	-	citalac_ID		cjelobrojna vrijednost	primarni kljuè
	-	citalac_ime		15 unicode karaktera	
	-	citalac_prezime	20 unicode karaktera	
	-	grad_citaoca_ID	cjelobrojna vrijednost	
	-	spol			1 karakter	
*/

create table citalac
(
	citalac_ID int not null,
	citalac_ime nvarchar (15),
	citalac_prezime nvarchar(20),
	grad_citaoca_ID int,
	spol char(1),
	constraint PK_citalac primary key (citalac_ID),
	constraint FK_citalac_grad foreign key (grad_citaoca_ID) references grad (grad_ID)
)
--prethodno prvo obrisat tabelu ako dodajemo novi constraint pa onda ponovo pokrenuti 

/*
c) forma_publikacije
	-	forma_pub_ID	cjelobrojna vrijednost	primarni kljuè
	-	forma_pub_naziv	15 unicode karaktera
	-	max_duz_zadrz	cjelobrojna vrijednost
*/

create table forma_publikacije
(
	forma_pub_ID int, 
	forma_pub_naziv nvarchar (15),
	max_duz_zadrz int, 
	constraint PK_forma_publikacije primary key (forma_pub_ID)
)


/*
d) grad
	-	grad_ID			cjelobrojna vrijednost	primarni kljuè
	-	naziv_grada		15 unicode karaktera
*/

create table grad
(
	grad_ID int,
	naziv_grada nvarchar (15),
	constraint PK_grad primary key (grad_ID)
)




/*
e) iznajmljivanje
	-	pub_ID			cjelobrojna vrijednost	primarni kljuè
	-	citalac_ID		15 unicode karaktera	primarni kljuè , int zapravo treba biti 
	-	dtm_podizanja	datumska vrijednost		primarni kljuè
	-	dtm_vracanja	datumska vrijednost
	-	br_dana_zadr	cjelobrojna vrijednost
*/


create table iznajmljivanje 
(
	pub_ID int, 
	citalac_ID int, 
	dtm_podizanja date, 
	dtm_vracanja date,
	br_dana_zadr int,

	constraint PK_iznajmljivanje primary key (pub_ID, citalac_ID, dtm_podizanja),
	constraint FK_iznajmljivanje_publikacija foreign key (pub_ID) references publikacija(pub_ID),
	constraint FK_iznajmljivanje_citalac foreign key (citalac_ID) references citalac(citalac_ID),
)


/*
f) izdavac
	-	izdavac_ID			cjelobrojna vrijednost	primarni kljuè
	-	grad_izdavaca_ID	cjelobrojna vrijednost
	-	naziv_izdavaca		15 unicode karaktera
*/


create table izdavac 
(
	izdavac_ID int,
	grad_izdavaca_ID int, 
	naziv_izdavaca nvarchar (15),
	constraint PK_izdavac primary key (izdavac_ID),
	constraint FK_izdavac_grad foreign key (grad_izdavaca_ID) references grad (grad_ID)
)


/*

g) autor_pub
	-	pub_ID			cjelobrojna vrijednost		primarni kljuè
	-	autor_ID		cjelobrojna vrijednost		primarni kljuè
*/

create table autor_pub
(
	pub_ID int, 
	autor_ID int,


	constraint PK_autor_pub primary key (pub_ID, autor_ID),
	constraint FK_autor_pub_publikacija foreign key (pub_ID) references publikacija(pub_ID),
	constraint FK_autor_pub_autor foreign key (autor_ID) references autor(autor_ID),
)
--pk stavimo oba zajedno u jedan constraint 
--i onda posebno FK prema određenim kolonama


/*

h) publikacija
	-	pub_ID			cjelobrojna vrijednost		primarni kljuè
	-	naziv_pub		15 unicode karaktera	
	-	vrsta_pub_ID	cjelobrojna vrijednost	
	-	izdavac_ID		cjelobrojna vrijednost	
	-	zanr_ID			cjelobrojna vrijednost	
	-	cijena			decimalna vrijednost oblika 5 - 2	
	-	ISBN			13 unicode karaktera	
*/

create table publikacija
(
	pub_ID int, 
	naziv_pub nvarchar (15),
	vrsta_pub_ID int,
	izdavac_ID int, 
	zanr_ID int, 
	cijena decimal (5,2),
	ISBN nvarchar (13),
	constraint PK_publikacija primary key (pub_ID),
	constraint FK_publikacija_forma_pub foreign key (vrsta_pub_ID) references forma_publikacije(forma_pub_ID),
	constraint FK_publikacija_izdavac foreign key (izdavac_ID) references izdavac(izdavac_ID),
	constraint FK_publikacija_zanr foreign key (zanr_ID) references zanr(zanr_ID)
)


/*

i) zanr
	-	zanr_ID			cjelobrojna vrijednost		primarni kljuè
	-	zanr_naziv		15 unicode karaktera
*/

create table zanr 
(
	zanr_ID int,
	zanr_naziv nvarchar(15),
	constraint PK_zanr primary key (zanr_ID)
)



alter authorization on database :: publikacije to sa
--ako ne ide kreiranje dijagrama ovaj kod treba

alter table  [dbo].[izdavac]
drop constraint [FK_izdavac_grad]

alter table [dbo].[autor]
drop constraint[FK_autor_grad]

alter table [dbo].[citalac]
drop constraint[FK_citalac_grad]

--ona tabele na koju se referenciraju neke druge tabele se ne moze brsiati dok mi ne obrisemo te reference unutar drugih tabela na ovaj nacin alter teble 