GO
USE Teatru
GO

SELECT * FROM Tables;
SELECT * FROM Views;
SELECT * FROM Tests;
SELECT * FROM TestViews;
SELECT * FROM TestTables;


---numarul de spectacole pentru fiecare actor
go
create view view1 as
select a.Cod_act, a.Nume,
count(a.Cod_act) as [Numar spectacole]
from Actori a, ActoriSpectacole s
where a.Cod_act = s.Cod_act
group by a.Cod_act, a.Nume

---numele personajelor care contin '1'
go
create view view3 as
select Nume_personaj
from Rol
where Nume_personaj like '%1%'

---actorii si personajele jucate
go
CREATE VIEW view2 AS
SELECT a.Nume, r.Nume_personaj
FROM Actori a INNER JOIN Rol r ON a.CodR=r.CodR
go

insert into Tables(Name) values ('Rol'),('Actori'),('ActoriSpectacole')

insert into Views(Name) values ('view1'),('view2'),('view3')

insert into Tests(Name) values ('delete_table'),('insert_table'), ('select_view');

insert into TestViews(TestID, ViewID) values (3,1),(3,2),(3,3);

insert into TestTables(TestID, TableID,NoOfRows,Position) values
(1,7,0,3),(1,8,0,2),(1,9,0,1),(2,7,10,1),(2,8,10,2),(2,9,10,3);


go
create procedure Select_View1 as
select * from view1

go
create procedure Select_View2 as
select * from view2

go
create procedure Select_View3 as
select * from view3

go
create procedure delete_ActoriSpectacole as
delete from ActoriSpectacole

go
create procedure delete_Actori as
begin
	delete from ActoriSpectacole
	delete from Actori
end

go
create procedure delete_Rol as
begin
	delete from ActoriSpectacole
	delete from Actori
	delete from Rol
end

go
create procedure insert_Rol
as
begin
	declare @NoOfRows int
	declare @n int
	SELECT TOP 1 @NoOfRows = NoOfRows FROM Tables, Tests, TestTables WHERE
				Tables.TableID=TestTables.TableID AND Tables.Name='Rol' AND
				Tests.TestID=TestTables.TestID AND Tests.Name='insert_table';
	
	set @n=1
	while @n<@NoOfRows
	begin
		declare @nume varchar(50)
		declare @observatii varchar(50)

		set @nume = 'Nume' + convert(varchar(15), floor(rand()*(30-1+1)+1))
		set @observatii = 'Observatii' + convert(varchar(15), floor(rand()*(30-1+1)+1))

		insert into Rol(Nume_personaj, Observatii) values(@nume, @observatii)
		set @n = @n + 1
	end
end

go
create procedure insert_Actori
as
begin
	declare @nr int
	set @nr = 0
	set @nr = (select count(*) from Rol)
	if @nr < 10
		exec insert_Rol
	declare @NoOfRows int
	declare @n int
	SELECT TOP 1 @NoOfRows = NoOfRows FROM Tables, Tests, TestTables WHERE
				Tables.TableID=TestTables.TableID AND Tables.Name='Actori' AND
				Tests.TestID=TestTables.TestID AND Tests.Name='insert_table';
	
	set @n=1
	while @n<@NoOfRows
	begin
		declare @nume varchar(50)

		set @nume = 'Nume' + convert(varchar(15), floor(rand()*(30-1+1)+1))
		
		declare @data varchar(20)
		declare @an int
		declare @luna int
		declare @zi int

		set @an = (select FLOOR(rand()*(2021-2019+1)+2019))
		set @luna = (select FLOOR(rand()*(12-10+1)+10))
		set @zi = (select FLOOR(rand()*(29-10+1)+10))
		set @data = convert(varchar(5), @an) + '-' + convert(varchar(5), @luna) + '-' + convert(varchar(5), @zi)


		declare @telefon varchar(20)
		set @telefon = '07' + convert(varchar(15), (select floor(rand()*(9999999-1000000 + 1) + 1000000)))

		declare @cod bigint
		select top 1 @cod = CodR from Rol order by newid()
		insert into Actori(Nume,Data_nasterii, Telefon, CodR)
		values(@nume, @data, @telefon, @cod)

		set @n = @n + 1
	end
	
end

go
create procedure insert_ActoriSpectacole as
begin
	declare @nr1 int
	set @nr1 = 0
	set @nr1 = (select count(*) from Rol)
	if @nr1 < 10
		exec insert_Rol

	declare @nr2 int
	set @nr2 = 0
	set @nr2 = (select count(*) from Actori)
	if @nr2 < 10
		exec insert_Actori
	
	delete from ActoriSpectacole

	declare @NoOfRows int
	declare @n int
	
	SELECT TOP 1 @NoOfRows = NoOfRows FROM Tables, Tests, TestTables WHERE
				Tables.TableID=TestTables.TableID AND Tables.Name='ActoriSpectacole' AND
				Tests.TestID=TestTables.TestID AND Tests.Name='insert_table';
	
	set @n = 1
	declare @Cod_act int
	declare @Cod_Spect int
	
	set @Cod_act = (select max(Cod_act) from Actori)
	while @n < @NoOfRows
	begin
		set @Cod_Spect = (select floor(rand()*((select top 1 Cod_Spect from Spectacole order by Cod_Spect desc))) + 1)
		insert into ActoriSpectacole(Cod_act, Cod_Spect) values (@Cod_act, @Cod_Spect)
		set @n = @n + 1
		set @Cod_act = @Cod_act - 1
	end
end


go
create procedure Test_Rol as
begin
	declare @ds datetime
	declare @di datetime
	declare @de datetime

	set @ds = GETDATE()
	exec delete_Rol
	exec insert_Rol

	set @di=GETDATE()
	
	exec Select_View3
	set @de = GETDATE()

	declare @description nvarchar(2000)
	set @description = 'Test tabela Rol + view3'

	insert into TestRuns(Description, StartAt, EndAt) 
	values(@description, @ds, @de)

	declare @TestRunId int = (select max(TestRunId) from TestRuns)
	declare @TableId int = (select top 1 TableId from Tables)

	insert into TestRunTables(TestRunID, TableID, StartAt, EndAt)
	values (@TestRunId, @TableId, @ds, @di)

	declare @ViewId int = (select top 1 ViewId from Views)
	insert into TestRunViews(TestRunID, ViewID, StartAt, EndAt)
	values (@TestRunId, @ViewId, @di, @de)
end


go
create procedure Test_Actori as
begin
	declare @ds datetime
	declare @di datetime
	declare @de datetime

	set @ds = GETDATE()
	exec delete_Actori
	exec insert_Actori

	set @di=GETDATE()
	exec Select_View2
	set @de = GETDATE()

	declare @description nvarchar(2000)
	set @description = 'Test tabela Actori + view2'

	insert into TestRuns(Description, StartAt, EndAt) 
	values(@description, @ds, @de)

	declare @TestRunId int = (select max(TestRunId) from TestRuns)

	select * into Rez1 from Tables delete top (1) from Rez1
	declare @TableId int = (select top 1 TableId from Rez1)
	drop table Rez1
	
	insert into TestRunTables(TestRunID, TableID, StartAt, EndAt)
	values (@TestRunId, @TableId, @ds, @di)

	select * into Rez2 from Views delete top (2) from Rez2
	declare @ViewId int = (select top 1 ViewId from Rez2)
	drop table Rez2
	

	insert into TestRunViews(TestRunID, ViewID, StartAt, EndAt)
	values (@TestRunId, @ViewId, @di, @de)
end


go
create procedure Test_ActoriSpectacole as
begin
	declare @ds datetime
	declare @di datetime
	declare @de datetime

	set @ds = GETDATE()
	exec delete_ActoriSpectacole
	exec insert_ActoriSpectacole

	set @di=GETDATE()
	exec Select_View1
	set @de = GETDATE()

	declare @description nvarchar(2000)
	set @description = 'Test tabela ActoriSpectacole + view1'

	insert into TestRuns(Description, StartAt, EndAt) 
	values(@description, @ds, @de)

	declare @TestRunId int = (select max(TestRunId) from TestRuns)

	select * into Rez3 from Tables delete top (2) from Rez3
	declare @TableId int = (select top 1 TableId from Rez3)
	drop table Rez3
	

	insert into TestRunTables(TestRunID, TableID, StartAt, EndAt)
	values (@TestRunId, @TableId, @ds, @di)

	select * into Rez4 from Views delete top (1) from Rez4
	declare @ViewId int = (select top 1 ViewId from Rez4)
	drop table Rez4
	

	insert into TestRunViews(TestRunID, ViewID, StartAt, EndAt)
	values (@TestRunId, @ViewId, @di, @de)
end


go
create procedure main as
delete from TestRuns
delete from TestRunTables
delete from TestRunViews

delete from ActoriSpectacole
delete from Actori
delete from Rol

begin
	select * into Rez from Tables

	select * from Tables

	declare @n int = (select count(*) from Tables)
	while @n > 0
	begin
		declare @nume nvarchar(50);
		select top 1 @nume = Name from Rez
		print('Test tabela ' + @nume)
		exec('Test_'+@nume)

		delete top (1) from Rez
		set @n = @n - 1
	end
	drop table Rez
end

exec main


select * from TestRuns 
select * from TestRunTables
select * from TestRunViews


select * from Rol
select * from Actori
select * from ActoriSpectacole

