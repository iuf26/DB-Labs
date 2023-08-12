use RoundTheGlobe
go
create table DatabaseVersion(
Version int primary key
)
insert into DatabaseVersion (Version) values (1)
select * from DatabaseVersion

/*
modifies address number type from int to small int
*/
create procedure update_to_2
as
BEGIN
	alter table Address
	alter column Number smallint
	print 'Address Number type changed from int to smallint'
END

/*
Changes address number type from smallint to int
*/
create procedure downgrade_to_1
as
BEGIN
	alter table Address
	alter column Number int
	print 'Address Number type changed from smallint to int'
END

/*
adds default value 100 to ticket price
*/
create procedure update_to_3
as
BEGIN
	alter table Ticket
	add constraint dv_price default 100 for price
	print 'Added ticket default price 100'
END

/*
Deletes default ticket price
*/
create procedure downgrade_to_2
as
BEGIN
	alter table Ticket
	drop constraint dv_price
	print 'Deleted ticket default price'
END

/*
Creates table Rating
*/
create procedure update_to_4
as
BEGIN
	create table Rating(
	ConcertID int,
	AttendeeID int,
	Stars tinyint,
	CONSTRAINT pk_Rating primary key(ConcertID,AttendeeID),
	CONSTRAINT ck_start check(Stars between 0 and 5)
	)
	print 'Table Rating created'
END

/*
Deletes table Rating
*/
create procedure downgrade_to_3
as
BEGIN
	drop table Rating
	print 'Table Rating deleted'
END

/*
Adds ShortDecription column to Rating table
*/
create procedure update_to_5
as
BEGIN
	alter table Rating
	add ShortDescription varchar(50)
	print 'added ShortDescription column from Rating'
END

/*
Removes ShortDecription column from Rating table
*/
create procedure downgrade_to_4
as
BEGIN
	alter table Rating
	drop column ShortDescription
	print 'removed ShortDescription column from Rating'
END

/*
Adds foreign key constraint to Rating ConcertID and AttendeeID (references Ticket attributes)
*/
create procedure update_to_6
as
BEGIN
	alter table Rating
	add CONSTRAINT fk_ConcertAttendeeID foreign key(ConcertID,AttendeeID) references Ticket(ConcertID,AttendeeID)
	print 'Added Foreign Key constraint to Rating ConcertID and AttendeeID (they reference ticket attributes with the same name)'
END

/*
Deletes foreign key constraints to Rating ConcertID and AttendeeID
*/
create procedure downgrade_to_5
as
BEGIN
	alter table Rating
	drop CONSTRAINT fk_ConcertAttendeeID
	print 'Rating (ConcertID, AttendeeID) foreign key deleted'
END

create procedure change_version
@version int
AS
BEGIN
	IF @version<1 OR @version>6
	BEGIN
		print 'Wanted version doesn''t exit'
	END
	ELSE
	BEGIN
		declare @currentVersion int
		declare @contor int
		declare @toExecute varchar(50)
		select @currentVersion=Version from DatabaseVersion
		IF @currentVersion<@version
		BEGIN
			set @contor = @currentVersion + 1
			WHILE @contor<=@version
			BEGIN 
				set @toExecute =CONCAT('update_to_',CAST(@contor as char(5)))
				exec(@toExecute)
				update DatabaseVersion
				set Version=@contor
				set @contor = @contor + 1
			END
		END
		ELSE
		BEGIN
			IF @currentVersion>@version
			BEGIN
				set @contor = @currentVersion - 1
			WHILE @contor>=@version
			BEGIN 
				set @toExecute =CONCAT('downgrade_to_',CAST(@contor as char(5)))
				exec(@toExecute)
				update DatabaseVersion
				set Version=@contor
				set @contor = @contor - 1
			END
			END
			ELSE
				print 'Database already in this version!'
		END
	END
END


select * from DatabaseVersion
exec change_version 1