create database Test
use Test

create table Book
(
ISBN nvarchar (20),
PublisherID int not null,
Title nvarchar (50) not null,
ReleaseDate date not null
);

create table Book
(
ISBN nvarchar (20) primary key,
PublisherID int not null,
Title nvarchar (50) not null,
ReleaseDate date not null
);
--tabela koja ima primarni kljuc automatski se on indeksira


create nonclustered index IX_Book_Publisher
ON Book (PublisherID, ReleaseDate desc)

create nonclustered index IX_Book_Publisher
ON Book (PublisherID, ReleaseDate desc)
Include (Title);



select PublisherID, Title, ReleaseDate
from Book
where ReleaseDate > DATEADD(YEAR, -1, SYSDATETIME())
order by PublisherID, ReleaseDate desc;


ALTER INDEX IX_Book_Publisher ON Book 
disable

ALTER INDEX IX_Book_Publisher ON Book 
rebuild

DROP INDEX IX_Book_Publisher ON Book 


use AdventureWorks2014

create nonclustered index Contact_LastName_FirstName 
ON Person.Person (LastName asc, FirstName asc)

create nonclustered index Employee_LoginID 
ON HumanResources.Employee (LoginID asc)
include (BusinessEntityID, NationalIDNumber)


select * from sys.dm_db_index_physical_stats(NULL, NULL, NULL, NULL, NULL)
order by avg_fragmentation_in_percent desc

.
.
.

