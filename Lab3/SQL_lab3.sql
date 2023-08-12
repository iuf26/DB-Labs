use [MagazinSuveniruri_2.0]
go

--creare tabela verisune cu un singur elemente
create table versiune
(id int primary key identity,
v int default 0)
insert into versiune values(0)
select * from versiune
go

create procedure mod1
as
begin
	alter table Patron
	alter column adresa varchar(20)
end
go

create procedure mod1_undo
as 
begin
	alter table Patron
	alter column adresa varchar(15)
end
go

create procedure mod2
as
begin
	alter table suvenir
	add constraint df_nu default 'nu' for disponibilitate
end
go

create procedure mod2_undo
as
begin
	alter table suvenir
	drop constraint df_nu
end
go

create procedure mod3
as
begin
	create table Angajati_auxiliari
	(id int primary key,
	nume varchar(30),
	adresa varchar(20),
	ocupatie varchar(20))
end
go

create procedure mod3_undo
as
begin
	drop table Angajati_auxiliari
end
go

create procedure mod4
as
begin
	alter table patron
	add varsta int
end
go

create procedure mod4_undo
as
begin
	alter table patron
	drop column varsta
end
go

create procedure mod5
as
begin
	create table Tip_Comanda
	(tID int primary key,
	cID int constraint	fk_comanda_tip foreign key(cID) references comanda(comandaID)) 
end
go

create procedure mod5_undo
as
begin
	drop table Tip_Comanda
end
go

--functia principala de trecere de la o versiune la alta
create procedure Main
@versiune_dorita int
as
begin
	declare @versiune_curenta int 
	declare @cmd varchar(50)
	select top 1 @versiune_curenta = v from versiune
	if @versiune_dorita >5 
		print('Versiune indisponibila')
	else
		begin
			if @versiune_dorita > @versiune_curenta
				while @versiune_curenta < @versiune_dorita
					Begin
					    SET @cmd = 'mod' + CONVERT(VARCHAR(5), @versiune_curenta+1)
						exec @cmd
						print 'S-a efectuat comanda '+ @cmd
						set @versiune_curenta=@versiune_curenta+1
					End
			else
				while @versiune_curenta > @versiune_dorita
					Begin
						 SET @cmd = 'mod' + CONVERT(VARCHAR(5), @versiune_curenta) + '_undo'
						 exec @cmd
						 print @cmd
						 set @versiune_curenta=@versiune_curenta-1
					End
		end
		update versiune set v=@versiune_curenta where id=1	
		print 'Proiectul se afla in versiunea '+ CONVERT(VARCHAR(5), @versiune_curenta)
end
go


-- De aici se executa comanda main principala de trecere de la o versiune la alta
exec main @versiune_dorita = 5