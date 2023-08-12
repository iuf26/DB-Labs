use RoundTheGlobe;
go;

--tabele alese:
--Artist, Venue, Play




--Artist




--function for testing names
--a name is a varchar(50) and it must be not null
create or alter function dbo.TestVC50(@name varchar(50))
returns int
as
begin
	declare @retval int
	set @retval=0 --default, if it's good
	if @name is null 
		set @retval=1 -- if it's null

	return @retval
end

---procedure for artist insertion - output parameter for success
---flag is 0 if succesful, 1 otherwise

go
create or alter procedure insert_artist
	@name varchar(50),
	@flag bit OUTPUT
as
begin
	insert into Artist (Name) values (@name)
	if @@ROWCOUNT > 0 set @flag=0;
	else set @flag=1;
end


---CRUD procedure for Artist Table

go
create or alter procedure CRUD_Artist
	@name varchar(50),
	@new_name varchar(50)
as
begin
	declare @e1 int
	declare @e2 int
	set @e1 = dbo.TestVC50(@name)
	set @e2 = dbo.TestVC50(@new_name)
	if @e1=0 and @e2=0
	begin
		--create--
		declare @flag bit
		exec insert_artist @name, @flag output
		if @flag=0
			print 'Create operation for Artist table succesful'
		else
			print 'Create operation failed for Artist table'

		--read--
		select * from Artist where Name=@name
		print 'Read operation for Artist table succesful'

		--update
		update Artist set Name=@new_name where Name=@name
		print 'Update operation for Artist tabl succesfule'

		--delete
		delete from Artist where Name=@new_name
		print 'Delete operation for Artist table succesful'

		print 'CRUD operations for Artist table are done'
	end
	else
	begin
		if @e1=1
			print 'Error: Artist name must be not null - for parameter name'
		if @e2=1
			print 'Error: Artist name must be not null - for parameter new_name'
	end
end

exec CRUD_Artist 'Ban Balan','Dan Balan'
exec CRUD_Artist null, 'fan'
exec CRUD_Artist 'Ban',null
exec CRUD_Artist null,null






---Venue





--function for validating capacity
go
create or alter function dbo.TestCapacity(@capacity int)
returns int
as
begin
	declare @retval int
	set @retval=0 --default, if it's good
	if @capacity is null 
		set @retval=1 -- if it's null
	else if @capacity<=9 
		set @retval=2

	return @retval
end



---procedure for venue insertion - output parameter for success
---flag is 0 if succesful, 1 otherwise

go
create or alter procedure insert_venue
	@name varchar(50),
	@capacity int,
	@flag bit OUTPUT
as
begin
	insert into Venue(Name,Capacity) values (@name,@capacity)
	if @@ROWCOUNT > 0 set @flag=0;
	else set @flag=1;
end



---CRUD procedure for Venue Table

go
create or alter procedure CRUD_Venue
	@name varchar(50),
	@capacity int,
	@new_name varchar(50),
	@new_capacity int
as
begin
	declare @e_n int
	declare @e_c int
	declare @e_nn int
	declare @e_nc int
	set @e_n = dbo.TestVC50(@name)
	set @e_c = dbo.TestCapacity(@capacity)
	set @e_nn = dbo.TestVC50(@new_name)
	set @e_nc = dbo.TestCapacity(@new_capacity)
	if @e_n=0 and @e_c=0 and @e_nn=0 and @e_nc=0
	begin
		--create--
		declare @flag bit
		exec insert_venue @name,@capacity, @flag output
		if @flag=0
			print 'Create operation for Venue table succesful'
		else
			print 'Create operation failed for Venue table'

		--read--
		select * from Venue where Name=@name and Capacity=@capacity
		print 'Read operation for Venue table succesful'

		--update
		update Venue set Name=@new_name,Capacity=@new_capacity where Name=@name and Capacity=@capacity
		print 'Update operation for Venue table succesful'

		--delete
		delete from Venue where Name=@new_name and Capacity=@new_capacity
		print 'Delete operation for Venue table succesful'

		print 'CRUD operations for Venue table are done'
	end
	else
	begin
		if @e_n=1
			print 'Error: Venue name must be not null - for parameter name'
		if @e_c=1
			print 'Error: Venue capacity must be not null - for parameter capacity'
		else if @e_c=2
			print 'Error: Venue capacity must be at least 10 - for parameter capacity'
		if @e_nn=1
			print 'Error: Venue name must be not null - for parameter new_name'
		if @e_nc=1
			print 'Error: Venue capacity must be not null - for parameter new_capacity'
		else if @e_nc=2
			print 'Error: Venue capacity must be at least 10 - for parameter new_capacity'
	end
end

exec CRUD_Venue 'Polivalenta Botosani',10,'Monovalenta Botosani', 20
exec CRUD_Venue null, null, null, null
exec CRUD_Venue null, -1, 'Dan', null
exec CRUD_Venue 'Han', 10, null, 9
exec CRUD_Venue 'Daniel', 44, 'Bonaparte', 9





---Ticket




--function for validating price
go
create or alter function dbo.TestPrice(@price int)
returns int
as
begin
	declare @retval int
	set @retval=0 --default, if it's good
	if @price is null 
		set @retval=1 -- if it's null
	else if @price<=0 
		set @retval=2 -- if it's not positive

	return @retval
end

--function for validating int pk
go
create or alter function dbo.TestIntPK(@key int)
returns int
as
begin
	declare @retval int
	set @retval=0 --default, if it's good
	if @key is null 
		set @retval=1 -- if it's null

	return @retval
end

--function for validating if ticket key can be inserted
go
create or alter function dbo.TestTicketForInsert(@cid int,@aid int)
returns int
as
begin
	declare @retval int
	set @retval=1 --default, if it's good
	if not exists(select * from Concert where ConcertID=@cid)
		set @retval=@retval*2
	if not exists(select * from Attendee where AttendeeID=@aid)
		set @retval=@retval*3
	if @retval=1 and exists(select * from Ticket where ConcertID=@cid and AttendeeId=@aid)
		set @retval=5
	return @retval
end



---procedure for ticket insertion - output parameter for success
---flag is 0 if succesful, 1 otherwise

go
create or alter procedure insert_ticket
	@concert_id int,
	@attendee_id int,
	@type varchar(50),
	@price int,
	@flag bit OUTPUT
as
begin
	insert into Ticket(ConcertID,AttendeeID,Type,Price) values (@concert_id,@attendee_id,@type,@price)
	if @@ROWCOUNT > 0 set @flag=0;
	else set @flag=1;
end


---CRUD procedure for Ticket Table



go
create or alter procedure CRUD_Ticket
	@concert_id int,
	@attendee_id int,
	@type varchar(50),
	@price int,
	@new_type varchar(50),
	@new_price int
as
begin
	declare @e_cid int
	declare @e_aid int
	declare @e_t int
	declare @e_p int
	declare @e_nt int
	declare @e_np int
	set @e_cid = dbo.TestIntPK(@concert_id)
	set @e_aid = dbo.TestIntPK(@attendee_id)
	set @e_t = dbo.TestVC50(@type)
	set @e_p = dbo.TestPrice(@price)
	set @e_nt = dbo.TestVC50(@new_type)
	set @e_np = dbo.TestPrice(@new_price)
	if @e_cid=0 and @e_aid=0 and @e_t=0 and @e_p=0 and @e_nt=0 and @e_np=0
	begin

		set @e_aid= dbo.TestTicketForInsert(@concert_id,@attendee_id)
		if @e_aid=1
		begin
			--create--
			declare @flag bit
			exec insert_ticket @concert_id,@attendee_id,@type,@price, @flag output
			if @flag=0
				print 'Create operation for Ticket table succesful'
			else
				print 'Create operation failed for Ticket table'

			--read--
			select * from Ticket where ConcertId=@concert_id and AttendeeID=@attendee_id
			print 'Read operation for Ticket table succesful'

			--update
			update Ticket set Type=@new_type,Price=@new_price where ConcertID=@concert_id and AttendeeID=@attendee_id
			print 'Update operation for Ticket table succesful'

			--delete
			delete from Ticket where ConcertID=@concert_id and AttendeeID=@attendee_id
			print 'Delete operation for Ticket table succesful'

			print 'CRUD operations for Venue table are done'
		end
		else
		begin
			if @e_aid % 2 = 0
				print 'Error: no concert with given id exists'
			if @e_aid % 3 = 0
				print 'Error: no attendee with given id exists'
			if @e_aid=5
				print 'Error: a Ticket for given attendee at given concert already exists'
		end
	end
	else
	begin

		if @e_cid=1
			print 'Error: Concert id must be not null - for parameter concert_id'
		if @e_aid=1
			print 'Error: Attendee id must be not null - for parameter attendee_id'
		if @e_t=1
			print 'Error: Ticket type must be not null - for parameter type'
		if @e_p=1
			print 'Error: Ticket price must be not null - for parameter price'
		else if @e_p=2
			print 'Error: Ticket price must be positive - for parameter price'
		if @e_nt=1
			print 'Error: Ticket type must be not null - for parameter new_type'
		if @e_np=1
			print 'Error: Ticket price must be not null - for parameter new_price'
		else if @e_np=2
			print 'Error: Ticket price must be positive - for parameter new_price'
	end
end

select * from Concert
select * from Attendee
select * from Ticket

exec CRUD_Ticket 11,8,'deluxe',30,'regular',20
exec CRUD_Ticket 11,1000,'deluxe',30,'regular',20
exec CRUD_Ticket 2000,1000,'deluxe',30,'regular',20
exec CRUD_Ticket 1,51,'deluxe',30,'regular',20
exec CRUD_Ticket null,51,'deluxe',null,'regular',-4
exec CRUD_Ticket 20,51,'del',40,'regular',0
exec CRUD_Ticket null,51,'deluxe',null,null,null



----views si indexi

select * from Artist
select * from Venue
select * from Ticket


---for Artist
go
create view ViewArtistsStartBlack as
	select * from Artist where Name like 'Black%'

go

create nonclustered index N_idx_Name ON Artist (Name)

select * from ViewArtistsStartBlack

--for Venue
go
create view ViewVenueWithMediumCapacity as
	select * from Venue where Capacity>=100 and Capacity<1000

go

create nonclustered index N_idx_Capacity ON Venue(Capacity)

select * from ViewVenueWithMediumCapacity

--for Ticket

go
create or alter view ViewMostExpensiveTickets  as
	select top 10 * from Ticket
	order by Price desc

go

create nonclustered index N_idx_Price ON Ticket(Price)

select * from ViewMostExpensiveTickets