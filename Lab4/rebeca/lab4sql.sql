use CompanieCosmetice
go

insert into Tables (Name) values ('Colectie'), ('Produs'), ('Inventar')

SELECT * FROM Tables

INSERT INTO Views (Name) VALUES ('View_1'), ('View_2'), ('View_3')

select * from View_1
select * from View_2
select * from View_3

SELECT * FROM Views

INSERT INTO Tests(Name)
VALUES ('Test 100'), ('Test 1000')

INSERT INTO TestTables (TestID, TableID, NoOfRows, Position) VALUES
(14, 1, 100, 3),
(14, 2, 100, 2),
(14, 3, 100, 1),
(15, 1, 1000, 3),
(15, 2, 1000, 2),
(15, 3, 1000, 1)


INSERT INTO TestViews (TestID, ViewID) VALUES (14, 7), (14, 8), (14, 9), (15, 7), (15, 8), (15, 9)
