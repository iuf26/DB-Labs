use CompanieCosmetice
go

--creez tabela de versiune
create table Versiune(
V int primary key default 0
);
go

--inserez versiunea 0
insert into Versiune(V) values (0);
go


--modifica tipul unei coloane
alter procedure do1
as 
begin
	alter table Produs
	alter column Denumire varchar(100)
	print 'Denumire din tabela Produs este acum de tipul varchar(100)'
end;
go

--reface tipul unei coloane
alter procedure undo1
as
begin
	alter table Produs
	alter column Denumire varchar(50)
	print 'Denumire din tabela Produs a revenit la tipul varchar(50)'
end;
go


--adauga o costrangere de "valoare implicita" pentru un camp
alter procedure do2
as
begin
	alter table Comanda
	add constraint no_disc default 0 for Discount
	print 'Discount din tabela Comanda are acum valoarea implicita zero'
end;
go

--sterge constrangere de "valoare implicita" pentru un camp
alter procedure undo2
as
begin
	alter table Comanda
	drop constraint no_disc;
	print 'valoarea implicita a Discount din tabela Comanda a fost stearsa'
end;
go


--creeaza o tabela
alter procedure do3
as
begin
	create table Director(
	Did int primary key,
	Nume varchar(50),
	Fid int
	);
	print 's-a creat tabela Director'
end;
go

--sterge o tabela
alter procedure undo3
as
begin
	drop table Director;
	print 'tabela Director a fost stearsa'
end;
go


--adauga un camp nou
alter procedure do4
as
begin
	alter table Client
	add Dob date;
	print 'campul Dob a fost adaugat in tabela Client'
end;
go

--sterge un camp
alter procedure undo4
as
begin
	alter table Client
	drop column Dob;
	print 'campul Dob a fost sters din tabela Client'
end;
go


--creeaza o constrangere de cheie straina
alter procedure do5
as
begin
	alter table Director
	add constraint fk_fab_dir foreign key(Fid) references Fabrica(Fid)
	print 's-a adaugat o cheie straina intre tabela Director si Fabrica'
end;
go

--sterge o constrangere de cheie straina
alter procedure undo5
as
begin
	alter table Director
	drop constraint fk_fab_dir;
	print 'cheia straina din tabela Director a fost stearsa'
end;
go


--procedura main
alter procedure main
@nou int
as
	declare @curent int
	declare @comanda varchar(50)
	select top 1 @curent=V from Versiune

	if @nou < 0 or @nou > 5
	begin
		print 'versiune invalida'
	end
	else
	begin
		if @curent < @nou
		begin
			set @curent = @curent + 1
			while @curent <= @nou
			begin 
				set @comanda = 'do' + CONVERT(varchar(5), @curent)
				exec @comanda
				set @curent = @curent + 1
			end
		end
		else
		begin
			if @curent > @nou
			begin
				while @curent > @nou
				begin
					set @comanda = 'undo' + CONVERT(varchar(5), @curent)
					exec @comanda
					set @curent = @curent - 1
				end
			end
		end
		update Versiune set V = @nou
		print 'Baza de date este acum in versiunea'
		print @nou
	end
go
