--TRIGGER For Person
GO
CREATE OR ALTER TRIGGER insertPhone_Person ON Person
AFTER INSERT
AS
BEGIN
    IF(  NOT EXISTS ( SELECT * FROM Person P JOIN inserted newP ON newP.p_ID = P.p_ID
        WHERE newP.p_Phone_Number LIKE 
        '09[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' ) )
         ROLLBACK TRAN;
END;


--TRIGGER For Class
GO
CREATE OR ALTER TRIGGER updateNulls_Class ON Class
AFTER INSERT
AS
BEGIN
    DECLARE @classId BIGINT;
    SET @classId = (SELECT Class_ID FROM inserted);
    DECLARE @month_OfClass INT;
    SET @month_OfClass = (SELECT DATEPART(MONTH, newC.First_Session) FROM inserted newC)
    UPDATE Class
    SET c_TermYear = DATEPART(YEAR, First_Session),
        c_TermSeason = (
            SELECT CASE
                WHEN @month_OfClass IN (1,2,3) THEN 'Winter' WHEN @month_OfClass IN (4,5,6) THEN 'Spring'
                WHEN @month_OfClass IN (7,8,9) THEN 'Summer' WHEN @month_OfClass IN (10,11,12) THEN 'Fall'
            END),
        Final_Session = (
            SELECT CASE
                WHEN @month_OfClass IN (1,2,3) THEN 
                    (SELECT dbo.update_FinalSession(newC.First_Session, CONCAT(YEAR(newC.First_Session),'-03-31'))
                    FROM inserted newC)
                WHEN @month_OfClass IN (4,5,6) THEN
                    (SELECT dbo.update_FinalSession(newC.First_Session, CONCAT(YEAR(newC.First_Session),'-06-30'))
                    FROM inserted newC) 
                WHEN @month_OfClass IN (7,8,9) THEN 
                    (SELECT dbo.update_FinalSession(newC.First_Session, CONCAT(YEAR(newC.First_Session),'-09-30'))
                    FROM inserted newC) 
                WHEN @month_OfClass IN (10,11,12) THEN 
                    (SELECT dbo.update_FinalSession(newC.First_Session, CONCAT(YEAR(newC.First_Session),'-12-31'))
                    FROM inserted newC) 
            END),
        c_DayOfClass = (SELECT DATENAME(WEEKDAY,First_Session) FROM inserted)
    WHERE Class_ID = (SELECT newC.Class_ID FROM inserted newC);
    
    IF(NOT EXISTS(SELECT * FROM Class C JOIN inserted newC ON newC.Class_ID = C.Class_ID
        WHERE DATEDIFF(MINUTE, 0, C.c_TimeOfClass) % DATEDIFF(MINUTE, 0, '00:30:00') = 0 ))
        ROLLBACK TRAN
    IF((SELECT c_StudentID FROM Class C WHERE C.Class_ID = @classId) IS NULL
                AND DATEDIFF(WEEK, (SELECT Final_Session FROM Class C WHERE C.Class_ID = @classId), GETDATE()) >= 0)
        ROLLBACK TRAN
    EXEC check_DuplicateTimeInstructor;
    EXEC check_DuplicateTimeStudent;
    EXEC update_RemainingSession @classId;
    EXEC update_Eligibility @classId;
END;


GO
CREATE OR ALTER TRIGGER update_LearnTeaches ON Class
AFTER INSERT, DELETE
AS
BEGIN  
    UPDATE Is_Learning
    SET Learning_Time = (SELECT DATEDIFF(MONTH, (SELECT MIN(C.First_Session)
            From Class C
            WHERE C.c_StudentID IN (
                SELECT c_StudentID FROM inserted
                UNION ALL
                SELECT c_StudentID FROM deleted)
            AND C.c_InstrumentID IN (
                SELECT c_InstrumentID FROM inserted
                UNION ALL
                SELECT c_InstrumentID FROM deleted))
            , GETDATE()))
    WHERE l_StudentID IN (
        SELECT c_StudentID FROM inserted
        UNION ALL
        SELECT c_StudentID FROM deleted)
    AND l_InstrumentID IN (
        SELECT c_InstrumentID FROM inserted
        UNION ALL
        SELECT c_InstrumentID FROM deleted)

    UPDATE Teaches
    SET Teaching_Time = (SELECT DATEDIFF(MONTH, (SELECT MIN(C.First_Session)
            From Class C
            WHERE C.c_InstructorID IN (
                SELECT c_InstructorID FROM inserted
                UNION ALL
                SELECT c_InstructorID FROM deleted)
            AND C.c_InstrumentID IN (
                SELECT c_InstrumentID FROM inserted
                UNION ALL
                SELECT c_InstrumentID FROM deleted))
            , GETDATE()))
    WHERE t_InstructorID IN (
        SELECT c_InstructorID FROM inserted
        UNION ALL
        SELECT c_InstructorID FROM deleted)
     AND t_InstrumentID IN (
        SELECT c_InstrumentID FROM inserted
        UNION ALL
        SELECT c_InstrumentID FROM deleted)
END;


GO
CREATE OR ALTER TRIGGER NewValue_Student ON Class
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @Student_Id BIGINT;
    SET @Student_Id = (SELECT newC.c_StudentID FROM inserted newC)
    DECLARE @Instrument_ID BIGINT;
    SET @Instrument_ID = (SELECT newC.c_InstrumentID FROM inserted newC)
    IF(@Student_Id IS NOT NULL AND 
        NOT EXISTS(SELECT * FROM Is_Learning 
            WHERE l_StudentID = @Student_Id AND l_InstrumentID = @Instrument_ID ))  
    BEGIN
        insert into Is_Learning(l_StudentID, l_InstrumentID) values (@Student_Id, @Instrument_ID)
    END
    UPDATE Is_Learning 
    SET Learning_Time = 
        (SELECT CASE
        WHEN DATEDIFF(MONTH, 
            (SELECT MIN(C.First_Session)
            From Class C
            WHERE C.c_StudentID = @Student_Id
                AND C.c_InstrumentID = @Instrument_ID)
            , GETDATE()) >= 0 
        THEN DATEDIFF(MONTH, 
            (SELECT MIN(C.First_Session)
            From Class C
            WHERE C.c_StudentID = @Student_Id
                AND C.c_InstrumentID = @Instrument_ID)
            , GETDATE())
            ELSE 0 END)
    WHERE l_StudentID = @Student_Id
        AND l_InstrumentID = @Instrument_ID
    UPDATE Class
    SET c_Eligibility = 0
    WHERE c_StudentID IS NOT NULL AND Class_ID IN (SELECT newC.Class_ID FROM inserted newC)
END;


GO
CREATE OR ALTER TRIGGER NewValue_Instructor ON Class
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @Instructor_ID BIGINT;
    SET @Instructor_ID = (SELECT newC.c_InstructorID FROM inserted newC)
    DECLARE @Instrument_ID BIGINT;
    SET @Instrument_ID = (SELECT newC.c_InstrumentID FROM inserted newC)
    DECLARE @Institute_ID BIGINT;
    SET @Institute_ID = (SELECT newC.c_InstituteID FROM inserted newC)
    IF(NOT EXISTS(SELECT * FROM Is_MemberOf 
            WHERE m_InstructorID IN (SELECT newC.c_InstructorID FROM inserted newC)
            AND m_InstituteID IN (SELECT newC.c_InstituteID FROM inserted newC) ))  
    BEGIN
        insert into Is_MemberOf(m_InstructorID, m_InstituteID)
        (SELECT newC.c_InstructorID, newC.c_InstituteID FROM inserted newC)
    END
    IF(NOT EXISTS(SELECT * FROM Teaches 
            WHERE t_InstructorID = (SELECT newC.c_InstructorID FROM inserted newC)
            AND t_InstrumentID = (SELECT newC.c_InstrumentID FROM inserted newC) ))  
    BEGIN
        insert into Teaches(t_InstructorID, t_InstrumentID)
        (SELECT newC.c_InstructorID, newC.c_InstrumentID FROM inserted newC)
    END
    UPDATE Teaches 
    SET Teaching_Time = 
        (SELECT CASE
        WHEN DATEDIFF(MONTH, 
            (SELECT MIN(C.First_Session)
            From Class C
            WHERE C.c_InstructorID = @Instructor_ID
                AND C.c_InstrumentID = @Instrument_ID)
            , GETDATE()) >= 0 
            THEN DATEDIFF(MONTH, 
                (SELECT MIN(C.First_Session)
                From Class C
                WHERE C.c_InstructorID = @Instructor_ID
                    AND C.c_InstrumentID = @Instrument_ID)
            , GETDATE())
        ELSE 0 END)
    WHERE t_InstructorID = @Instructor_ID
        AND t_InstrumentID = @Instrument_ID
END;


GO 
CREATE OR ALTER TRIGGER update_Class_OnDelete ON Class
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;
    IF(EXISTS(SELECT Learning_Time FROM Is_Learning INNER JOIN
        deleted d ON l_StudentID = d.c_StudentID AND l_InstrumentID = d.c_InstrumentID 
        WHERE Learning_Time IS NULL))
    BEGIN
        DELETE Is_Learning
        FROM Is_Learning INNER JOIN
        deleted d ON l_StudentID = d.c_StudentID AND l_InstrumentID = d.c_InstrumentID; 
    END
    IF(EXISTS(SELECT Teaching_Time FROM Teaches INNER JOIN
        deleted d ON t_InstructorID = d.c_InstructorID AND t_InstrumentID = d.c_InstrumentID
        WHERE Teaching_Time IS NULL))
    BEGIN
        DELETE Teaches
        FROM Teaches INNER JOIN
        deleted d ON t_InstructorID = d.c_InstructorID AND t_InstrumentID = d.c_InstrumentID; 
    END
    IF(NOT EXISTS(SELECT * FROM Class C INNER JOIN deleted d
    ON C.c_InstructorID = d.c_InstructorID AND C.c_InstituteID = d.c_InstituteID))
    BEGIN
        DELETE Is_MemberOf
        FROM Is_MemberOf INNER JOIN
        deleted d ON m_InstructorID = d.c_InstructorID AND m_InstituteID = d.c_InstituteID;
    END
END;


--TRIGGER For Is_StudiedIn
GO
CREATE OR ALTER TRIGGER check_InstrumentOfClass on Is_StudiedIn
AFTER INSERT
AS
BEGIN
    IF( NOT EXISTS(SELECT * FROM Class C
        JOIN inserted i ON i.s_ClassID = C.Class_ID 
        JOIN Educational_Book E ON i.s_BookID = E.Book_ID
        WHERE C.c_InstrumentID = E.b_InstrumentID))
        ROLLBACK TRAN
END;