use [MagazinSuveniruri_2.0]
go


if exists (select * from dbo.sysobjects where id = object_id(N'[FK_TestRunTables_Tables]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [TestRunTables] DROP CONSTRAINT FK_TestRunTables_Tables
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[FK_TestTables_Tables]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [TestTables] DROP CONSTRAINT FK_TestTables_Tables
GO
 
if exists (select * from dbo.sysobjects where id = object_id(N'[FK_TestRunTables_TestRuns]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [TestRunTables] DROP CONSTRAINT FK_TestRunTables_TestRuns
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[FK_TestRunViews_TestRuns]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [TestRunViews] DROP CONSTRAINT FK_TestRunViews_TestRuns
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[FK_TestTables_Tests]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [TestTables] DROP CONSTRAINT FK_TestTables_Tests
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[FK_TestViews_Tests]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [TestViews] DROP CONSTRAINT FK_TestViews_Tests
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[FK_TestRunViews_Views]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [TestRunViews] DROP CONSTRAINT FK_TestRunViews_Views
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[FK_TestViews_Views]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [TestViews] DROP CONSTRAINT FK_TestViews_Views
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[Tables]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Tables]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[TestRunTables]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [TestRunTables]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[TestRunViews]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [TestRunViews]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[TestRuns]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [TestRuns]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[TestTables]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [TestTables]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[TestViews]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [TestViews]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[Tests]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Tests]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[Views]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Views]
GO

CREATE TABLE [Tables] (
	[TableID] [int] IDENTITY (1, 1) NOT NULL ,
	[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [TestRunTables] (
	[TestRunID] [int] NOT NULL ,
	[TableID] [int] NOT NULL ,
	[StartAt] [datetime] NOT NULL ,
	[EndAt] [datetime] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [TestRunViews] (
	[TestRunID] [int] NOT NULL ,
	[ViewID] [int] NOT NULL ,
	[StartAt] [datetime] NOT NULL ,
	[EndAt] [datetime] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [TestRuns] (
	[TestRunID] [int] IDENTITY (1, 1) NOT NULL ,
	[Description] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[StartAt] [datetime] NULL ,
	[EndAt] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [TestTables] (
	[TestID] [int] NOT NULL ,
	[TableID] [int] NOT NULL ,
	[NoOfRows] [int] NOT NULL ,
	[Position] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [TestViews] (
	[TestID] [int] NOT NULL ,
	[ViewID] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [Tests] (
	[TestID] [int] IDENTITY (1, 1) NOT NULL ,
	[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [Views] (
	[ViewID] [int] IDENTITY (1, 1) NOT NULL ,
	[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [Tables] WITH NOCHECK ADD 
	CONSTRAINT [PK_Tables] PRIMARY KEY  CLUSTERED 
	(
		[TableID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [TestRunTables] WITH NOCHECK ADD 
	CONSTRAINT [PK_TestRunTables] PRIMARY KEY  CLUSTERED 
	(
		[TestRunID],
		[TableID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [TestRunViews] WITH NOCHECK ADD 
	CONSTRAINT [PK_TestRunViews] PRIMARY KEY  CLUSTERED 
	(
		[TestRunID],
		[ViewID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [TestRuns] WITH NOCHECK ADD 
	CONSTRAINT [PK_TestRuns] PRIMARY KEY  CLUSTERED 
	(
		[TestRunID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [TestTables] WITH NOCHECK ADD 
	CONSTRAINT [PK_TestTables] PRIMARY KEY  CLUSTERED 
	(
		[TestID],
		[TableID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [TestViews] WITH NOCHECK ADD 
	CONSTRAINT [PK_TestViews] PRIMARY KEY  CLUSTERED 
	(
		[TestID],
		[ViewID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [Tests] WITH NOCHECK ADD 
	CONSTRAINT [PK_Tests] PRIMARY KEY  CLUSTERED 
	(
		[TestID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [Views] WITH NOCHECK ADD 
	CONSTRAINT [PK_Views] PRIMARY KEY  CLUSTERED 
	(
		[ViewID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [TestRunTables] ADD 
	CONSTRAINT [FK_TestRunTables_Tables] FOREIGN KEY 
	(
		[TableID]
	) REFERENCES [Tables] (
		[TableID]
	) ON DELETE CASCADE  ON UPDATE CASCADE ,
	CONSTRAINT [FK_TestRunTables_TestRuns] FOREIGN KEY 
	(
		[TestRunID]
	) REFERENCES [TestRuns] (
		[TestRunID]
	) ON DELETE CASCADE  ON UPDATE CASCADE 
GO

ALTER TABLE [TestRunViews] ADD 
	CONSTRAINT [FK_TestRunViews_TestRuns] FOREIGN KEY 
	(
		[TestRunID]
	) REFERENCES [TestRuns] (
		[TestRunID]
	) ON DELETE CASCADE  ON UPDATE CASCADE ,
	CONSTRAINT [FK_TestRunViews_Views] FOREIGN KEY 
	(
		[ViewID]
	) REFERENCES [Views] (
		[ViewID]
	) ON DELETE CASCADE  ON UPDATE CASCADE 
GO

ALTER TABLE [TestTables] ADD 
	CONSTRAINT [FK_TestTables_Tables] FOREIGN KEY 
	(
		[TableID]
	) REFERENCES [Tables] (
		[TableID]
	) ON DELETE CASCADE  ON UPDATE CASCADE ,
	CONSTRAINT [FK_TestTables_Tests] FOREIGN KEY 
	(
		[TestID]
	) REFERENCES [Tests] (
		[TestID]
	) ON DELETE CASCADE  ON UPDATE CASCADE 
GO

ALTER TABLE [TestViews] ADD 
	CONSTRAINT [FK_TestViews_Tests] FOREIGN KEY 
	(
		[TestID]
	) REFERENCES [Tests] (
		[TestID]
	),
	CONSTRAINT [FK_TestViews_Views] FOREIGN KEY 
	(
		[ViewID]
	) REFERENCES [Views] (
		[ViewID]
	)
GO

--Tabele
-- O cheie primara: Tip_Magazin
-- O cheie primara si cel putin una straina: Magazin
-- Doua chei primare: Suvenir_Magazin

--Inseram numele tabelelor folosite in tabela tables
Insert into tables(name)
values ('TipMagazin'), ('Magazin'), ('Suvenir_Magazin')
go

select * from tables
go

--view ul 1 : toate tipurile de magazine care au un stoc de produse mai mare de 10000
create or alter view View1 as
	select tipul from TipMagazin where numar_produse>5000;
go

insert into TipMagazin values (12,'minimarket',5,5)
go

--view ul 2 : toate rating urile magazinelor de tip minimarket
create or alter view View2 as
	select m.mID, m.rating 
	from Magazin m inner join TipMagazin t on m.tipID = t.tmID
	where t.tipul like 'minimarket'
go

--view ul 3 : numarul de magazine pentru fiecare tip de magazin
create or alter view View3 as
	select t.tmID, t.tipul,
	count (t.tmID) as [numar magazine] 
	from TipMagazin t, Magazin m
	where t.tmID = m.tipID
	group by t.tmID, t.tipul
go

--Inseram numele view urilor create anterior
Insert into Views(name)
values ('View1'), ('View2'), ('View3')
go

select * from Tests

--Inseram numele testelor in tabela Tests
Insert into Tests(name)
values ('Delete'), ('Insert'), ('View')
go

--Inseram perechile de test-view in tabelul TestViews
insert into TestViews(TestID, ViewID) values (3,1),(3,2),(3,3);
go

--Inseram perechile de teste-tabele in tabelul TestTables
insert into TestTables(TestID, TableID,NoOfRows,Position) values
(1,1,0,3),(1,2,0,2),(1,3,0,1),(2,1,100,1),(2,2,100,2),(2,3,100,3);
go

Delete from TestTables
Select * from TestTables
go

--Sterge toate tipurile de magazin din tabela TipMagazin
create or alter procedure Delete1 AS
BEGIN 
DELETE FROM TipMagazin; 
END;
GO 

--Sterge toate perechile magazin-suvenir din tabela Suvenir_Magazin
create or alter procedure Delete2 AS
BEGIN 
DELETE FROM Suvenir_Magazin; 
END;
GO 

--Sterge toate magazinele din tabela Magazin
create or alter procedure Delete3 AS
BEGIN 
	DELETE FROM Suvenir_Magazin;
	DELETE FROM Magazin; 
END;
GO 


--Inserare de date in tabelul TipMagazin
create or alter procedure Insert1 as
Begin
	declare @numar_curent int=0;
	declare @numar_inserari int;
	set @numar_inserari = (select NoOfRows from TestTables where TestID = 2 AND Position = 1);

	declare @id int=1;
	declare @tip varchar;
	declare @numar_produse int;
	declare @index int;
	declare @medie_clienti int;
	
	while @numar_curent < @numar_inserari
		Begin
			set @numar_curent = @numar_curent + 1;
			set @id = @id + 1;
			SELECT  @index = cast(rand() * 3 + 1 as int);
			SET @tip = choose(@index,'minimarket','supermarket','hipermarket');
			set @numar_produse = floor(rand()*(1000-200+1))+200;
			set @medie_clienti = floor(rand()*(10000-2000+1))+2000;
			insert into TipMagazin (tmID, tipul, numar_produse,medie_zilnica_clienti) values (@id,@tip,@numar_produse,@medie_clienti);
		End;
End;
go

--Inserare de date in tabelul Magazin
create or alter procedure Insert2 as
Begin
	declare @numar_curent int=0;
	declare @numar_inserari int;
	set @numar_inserari = (select NoOfRows from TestTables where TestID = 2 AND Position = 2);

	declare @id int=0;
	declare @nr_angajati int;
	declare @adresa varchar(15);
	declare @rating int;
	declare @tipID int= (select top 1 tmID from TipMagazin);
	declare @patron int=43;
	declare @numar varchar;

	while @numar_curent < @numar_inserari
		Begin
			set @numar_curent = @numar_curent + 1;
			set @id = @id + 1;
			set @nr_angajati = floor(rand()*(100-20+1))+20;
			set @rating = floor(rand()*(5-1+1))+1;
			set @numar = str(floor(rand()*(100-1+1))+1)
			set @adresa = concat('Rozelor ',@numar);
			insert into Magazin (mID,nr_angajati,adresa,rating,tipID,patID) values (@id,@nr_angajati,@adresa,@rating,@tipID,@patron) 
		End;
End;
go


--Inserare de date in tabelul Magazin-Suvenir
create or alter procedure Insert3 as
Begin
	declare @numar_curent int=0;
	declare @numar_inserari int;
	set @numar_inserari = (select NoOfRows from TestTables where TestID = 2 AND Position = 3);

	declare @idMagazin int;
	declare @idSuvenir int;
	set @idSuvenir = (select top 1 suvID from Suvenir)
	declare @id int=1;

	while @numar_curent < @numar_inserari
		Begin
			set @idMagazin = (select mID from Magazin where mID=@id);
			set @id = @id + 1;
			insert into Suvenir_Magazin(mID,suvID) values (@idMagazin,@idSuvenir);
			set @numar_curent = @numar_curent + 1 ;
		End;

End;
go

--Procedurea pentru selectarea view ului 1
create or alter procedure Select_View1 as
select * from View1
go

----Procedurea pentru selectarea view ului 2
create or alter procedure Select_View2 as
select * from View2
go

--Procedurea pentru selectarea view ului 3
create or alter procedure Select_View3 as
select * from View3
go

--Procedura pentru testul1 dintre tabelul 1 si view ul 1
create or alter procedure Test1 as
Begin
	declare @ds datetime; 
	declare @di datetime; 
	declare @df datetime; 
	SET @ds = getdate();
	exec Delete1;
	exec Insert1;
	set @di = getdate();
	exec Select_View1;
	set @df = getdate();
	insert into TestRuns(Description,StartAt,EndAt) values ('Procedura pentru testul1 dintre tabelul 1 si view ul 1',@ds,@df);
	declare @testRunID int = (select top 1 TestRunID from TestRuns order by TestRunID desc);
	insert into TestRunTables(TestRunID, TableID, StartAt, EndAt) values (@testRunID, 1, @ds, @di);
	insert into TestRunViews(TestRunID,ViewID,StartAt,EndAt) values (@testRunID, 1, @di, @df);
End;
go

--procedura pentru testul 2 dintre tabelul 2 si view ul 2
create or alter procedure Test2 as
Begin
	declare @ds datetime; 
	declare @di datetime; 
	declare @df datetime; 
	SET @ds = getdate();
	exec Delete3;
	exec Insert2;
	set @di = getdate();
	exec Select_View2;
	set @df = getdate();
	insert into TestRuns(Description,StartAt,EndAt) values ('procedura pentru testul 2 dintre tabelul 2 si view ul 2',@ds,@df);
	declare @testRunID int = (select top 1 TestRunID from TestRuns order by TestRunID desc);
	insert into TestRunTables(TestRunID, TableID, StartAt, EndAt) values (@testRunID, 2, @ds, @di);
	insert into TestRunViews(TestRunID,ViewID,StartAt,EndAt) values (@testRunID, 2, @di, @df);
End;
go

--procedura pentru testul 3 dintre tabelul 3 si view ul 3
create or alter procedure Test3 as
Begin
	declare @ds datetime; 
	declare @di datetime; 
	declare @df datetime; 
	SET @ds = getdate();
	exec Delete2;
	exec Insert3;
	set @di = getdate();
	exec Select_View3;
	set @df = getdate();
	insert into TestRuns(Description,StartAt,EndAt) values ('procedura pentru testul 3 dintre tabelul 3 si view ul 3',@ds,@df);
	declare @testRunID int = (select top 1 TestRunID from TestRuns order by TestRunID desc);
	insert into TestRunTables(TestRunID, TableID, StartAt, EndAt) values (@testRunID, 2, @ds, @di);
	insert into TestRunViews(TestRunID,ViewID,StartAt,EndAt) values (@testRunID, 2, @di, @df);
End;
go

--Golim tabelele in care se stocheaza date despre testele efectuate pe tabele
delete from TestRuns;
delete from TestRunTables;
delete from TestRunViews;
delete from TipMagazin;
delete from Magazin;
delete from Suvenir_Magazin;

--Executam testele legate de tabela 1 si viewul 1
EXEC test1; 
select * from TipMagazin
select * from TestRuns;
select * from TestRunTables;
select * from TestRunViews;

--Executam testele legate de tabela 2 si viewul 2
EXEC test2; 
select * from Magazin;
select * from TestRuns;
select * from TestRunTables;
select * from TestRunViews;

--Executam testele legate de tabela 3 si viewul 3
EXEC test3;
select * from Suvenir_Magazin;
select * from TestRuns;
select * from TestRunTables;
select * from TestRunViews;
