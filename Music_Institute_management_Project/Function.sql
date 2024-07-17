--Query Number 1
GO
CREATE OR ALTER FUNCTION InstructorBasedOnInstrument(@InstrumentName NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN
  SELECT T.t_InstructorID [Instructor ID],CONCAT(p_First_Name, ' ',p_Last_Name) [Instructor Name]
  FROM Teaches T , Instrument I , Person p, Instructor Ir
  WHERE T.t_InstrumentID = I.Instrument_ID
  AND T.t_InstructorID = Ir.Instructor_ID
  AND p.p_ID = Ir.i_PersonID
  AND I.Instrument_Name = @InstrumentName
GO

SELECT * FROM InstructorBasedOnInstrument('Piano')


--Query Number 2
GO
CREATE OR ALTER FUNCTION BookBasedOnInstrument(@InstrumentName NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN
	  SELECT EB.Book_Name [Book Name], EB.Book_Author [Book Author],
	  EB.Book_Publisher [Book Publisher], EB.Book_level [Level Of Book],
	  I.Instrument_Name [Instrument]
	  FROM Educational_Book EB JOIN Instrument I 
	  ON I.Instrument_ID = EB.b_InstrumentID
	  WHERE  I.Instrument_Name = @InstrumentName
GO

SELECT * FROM BookBasedOnInstrument('trumpet')

--Query Number 3
GO
CREATE OR ALTER FUNCTION ClassBasedOnInstrctor(@InstructorName NVARCHAR(MAX))
RETURNS @ClassInstrument TABLE (
[Class ID] BIGINT, 
[Institute Name] NVARCHAR(MAX),
[Student Name] NVARCHAR(MAX),
Instrument NVARCHAR(MAX),
[Day Of Class] NVARCHAR(MAX),
[Term Of Class] NVARCHAR(MAX))
AS
BEGIN
	INSERT INTO @ClassInstrument([Class ID], [Institute Name],
		[Student Name], Instrument, [Day Of Class], [Term Of Class])
	  SELECT Class.Class_ID,  Institute.Institute_Name,
		CONCAT(P2.p_First_Name, ' ', P2.p_Last_Name), Instrument.Instrument_Name,
		Class.c_DayOfClass, CONCAT(Class.c_TermSeason, ' ', Class.c_TermYear)
	  FROM Class
	  JOIN Instrument ON Instrument.Instrument_ID = Class.c_InstrumentID
	  JOIN Instructor ON Instructor.Instructor_ID = Class.c_InstructorID
	  JOIN Person P1 ON Instructor.i_PersonID = P1.p_ID
	  JOIN Student ON Student.Student_ID = Class.c_StudentID
	  JOIN Person P2 ON Student.s_PersonID = P2.p_ID
	  JOIN Institute ON Institute.Institute_ID = Class.c_InstituteID
	  WHERE CONCAT(P1.p_First_Name, ' ', P1.p_Last_Name) =  @InstructorName
	  RETURN
END;
GO

SELECT * FROM ClassBasedOnInstrctor('Susan Dunbabin')


--Query Number 4
GO
CREATE OR ALTER FUNCTION BookBasedOnLevel(@Level_OfBook NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN
	  SELECT B.Book_ID [Book ID] , B.Book_Name [Book Name], B.Book_Author [Book Author],
		B.Book_Publisher [Book Publisher], I.Instrument_Name [Instrument]
	  FROM Educational_Book B JOIN Instrument I 
	  ON B.b_InstrumentID = I.Instrument_ID
	  WHERE B.Book_level = @Level_OfBook
GO

SELECT * FROM BookBasedOnLevel('advanced')


--Query Number 5
GO
CREATE OR ALTER FUNCTION ClassBasedOnEligibility()
RETURNS TABLE
RETURN
	SELECT *
    FROM Class AS C
    WHERE C.c_Eligibility = 1
GO

SELECT * FROM ClassBasedOnEligibility()


--Query Number 6
GO
CREATE OR ALTER FUNCTION StudentBasedOnInstitue(@InstituteName NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN
    SELECT DISTINCT S.Student_ID [Student ID], CONCAT(P.p_First_Name, ' ', P.p_Last_Name) [Student Name]
    FROM Person P, Student S, Class C, Institute I, Instrument It
    WHERE 
	     P.p_ID = S.s_PersonID
		 AND C.c_StudentID = S.Student_ID
		 AND C.c_InstrumentID = It.Instrument_ID
		 AND C.c_InstituteId = I.Institute_ID
		 AND I.Institute_Name = @InstituteName
GO

SELECT * FROM StudentBasedOnInstitue('sol')


--Query Number 7
GO
CREATE OR ALTER FUNCTION InstrumentBasedOnType(@TypeOfInstrument NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN
	  SELECT I.Instrument_ID [ID], I.Instrument_Name [Name]
	  FROM Instrument AS I
	  WHERE I.TypesOf_Instrument = @TypeOfInstrument
GO

SELECT * FROM InstrumentBasedOnType('Wind')


--Query Number 8
GO
CREATE OR ALTER FUNCTION ClassBasedOnInstrument(@InstrumentName NVARCHAR(MAX))
RETURNS @ClassInstrument TABLE (
[Class ID] BIGINT,
[Instructor Name] NVARCHAR(MAX),
[Student Name] NVARCHAR(MAX),
Instrument NVARCHAR(MAX),
[Day Of Class] NVARCHAR(MAX),
[Term Of Class] NVARCHAR(MAX))
AS
BEGIN
	INSERT INTO @ClassInstrument([Class ID], [Instructor Name],
		[Student Name], Instrument, [Day Of Class], [Term Of Class])
	  SELECT Class.Class_ID, CONCAT(P1.p_First_Name, ' ', P1.p_Last_Name),
		CONCAT(P2.p_First_Name, ' ', P2.p_Last_Name), Instrument.Instrument_Name,
		Class.c_DayOfClass, CONCAT(Class.c_TermSeason, ' ', Class.c_TermYear)
	  FROM Class
	  JOIN Instrument ON Instrument.Instrument_ID = Class.c_InstrumentID
	  JOIN Instructor ON Instructor.Instructor_ID = Class.c_InstructorID
	  JOIN Person P1 ON Instructor.i_PersonID = P1.p_ID
	  JOIN Student ON Student.Student_ID = Class.c_StudentID
	  JOIN Person P2 ON Student.s_PersonID = P2.p_ID
	  WHERE Instrument.Instrument_Name =  @InstrumentName
	  RETURN
END;
GO

SELECT * FROM ClassBasedOnInstrument('Piano')


--Query Number 9
GO
CREATE OR ALTER FUNCTION BookBasedOnPublisher(@Publisher NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN
	  SELECT *
	  FROM Educational_Book AS B
	  WHERE B.Book_Publisher = @Publisher
GO

SELECT * FROM BookBasedOnPublisher('Koelpin')


--Query Number 10
GO
CREATE OR ALTER FUNCTION StudentBasedOnInstrument1(@InstrumentName NVARCHAR(MAX))
RETURNS @StudentInstrument TABLE(Student_ID BIGINT, [Name] NVARCHAR(MAX) )
AS
BEGIN
    INSERT INTO @StudentInstrument (Student_ID, [Name])
	  SELECT DISTINCT S.Student_ID, CONCAT(P.p_First_Name, ' ', P.p_Last_Name)
	  FROM Person P, Student S, Is_Learning L, Instrument I
	  WHERE
		   P.p_ID = S.s_PersonID
		   AND L.l_StudentID = S.Student_ID
		   AND I.Instrument_ID = L.l_InstrumentID
		   AND I.Instrument_Name = @InstrumentName 
    RETURN
END;
GO

SELECT * FROM StudentBasedOnInstrument1('violin')


--Query Number 11
GO
CREATE OR ALTER FUNCTION AvailableClass_FilterByInstrument(@InstrumentName NVARCHAR(MAX))
RETURNS @AvailableClass TABLE
([Available Class No.] BIGINT IDENTITY,
[Class ID] BIGINT,
[Institute] NVARCHAR(MAX),
[Instructor Name] NVARCHAR(MAX),
[Day Of Class] NVARCHAR(MAX),
[Term] NVARCHAR(MAX))
AS
BEGIN
	INSERT INTO @AvailableClass([Class ID], [Institute], [Instructor Name], [Day Of Class], [Term])
	SELECT DISTINCT C.Class_ID,
        Ie.Institute_Name ,
        CONCAT(p.p_First_Name, ' ', p.p_Last_Name),
        C.c_DayOfClass ,
        CONCAT(C.c_TermSeason, ' ', C.c_TermYear)
	FROM Class C JOIN Instrument I
	ON C.c_InstrumentID = I.Instrument_ID AND I.Instrument_Name = @InstrumentName
	JOIN Institute Ie ON C.c_InstituteID = Ie.Institute_ID 
	JOIN Instructor Ins ON C.c_InstructorID = Ins.Instructor_ID
	JOIN Person P ON Ins.i_PersonID = P.P_ID
	WHERE C.c_Eligibility = 1
	ORDER BY C.Class_ID DESC
	RETURN
END
GO
		    
SELECT * FROM AvailableClass_FilterByInstrument('Piano')


--Query Number 12
GO
CREATE OR ALTER FUNCTION TeachingInstrument(@InstructorName NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN
    SELECT It.Instrument_Name [Instrument], T.Teaching_Time [Teaching Time]
    FROM Instructor I JOIN Person P ON I.i_PersonID = P.p_ID
	JOIN Teaches T ON T.t_InstructorID = I.Instructor_ID
	JOIN Instrument It ON T.t_InstrumentID = It.Instrument_ID 
    WHERE CONCAT(p.p_First_Name,' ', p.p_Last_Name)  = @InstructorName
GO

SELECT * FROM TeachingInstrument('Tad Barrowcliffe')


--Query Number 13
GO
CREATE OR ALTER FUNCTION Instructor_BasedOnInstitude(@InstituteName NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN
	SELECT [newTable].Instructor [Instructor],COUNT(*) [Number Of Teaching Term]
	FROM (SELECT CONCAT(P.p_First_Name , ' ', P.p_Last_Name) [Instructor]
		FROM Instructor I JOIN Person P ON I.i_PersonID = P.p_ID
		JOIN Is_MemberOf M ON M.m_InstructorID = I.Instructor_ID
		JOIN Institute It ON M.m_InstituteID = IT.Institute_ID
		JOIN Class C ON C.c_InstituteID = It.Institute_ID AND C.c_InstructorID = I.Instructor_ID
		WHERE It.Institute_Name = @InstituteName
		GROUP BY P.p_ID, p.p_First_Name, p.p_Last_Name,
			C.c_InstituteID, C.c_InstructorID, C.c_TermSeason, C.c_TermYear) AS newTable
	GROUP BY newTable.Instructor
GO

SELECT * FROM Instructor_BasedOnInstitude('Pars')


-- Query Number 14
GO
CREATE OR ALTER FUNCTION InstructorOf_StudentBasedOn_Instrument(@StudentName NVARCHAR(MAX), @InstrumentName NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN
	SELECT CONCAT(P2.p_First_Name, ' ', P2.p_Last_Name) [Instructor Name], 
		CONCAT(C.c_TermSeason, ' ', C.c_TermYear) [Term]
	FROM Person P1 JOIN Student S ON S.s_PersonID = P1.P_ID
	JOIN Class C ON S.Student_ID = C.c_StudentID
	JOIN Instrument I ON I.Instrument_ID = C.c_InstrumentID
	JOIN Instructor Ir ON C.c_InstructorID = Ir.Instructor_ID
	JOIN Person P2 ON Ir.i_PersonID = P2.P_ID
	WHERE I.Instrument_Name = @InstrumentName 
	AND CONCAT(P1.p_First_Name, ' ', P1.p_Last_Name) = @StudentName
GO

SELECT * FROM InstructorOf_StudentBasedOn_Instrument('Claresta Zanelli', 'Piano')


--FUNCTION FOR TRIGGER
GO
CREATE OR ALTER FUNCTION update_FinalSession(@FirstSession DATE, @lastDayOfSeason DATE)
RETURNS DATE
AS
BEGIN
    DECLARE @FinalSession DATE;
    SET @FinalSession = 
        (SELECT DATEADD(DAY,
            (SELECT 
                CASE 
                WHEN DATEPART(WEEKDAY, @FirstSession) <= DATEPART(WEEKDAY, @lastDayOfSeason)
                    THEN DATEPART(WEEKDAY, @FirstSession) - DATEPART(WEEKDAY, @lastDayOfSeason) 
                WHEN DATEPART(WEEKDAY, @FirstSession) > DATEPART(WEEKDAY, @lastDayOfSeason)
                    THEN DATEPART(WEEKDAY, @lastDayOfSeason) - DATEPART(WEEKDAY, @FirstSession) + 1
                END), @lastDayOfSeason))
    RETURN @FinalSession;
END;