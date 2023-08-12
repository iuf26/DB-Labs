use RoundTheGlobe;
go;

select * from Tables;

/*
Tables insertion
*/
insert into Tables(Name) values
('Artist'),
('Song'),
('Play');

/*
Views preparation
*/

go
create view ViewArtists as
	select ArtistID, Name from Artist;

go
create view ViewSongsWithArtists as
	select s.SongID,s.Name,a.Name as ArtistName,s.Genre,s.Minutes from
	Song s inner join Artist a on s.ArtistID=a.ArtistID;

go
create view ViewSongsWithPlayAmounts as
	select s.SongID,s.Name,s.Genre,s.Minutes,count(p.SongID)as TimesPlayed from
	Song s left join Play p on s.SongID=p.SongID
	group by s.SongID,s.Name,s.Genre,s.Minutes;

/*
Views insertion
*/
go
insert into Views(Name) values
('ViewArtists'),
('ViewSongsWithArtists'),
('ViewSongsWithPlayAmounts');

select * from Tables
select * from Views

/*
create tests
*/

/*
insert nr Artists
*/
go
create procedure insertArtists
@nr int
as
BEGIN
	declare @contor int
	set @contor = 1
	WHILE @contor<=@nr
	BEGIN
		insert into Artist (Name) values ('test')
		set @contor = @contor + 1
	END
END

/*
insert nr Songs
artist with id 1 should exist
*/
go
create procedure insertSongs
@nr int
as
BEGIN
	declare @fArtistID int
	set @fArtistID=1
	declare @contor int
	set @contor = 1
	WHILE @contor<=@nr
	BEGIN
		insert into Song (Name,ArtistID,Minutes,Genre) values ('test',@fArtistID,3,'test')
		set @contor = @contor + 1
	END
END

/*
insert nr of Plays
Concert with id 1 should exist
Songs with ids 1 to nr should exist
*/
go
create procedure insertPlays
@nr int
as
BEGIN
	declare @fSongID int
	set @fSongID=1

	declare @fConcertID int
	set @fConcertID=1

	declare @contor int
	set @contor = 1
	WHILE @contor<=@nr
	BEGIN
		insert into Play(SongID,ConcertID) values (@fSongID,@fConcertID)
		set @fSongID = @fSongID + 1
		set @contor = @contor + 1
	END
END

/*
procedure for running all the tests
*/
go
/*creates test procedures*/
create procedure testArtists
@amount int
as
BEGIN
	declare @t1 DATETIME -- start
	declare @t2 DATETIME -- table finished, view started
	declare @t3 DATETIME -- finished all
	delete from Song
	set @t1 = GETDATE()
	delete from Artist
	exec insertArtists @amount
	set @t2 = GETDATE()
	select * from ViewArtists
	set @t3 = GETDATE()

	insert into TestRuns(Description,StartAt,EndAt) values ('Testing Artist table and view',@t1,@t3);

	declare @id int
	select @id=max(TestRunID) from TestRuns

	insert into TestRunTables(TestRunID,TableID,StartAt,EndAt) values (@id,1,@t1,@t2);
	insert into TestRunViews(TestRunID,ViewID,StartAt,EndAt) values (@id,1,@t2,@t3);


END

go
create procedure testSongs
@amount int
as
BEGIN
	declare @t1 DATETIME -- start
	declare @t2 DATETIME -- table finished, view started
	declare @t3 DATETIME -- finished all
	delete from Play
	set @t1 = GETDATE()
	delete from Song
	exec insertSongs @amount
	set @t2 = GETDATE()
	select * from ViewSongsWithArtists
	set @t3 = GETDATE()

	insert into TestRuns(Description,StartAt,EndAt) values ('Testing Song table and Songs With Artists View',@t1,@t3);

	declare @id int
	select @id=max(TestRunID) from TestRuns

	insert into TestRunTables(TestRunID,TableID,StartAt,EndAt) values (@id,2,@t1,@t2);
	insert into TestRunViews(TestRunID,ViewID,StartAt,EndAt) values (@id,2,@t2,@t3);

END

go
create procedure testPlays
@amount int
as
BEGIN
	declare @t1 DATETIME -- start
	declare @t2 DATETIME -- table finished, view started
	declare @t3 DATETIME -- finished all
	set @t1 = GETDATE()
	delete from Play
	exec insertPlays @amount
	set @t2 = GETDATE()
	select * from ViewSongsWithPlayAmounts
	set @t3 = GETDATE()

	insert into TestRuns(Description,StartAt,EndAt) values ('Testing Plays table and Songs With Plays Amount View',@t1,@t3);

	declare @id int
	select @id=max(TestRunID) from TestRuns

	insert into TestRunTables(TestRunID,TableID,StartAt,EndAt) values (@id,3,@t1,@t2);
	insert into TestRunViews(TestRunID,ViewID,StartAt,EndAt) values (@id,3,@t2,@t3);

END

/* inserting the procedures/tests into the tests tables*/

insert into Tests(Name) values('testArtists'),('testSongs'),('testPlays');
/*inserting into TestTables*/
insert into TestTables(TestID,TableID,NoOfRows,Position) values
(1,1,1000,3),
(2,2,1000,2),
(3,3,1000,1)

/*inserting into TestViews*/
insert into TestViews(TestID,ViewID) values
(1,1),
(2,2),
(3,3)

go
create procedure runTests
as
BEGIN
	declare @amount int
	set @amount = 1000
	/*
	preparations
	*/
	delete from Play
	delete from Song
	delete from Artist
	DBCC CHECKIDENT ('RoundTheGlobe.dbo.Song',RESEED,0)
	DBCC CHECKIDENT ('RoundTheGlobe.dbo.Artist',RESEED,0)
	exec insertArtists @amount
	exec insertSongs @amount
	exec insertPlays @amount

	/*
	exec-urile astea au rolul de a ma executa pe mine
	*/

	exec testPlays @amount
	exec testSongs @amount
	exec testArtists @amount

	/*optional*/
	delete from Artist

END

exec runTests

select * from TestRuns
select * from TestRunTables
select * from TestRunViews