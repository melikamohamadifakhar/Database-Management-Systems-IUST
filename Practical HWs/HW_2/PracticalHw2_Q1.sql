/*Create table Employee
(  
    id bigint not null,
    parent_id bigint not null,
    first_name nvarchar(max) not null,
    last_name nvarchar(max) not null,
    Nationalcode nvarchar(10) not null,
    role nvarchar(max) not null,
	primary key (id)
);*/



/*insert into Employee (id,parent_id,[first_name],[last_name],Nationalcode,role)
VALUES      (1,1,'Ali','Jafari',1234567890,'CEO'),
			(2,1,'Zahra','Kazemi',1236547524,'HRM'),
			(3,1,'Saleh','Akbari',1236523654,'FM'),
			(4,1,'Reza','Bageri',1246578125,'TM'),
			(5,3,'Sina','Ahmadi',4512547856,'E'),
			(6,4,'Melika','Zare',2365478941,'E'),
			(7,4,'Maryam','Askari',1230212015,'E'),
			(8,4,'Mehrdad','Moradi',1203201458,'E');*/

/*GO
CREATE OR ALTER PROCEDURE [dbo].[FindChildren]
(
    @Id bigint
)
AS
BEGIN
	DECLARE @Role NVARCHAR(MAX)
	SET @Role = (SELECT role FROM Employee WHERE id = @Id)
	IF @Role = 'HRM'
		BEGIN SELECT * FROM Employee END
	ELSE 
		BEGIN
		with Children as
		(
			select *
			from Employee
			where parent_id = @Id
		),
		Grandchildren as
		(
			select *
			from Employee
			where parent_id in (
			select id from Children
			)
		)
		select * from Children
		union all
		select * from Grandchildren
		where parent_id = @id
		END
END;*/

/*EXEC FindChildren @Id = 3*/

/*GO
CREATE OR ALTER PROCEDURE [dbo].[SwapRoles]
(
	@id1 bigint,
	@id2 bigint
)
AS
BEGIN
	DECLARE @children1 TABLE(id bigint)
	INSERT @children1 SELECT id
					  FROM Employee
					  WHERE parent_id = @id1
	DECLARE @children2 TABLE(id bigint)
	INSERT @children2 SELECT id 
					  FROM Employee
					  WHERE parent_id = @id2

	DECLARE @parent1 bigint
	DECLARE @parent2 bigint

	SELECT @parent1 = parent_id
	FROM Employee
	WHERE id = @id1;

	SELECT @parent2 = parent_id
	FROM Employee 
	WHERE id = @id2;

	DECLARE @role1 nvarchar(max)
	DECLARE @role2 nvarchar(max)

	SELECT @role1 = (SELECT role 
					 FROM Employee 
					 WHERE id = @id1)

	SELECT @role2 = (SELECT role 
					FROM Employee 
					WHERE id = @id2)

	UPDATE Employee SET parent_id = @id1
					WHERE id 
					IN (SELECT id FROM @children2)
	UPDATE Employee SET parent_id = @id2 
					WHERE id
					IN (SELECT id FROM @children1)
	UPDATE Employee SET parent_id = @parent1, role = @role1 
					WHERE id = @id2
	UPDATE Employee SET parent_id = @parent2, role = @role2 
					WHERE id = @id1

	SELECT * FROM Employee
END;*/

/*EXEC SwapRoles @id1 = 2 , @id2 = 3*/

/*GO
CREATE OR ALTER PROCEDURE [dbo].[RemoveNode]
(
	@id1 BIGINT,
	@id2 BIGINT
)
AS
BEGIN
	UPDATE Employee 
	SET parent_id = @id2 
	WHERE parent_id = @id1

	DELETE FROM Employee
	WHERE id = @id1
	SELECT * FROM Employee
END;*/

/*EXEC RemoveNode @id1 = 4 ,@id2 = 2*/

/*CREATE OR ALTER PROCEDURE [dbo].[InsertToNode]
(
	@first_name nvarchar(max),
	@last_name nvarchar(max),
	@Nationalcode nvarchar(max),
	@role nvarchar(max),
	@parent_id bigint
)
AS
BEGIN
	DECLARE @max_id BIGINT 
	SET @max_id = (SELECT MAX(id) FROM Employee)
	SET @max_id = @max_id+1
	INSERT INTO Employee (id,parent_id,[first_name],[last_name],Nationalcode,role)
	VALUES	(@max_id,@parent_id,@first_name,@last_name,@Nationalcode,@role)
	SELECT * FROM Employee
END;
*/

/*EXEC InsertToNode @first_name = 'Mel' , @last_name = 'The viral' ,@Nationalcode = '1111111111' , @role = 'Dreamer', @parent_id = 2*/