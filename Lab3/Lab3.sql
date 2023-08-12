create table Versiune(
id int primary key default 0)

insert into Versiune(id) values(0)
go


--modifica tipul unei coloane
create procedure V1 as
declare @v int
select top 1 @v=id
from Versiune
if @v = 0
begin
	alter table Sala
	alter column Etaj smallint
	print 'Tipul coloanei Etaj din tabela Sala a fost modificat'
	update Versiune set id = 1
	print 'Baza de date este la versiunea 1'
end
go

--modifica tipul unei coloane
create procedure IV1 as
declare @v int
select top 1 @v=id
from Versiune
if @v = 1
begin
	alter table Sala
	alter column Etaj int
	update Versiune set id = 0
	print 'Tipul coloanei Etaj din tabela Sala a fost modificat la tipul initial'
	print 'Baza de date este la versiunea 0'
end
go

--adauga o constrangere
create procedure V2 as
declare @v int
select top 1 @v=id
from Versiune
if @v = 1
begin

	alter table Organizatori
	add constraint df_Organizatori default 'Nume organizator' for Nume
	update Versiune set id = 2
	print 'A fost adaugata o constrangere in tabela Organizatori'
	print 'Baza de date este la versiunea 2'
end
go

--sterg o constrangere
create procedure IV2 as
declare @v int
select top 1 @v=id
from Versiune
if @v = 2
begin
	alter table Organizatori
	drop constraint df_Organizatori
	update Versiune set id = 1
	print 'A fost stearsa o constrangere in tabela Organizatori'
	print 'Baza de date este la versiunea 1'
end
go


--creeaza un nou tabel
create procedure V3 AS
declare @v int
select top 1 @v=id
from Versiune
if @v = 2
begin
	create table Cladire(Cod_C int primary key identity,
	Adresa varchar(50),
	Nr_sali int)
	update Versiune set id = 3
	print 'S-a creat tabela Cladire'
	print 'Baza de date este la verisiunea 3'
end
go

--se sterge un tabel
create procedure IV3 AS
declare @v int
select top 1 @v=id
from Versiune
if @v = 3
begin
	DROP table Cladire
	update Versiune set id = 2
	print 'S-a sters tabela Cladire'
	print 'Baza de date este la versiunea 2'
end
go

--adauga o coloana noua
create procedure V4 as
declare @v int
select top 1 @v=id
from Versiune
if @v = 3
begin
	alter table Cladire
	add Program varchar(50)
	update Versiune set id = 4
	print 'A fost adaugata coloana Program'
	print 'Baza de date este la versiunea 4'
end
go

--se sterge o coloana
create procedure IV4 as
declare @v int
select top 1 @v=id
from Versiune
if @v = 4
begin
	alter table Cladire
	drop column Program
	update Versiune set id = 3
	print 'S-a sters coloana Program'
	print 'Baza de date este la versiunea 3'
end
go

--se adauga o constrangere de cheie straina
create procedure V5 as
declare @v int
select top 1 @v=id
from Versiune
if @v = 4
begin
	alter table Cladire
	add Cid int not NULL
	alter table Cladire
	add constraint fk_Cladire foreign key (Cid) references Sala(Cod_Sala)
	update Versiune set id = 5
	print 'A fost adaugata o constrangere de cheie straina in tabela Cladire'
	print 'Baza de date este la versiunea 5'
end
go

--se sterge constrangerea de cheie straina
create procedure IV5 as
declare @v int
select top 1 @v=id
from Versiune
if @v = 5
begin
	alter table Cladire
	drop constraint fk_Cladire
	alter table Cladire
	drop column Cid
	update Versiune set id = 4
	print 'A fost steartsa o constrangere de cheie straina in tabela Cladire'
	print 'Baza de date este la versiunea 4'
end
go


create procedure Main
@new_vers int
as
	declare @old_vers int
	declare @text varchar(50)
	select top 1 @old_vers=id
	from Versiune

	if @new_vers < 0 or @new_vers > 5
	begin
		print 'Versiune invalida'
	end
	else
	begin
		if @old_vers < @new_vers
		begin
			set @old_vers = @old_vers + 1
			while @old_vers <= @new_vers
			begin
				set @text = 'V' + convert(varchar(5), @old_vers)
				exec @text
				set @old_vers = @old_vers + 1
			end
		end
		else
		begin
			if @old_vers > @new_vers
			begin
	
				while @old_vers > @new_vers
				begin
					set @text = 'IV' + convert(varchar(5), @old_vers)
					exec @text
					set @old_vers = @old_vers - 1
				end
				
			end
		end
	end
go

exec Main -5