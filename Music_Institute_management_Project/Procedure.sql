--PROCEDURE For Triggers
GO 
CREATE OR ALTER PROCEDURE update_RemainingSession @idClass BIGINT
AS
BEGIN
    DECLARE @dateOf_First DATE;
    SET @dateOf_First = (SELECT First_Session FROM Class WHERE Class_ID = @idClass);
    DECLARE @dateOf_Final DATE;
    SET @dateOf_Final = (SELECT Final_Session FROM Class WHERE Class_ID = @idClass);
    IF( DATEDIFF(DAY, @dateOf_Final, CONVERT(date,GETDATE())) > 0)
    BEGIN
        UPDATE Class
        SET c_RemainingSession = 0
        WHERE Class_ID = @idClass;
    END
    IF( DATEDIFF(DAY, CONVERT(date,GETDATE()), @dateOf_Final) >= 0 AND DATEDIFF(DAY, @dateOf_First, CONVERT(date,GETDATE())) >= 0)
    BEGIN
        UPDATE Class
        SET c_RemainingSession = DATEDIFF(WEEK,
            CONVERT(date,GETDATE()), @dateOf_Final)
        WHERE Class_ID = @idClass;
        
    END
    IF( DATEDIFF(DAY, CONVERT(date,GETDATE()), @dateOf_First) > 0)
    BEGIN
        UPDATE Class
        SET c_RemainingSession = DATEDIFF(WEEK,
            @dateOf_First, @dateOf_Final)
        WHERE Class_ID = @idClass;
    END
END;


GO
CREATE OR ALTER PROCEDURE update_Eligibility @idClass BIGINT
AS
BEGIN
    DECLARE @First DATE;
    SET @First = (SELECT C.First_Session FROM Class C WHERE C.Class_ID = @idClass);
    DECLARE @Final DATE;
    SET @Final = (SELECT C.Final_Session FROM Class C WHERE C.Class_ID = @idClass);
    IF(((SELECT C.c_StudentID FROM Class C WHERE C.Class_ID = @idClass) IS NULL 
        AND ((DATEDIFF(DAY, GETDATE(), @First) >= 0) OR 
        (DATEDIFF(DAY, GETDATE(), @Final) > 0 AND DATEDIFF(DAY, @First, GETDATE()) >= 0))))
    BEGIN
        UPDATE Class
        SET c_Eligibility = 1
        WHERE Class_ID = @idClass;
    END
END;


GO
CREATE OR ALTER PROCEDURE check_DuplicateTimeInstructor
AS
BEGIN
    IF EXISTS 
       (
           SELECT * 
           FROM   Class c2
                  INNER JOIN Class c1 ON c2.c_InstructorID = c1.c_InstructorID
           WHERE  c2.Class_ID      <> c1.Class_ID
           AND    c2.c_DayOfClass  =  c1.c_DayOfClass 
           AND    c2.c_TermSeason  =  c1.c_TermSeason 
           AND    c2.c_TermYear    =  c1.c_TermYear 
           AND    c2.c_TimeOfClass =  c1.c_TimeOfClass
       )
   BEGIN
        ROLLBACK TRAN
   END
END;


GO
CREATE OR ALTER PROCEDURE check_DuplicateTimeStudent
AS
BEGIN
    IF EXISTS 
       (
           SELECT * 
           FROM   Class c2
                  INNER JOIN Class c1 ON c2.c_StudentID = c1.c_StudentID
           WHERE  c2.Class_ID      <> c1.Class_ID
           AND    c2.c_DayOfClass  =  c1.c_DayOfClass 
           AND    c2.c_TermSeason  =  c1.c_TermSeason 
           AND    c2.c_TermYear    =  c1.c_TermYear 
           AND    c2.c_TimeOfClass =  c1.c_TimeOfClass
       )
   BEGIN
        ROLLBACK TRAN
   END
END;