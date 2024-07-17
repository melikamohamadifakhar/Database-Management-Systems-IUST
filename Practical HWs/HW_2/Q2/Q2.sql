/*CREATE TABLE Class(
	Class_Id BIGINT IDENTITY(1,1) NOT NULL,
    Class_Name NVARCHAR(MAX) NOT NULL, 
    Class_Desc NVARCHAR(MAX),
    Class_Stat CHAR(2) NOT NULL, 
	Class_Subj	CHAR(1) NOT NULL,
    Class_StartDate	DATE NOT NULL,
    Class_EndtDate	DATE NOT NULL,
    Class_Grade	BIGINT NOT NULL,
    Class_TeacherName NVARCHAR(MAX)	NOT NULL,
	PRIMARY KEY (Class_Id),
    CHECK (Class_Stat='A' OR Class_Stat='NA' OR Class_Stat='AR'),
    CHECK(Class_EndtDate > Class_StartDate),
    CHECK(Class_Grade <= 12 AND Class_Grade >= 1),
    CHECK(Class_Subj='M' OR Class_Subj='P' OR Class_Subj='C' OR Class_Subj='B' OR Class_Subj='F' OR Class_Subj='E' OR Class_Subj='A' OR Class_Subj='R')
);*/

/*CREATE TABLE Student(
	Stu_Id INTEGER IDENTITY(1,1) NOT NULL,
    Stu_User NVARCHAR(MAX) NOT NULL,
    Stu_Pass NVARCHAR(MAX) NOT NULL,
    Stu_FName NVARCHAR(MAX)	NOT NULL,
    Stu_LName NVARCHAR(MAX)	NOT NULL,
    Stu_Email NVARCHAR(MAX),
    Stu_ClassId	BIGINT NOT NULL, 
    Stu_BirthDate NVARCHAR(MAX)	NOT NULL,
    Stu_NationalCode BIGINT	NOT NULL,              
    Stu_Address	NVARCHAR(MAX) NOT NULL,
    Stu_PhoneNum BIGINT,
	CHECK (Stu_NationalCode>=1000000000 AND Stu_NationalCode<=9999999999),
	CHECK (Stu_PhoneNum>=10000000 AND Stu_PhoneNum<=99999999),
	PRIMARY KEY (Stu_Id),
	FOREIGN KEY (Stu_ClassId) REFERENCES Class(Class_Id) ON DELETE CASCADE
);*/

/*CREATE TABLE Schedule (
    Schedule_ClassId BIGINT	NOT NULL,
	Schedule_Day BIGINT	NOT NULL,
	Schedule_StartTime TIME	NOT NULL,
	Schedule_EndTime TIME NOT NULL,
    CHECK(Schedule_Day >= 0 and Schedule_Day <= 6),
	CHECK(Schedule_StartTime < Schedule_EndTime),
	FOREIGN KEY (Schedule_ClassId) REFERENCES Class(Class_Id) ON DELETE CASCADE ON UPDATE CASCADE
);*/

/*CREATE TABLE HomeWork(
	Hw_Id BIGINT IDENTITY(1,1) NOT NULL,
    Hw_title NVARCHAR(MAX) NOT NULL, 
    Hw_Desc	NVARCHAR(Max),
    Hw_FilePath	NVARCHAR(MAX) NOT NULL,
	Hw_ClassId BIGINT NOT NULL,
    Hw_CreationDate	DATE NOT NULL,
    Hw_Deadline DATE NOT NULL, 
    CHECK(Hw_DeadLine > Hw_CreationDate),
	PRIMARY KEY (Hw_Id),    
    FOREIGN KEY (Hw_ClassId) REFERENCES Class(Class_Id)
);*/

/*CREATE TABLE Answer(
	Ans_Id BIGINT IDENTITY(1,1) NOT NULL,
	Ans_Desc NVARCHAR(MAX),
	Ans_FilePath NVARCHAR(MAX) NOT NULL,
	Ans_HwId BIGINT	NOT NULL,
	Ans_StuId INTEGER,
	Ans_Subj CHAR(1) NOT NULL,
	Ans_CreationTime NVARCHAR(MAX) NOT NULL,
	PRIMARY KEY (Ans_Id),
    FOREIGN KEY (Ans_HwId) REFERENCES HomeWork(Hw_Id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Ans_StuId) REFERENCES Student(Stu_Id) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK(Ans_Subj='M' OR Ans_Subj='P' OR Ans_Subj='C' OR Ans_Subj='B' OR Ans_Subj='F' OR Ans_Subj='E' OR Ans_Subj='A' OR Ans_Subj='R'),
    CONSTRAINT Student_HW UNIQUE(Ans_HwId , Ans_StuId)
);*/

/*CREATE TABLE Grade(
	Grade_HwId BIGINT NOT NULL,
	Grade_AnsId BIGINT,
    Grade_Value BIGINT NOT NULL,
    CHECK ( Grade_Value >= 0 and Grade_Value <= 100),
    PRIMARY KEY (Grade_HwId , Grade_AnsId),
    FOREIGN KEY (Grade_HwId) REFERENCES HomeWork(Hw_Id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Grade_AnsId) REFERENCES Answer(Ans_Id),
    CONSTRAINT HWA_HW UNIQUE(Grade_HwId , Grade_AnsId)
);*/

/*GO
CREATE OR ALTER TRIGGER DeleteAns
ON Answer
FOR DELETE 
AS 
BEGIN
	IF NOT EXISTS(SELECT Grade_AnsId
				  FROM Grade 
				  WHERE Grade_AnsId IN (SELECT Ans_Id
										FROM DELETED)) 
	BEGIN
		DELETE FROM Answer 
			   WHERE Ans_Id IN (SELECT Ans_Id FROM DELETED) 
	END
END*/

/*GO 
CREATE OR ALTER TRIGGER Insert_
ON Answer
AFTER INSERT 
AS 
BEGIN 
    INSERT INTO Grade(Grade_HwId, Grade_AnsId, Grade_Value)
    SELECT Ans_HwId, Ans_Id , FLOOR(RAND()*100)
	FROM INSERTED 
END*/
/*1*/
/*GO
CREATE OR ALTER FUNCTION NumOfClasses()
RETURNS INT 
AS 
BEGIN
	DECLARE @Count BIGINT 
	SET @Count = (SELECT COUNT(Class_Id) from Class) 
	return @Count
end*/

/*GO
CREATE OR ALTER FUNCTION NumOfStudents()
RETURNS INT 
AS 
BEGIN
	DECLARE @Count BIGINT 
	SET @Count = (SELECT COUNT(Stu_Id) from Student) 
	return @Count
end*/


/*3*/
/*GO
CREATE OR ALTER FUNCTION HwGrade(@id BIGINT)
RETURNS TABLE 
AS 
RETURN 
	SELECT Grade_Value
	FROM Grade
	WHERE Grade_HwId = @id
*/
/*4*/	
/*GO
CREATE OR ALTER FUNCTION WeekSchedule(@id BIGINT)
RETURNS TABLE 
AS 
RETURN 
	SELECT Schedule_ClassId, Class_Name , Class_TeacherName , Schedule_Day , Schedule_EndTime
	FROM Schedule, Class, Student 
	WHERE Stu_Id = @id AND Stu_ClassId = Schedule_ClassId AND Class_Id = Stu_ClassId*/
	