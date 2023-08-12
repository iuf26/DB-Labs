use Cartier_v2
go 



--Modifica tipul unei coloane
--v1
create procedure ModificaColoana as begin 
	alter table Blocuri
	alter column NrApartamente smallint
	print 'Coloana a fost modificata'
end
go

--invers v1
create procedure UndoModificaColoana as begin
	alter table Blocuri
	alter column NrApartamente int
	print 'Coloana a fost resetata la tipul initial'
end
go

--Adauga o costrângere de “valoare implicit?” pentru un câmp
--v2
create procedure AddConstr as begin
	alter table Parcuri
	add constraint df_Parcuri default 15 for nrBanci
	print 'Numarul de banci dintr-un parc a fost setat default la 15'
end
go

--invers v2
create procedure UndoAddConstr as begin
	alter table Parcuri
	drop constraint df_Parcuri
	print 'Parcurile nu mai au 15 banci default'
end
go

--create table
--v3
create procedure AddTable as begin
	create table Retea(
	ReteaId int primary key identity,
	codB int)
	print 'A fost creat tabel Retea'
end
go

drop procedure UndoAddTable

--invers v3
create procedure UndoAddTable as begin
	drop table Retea
	print 'A fost stearsa tabela Retea'
end 
go


--adauga un camp nou
--v4
create procedure AddCamp as begin
	alter table Retea
	add nrMaxim int
	print 'A fost adaugat camp nou'
end
go

--invers v4
create procedure UndoAddCamp as begin
	alter table Retea
	drop column nrMaxim 
	print 'A fost sters tabel Retea'
end
go

drop procedure AddConstrFk
drop procedure UndoAddConstrFk

--creea o constrângere de cheie str?in?
--v5
create procedure AddConstrFK as begin
	alter table Masini
	add constraint fk_Masini foreign key(codB)
	references Birouri(codB)
	print 'A fost adaugata constrangerea de cheie straine'
end
go

--invers v5
create procedure UndoAddConstrFK as begin
	alter table Masini
	drop constraint fk_Masini
	print 'A fost stearsa constrangerea de cheie straine'
end 
go

create table Versiuni(
	versiune int)

insert into versiuni values (0)

--Version Control
create procedure versionControl
    @wantedVersion tinyint
as
begin
    declare @vers tinyint
    set @vers = (select versiune from dbo.Versiuni)


	 if(@wantedVersion < 0 OR @wantedVersion > 5) begin
        print('Versiunea trebuie sa fie un numar intre 0 si 5!')
        goto SKIPPER
    end

    while(@vers < @wantedVersion)
    begin
        if(@vers = 0) begin
            exec ModificaColoana
        end
        if(@vers = 1) begin
            exec AddConstr
        end
        if(@vers = 2) begin
            exec AddTable
        end
        if(@vers = 3) begin
            exec AddCamp
        end
        if(@vers = 4) begin
            exec AddConstrFK
        end
        set @vers = @vers +1;
    end

    while(@vers > @wantedVersion)
    begin
        if(@vers = 5) begin
            exec UndoAddConstrFK
        end
        if(@vers = 4) begin
            exec UndoAddCamp
        end
        if(@vers = 3) begin
            exec UndoAddTable
        end
        if(@vers = 2) begin
            exec UndoAddConstr
        end
        if(@vers = 1) begin
            exec UndoModificaColoana
        end
        set @vers = @vers -1;
    end

    if(@vers = @wantedVersion)
    begin
        print 'Baza de date a fost adusa la versiunea dorita!'
        update dbo.Versiuni
        set versiune = @vers
    end

    skipper:
end
go

exec versionControl 2