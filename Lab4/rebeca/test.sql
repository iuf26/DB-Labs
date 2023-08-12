USE CompanieCosmetice

GO

create or alter procedure test
as begin
	declare @TestID int, @TestRunID int, @TableID int, @NoOfRows int, @ViewID int
	declare @TestName varchar(50), @TableName varchar(50), @ViewName varchar(50)
	declare @StartTime datetime
	declare cursor_teste cursor for select TestID, Name from Tests
	open cursor_teste
	fetch next from cursor_teste into @TestID, @TestName
	while @@FETCH_STATUS = 0
	begin
		print 'rulare test ' + CONVERT (VARCHAR(5), @TestID)
		declare cursor_tabele cursor scroll for
		select T.TableID, T.Name, TT.NoOfRows
		from Tables T inner join TestTables TT on T.TableID = TT.TableID
		where TestID = @TestID 
		order by Position
		open cursor_tabele
		fetch next from cursor_tabele into @TableID, @TableName, @NoOfRows
		while @@FETCH_STATUS = 0 
		begin
			exec delete_table @TableID, @NoOfRows
			fetch next from cursor_tabele into @TableID, @TableName, @NoOfRows
		end
		
		insert into TestRuns values (@TestName, getdate(), null)
		set @TestRunID = @@IDENTITY
		fetch prior from cursor_tabele into @TableID, @TableName, @NoOfRows

		while @@FETCH_STATUS = 0
		begin
			set @StartTime = getDate()
			exec insert_table @TableID, @NoOfRows
			insert into TestRunTables values(@TestRunID, @TableID, @StartTime, getdate())
			fetch prior from cursor_tabele into @TableID, @TableName, @NoOfRows
		end

		close cursor_tabele
		deallocate cursor_tabele

		declare cursor_views cursor scroll for
		select V.ViewID, V.Name
		from Views V inner join TestViews TV on V.ViewID = TV.ViewID
		where TestID = @TestID 
		open cursor_views
		fetch next from cursor_views into @ViewID, @ViewName
		while @@FETCH_STATUS = 0 begin
			set @StartTime = getdate()
			set @ViewID = @ViewID - 6
			exec select_view @ViewID
			set @ViewID = @ViewID + 6
			insert into TestRunViews VALUES(@TestRunID, @ViewID, @StartTime, getdate())
			fetch next from cursor_views into @ViewID, @ViewName
		end
		close cursor_views
		deallocate cursor_views

		update TestRuns set EndAt = getdate() where TestRunID = @TestRunID
		fetch next from cursor_teste into @TestID, @TestName
	end
	close cursor_teste
	deallocate cursor_teste
end 


exec test

SELECT * FROM TestRuns
SELECT * FROM TestRunViews
SELECT * FROM TestRunTables

