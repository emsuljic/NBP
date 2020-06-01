USE master
GO

--ako želim odrediti posebnu lokaciju za data i log
create database Prodaja
ON
(Name=Prodaja_dat, FILENAME = 'C:\Data\Prodaja.mdf', SIZE =100MB, MAXSIZE=500MB, FILEGROWTH=20%)
LOG ON 
(Name=Prodaja_log, FILENAME = 'E:\log\Prodaja.ldf', SIZE =20MB, MAXSIZE=UNLIMITED, FILEGROWTH=10%)

DROP DATABASE Prodaja

CREATE DATABASE Prodaja

select cast(SYSDATETIME()AS nvarchar(30));
--pretvaramo datum koji je datetime u nvarchar

select convert(varchar(8), SYSDATETIME(), 112)
--konvertuje sysdatetime u varchar 8 po kodnoj stranici 112

select convert (char(8), 0x4E616d65, 0)
AS 'Stil 0,binarni u tekstualni'
--binarni zapis prebacujemo u tekstualni
--stil 0 je definisan u tabeli stilova sql servera, moze se u dokumnetaciji mijenjati, pogledati

select parse('Monday, 13 December 2010' AS datetime USING 'en-US')
--parsiranje treba da bude kompaktibilno sa onim u sto parsiramo


USE Prodaja

create type BrojProizvoda
from nvarchar(20) not null;

create table Kupci
( KupacID int identity(1,1),
Prezime nvarchar (30) not null,
Ime nvarchar (30) not null,
Telefon nvarchar (30) null
)
--nema PK jos uvijek u ovoj tabeli

ALTER TABLE Kupci 
ADD Email nvarchar(100)not null;
go

alter table Kupci
drop column Telefon;
go
--brisanjem kolone brisemo i sve podatke te kolone

Drop table Kupci


--tabela koja postoji samo dok traje ova sesija ili dok se ne resetuje sql
create table #Squares
(	NumberID int primary key,
	NumberSquared int
);
go

create table Kupci 
(
KupacID int identity(1,1) primary key,
Prezime nvarchar (30) not null,
Ime nvarchar (30) not null,
Telefon nvarchar (30) null,
DatumRodjenja date not null,
GodinaRodjenja as datepart(year, DatumRodjenja) persisted
);
--persisted->da se pohrani u tabelu ta godina rodjenja
--da se ne bi svaki put pokretalo

drop table Kupci

create table Kupci 
(
KupacID int identity(1,1) constraint PK_Kupci primary key,
Prezime nvarchar (30) not null,
Ime nvarchar (30) not null,
Telefon nvarchar (30) null,
DatumRodjenja date not null,
GodinaRodjenja as datepart(year, DatumRodjenja) persisted
);
--primarni kljuc ne znaci constraint po defaultu da je odma i ogranicenje 
--samo kad dodamo constraint onda je i ogranicenje


create table Kupci 
(
KupacID int identity(1,1) constraint PK_Kupci primary key,
Prezime nvarchar (30) not null,
Ime nvarchar (30) not null,
Telefon nvarchar (30) null,
Email nvarchar(100) not null constraint UQ_Email UNIQUE, 
--unique ne dozvoljava da se unese dupla email adresa, da se korisnik registruje 2x
--unique ima definiciju kljuca 
DatumRodjenja date not null,
GodinaRodjenja as datepart(year, DatumRodjenja) persisted
);


create table Gradovi
(
GradID int identity(1,1) constraint PK_Grad primary key,
Naziv nvarchar (100)
)



create table Kupci 
(
KupacID int identity(1,1) constraint PK_Kupci primary key,
Prezime nvarchar (30) not null,
Ime nvarchar (30) not null,
Telefon nvarchar (30) null,
Email nvarchar(100) not null constraint UQ_Email UNIQUE, 
--unique ne dozvoljava da se unese dupla email adresa, da se korisnik registruje 2x
--unique ima definiciju kljuca 
DatumRodjenja date not null,
GradID int not null constraint FK_Kupci_Gradovi foreign key references Gradovi (GradID),
GodinaRodjenja as datepart(year, DatumRodjenja) persisted
);