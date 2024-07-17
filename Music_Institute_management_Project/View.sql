--View 1
--Class Haye faale daraye honar joo 
GO
CREATE OR ALTER VIEW [Acitve Classes in This Term] AS
SELECT C.Class_ID [Class ID],
    CONCAT(P2.p_First_Name, ' ', P2.p_Last_Name) [Student],
    CONCAT(P1.p_First_Name, ' ', P1.p_Last_Name) [Instructor],
    I.Instrument_Name [Instrument],
    Ie.Institute_Name [Institute],
    C.c_RemainingSession [Remaining Session],
    CONCAT(C.c_DayOfClass , ' | ', C.c_TimeOfClass) [Day  Time],
    C.First_Session [Start At],
    C.Final_Session [Finish At]
FROM Class C JOIN Instrument I ON C.c_InstrumentID = I.Instrument_ID
JOIN Institute Ie ON C.c_InstituteID = Ie.Institute_ID
JOIN Instructor Ir ON Ir.Instructor_ID = C.c_InstructorID
JOIN Person P1 ON P1.P_ID = Ir.i_PersonID
JOIN Student S ON S.Student_ID = C.c_StudentID
JOIN Person P2 ON P2.P_ID = S.s_PersonID
WHERE c_StudentID IS NOT NULL 
    AND C.c_RemainingSession != 0 
    AND C.c_TermYear = YEAR(GETDATE())
    AND C.c_TermSeason = (
        SELECT CASE
        WHEN MONTH(GETDATE()) IN (1,2,3) THEN 'Winter'
        WHEN MONTH(GETDATE()) IN (4,5,6) THEN 'Spring'
        WHEN MONTH(GETDATE()) IN (7,8,9) THEN 'Summer'
        WHEN MONTH(GETDATE()) IN (10,11,12) THEN 'Fall'
        END
    )
GO

Select * FROM [Acitve Classes in This Term]


--View 2
--Class Haye Ghabele bardashte oon term
GO
CREATE OR ALTER VIEW [Available Classes in This Term] AS
SELECT C.Class_ID [Class ID],
    CONCAT(P1.p_First_Name, ' ', P1.p_Last_Name) [Instructor],
    I.Instrument_Name [Instrument],
    Ie.Institute_Name [Institute],
    C.c_RemainingSession [Remaining Session],
    CONCAT(C.c_DayOfClass , ' | ', C.c_TimeOfClass) [Day  Time],
    C.First_Session [Start At],
    C.Final_Session [Finish At]
FROM Class C JOIN Instrument I ON C.c_InstrumentID = I.Instrument_ID
JOIN Institute Ie ON C.c_InstituteID = Ie.Institute_ID
JOIN Instructor Ir ON Ir.Instructor_ID = C.c_InstructorID
JOIN Person P1 ON P1.P_ID = Ir.i_PersonID
WHERE c_StudentID IS NULL 
    AND C.c_Eligibility = 1 
    AND C.c_TermYear = YEAR(GETDATE())
    AND C.c_TermSeason = (
        SELECT CASE
        WHEN MONTH(GETDATE()) IN (1,2,3) THEN 'Winter'
        WHEN MONTH(GETDATE()) IN (4,5,6) THEN 'Spring'
        WHEN MONTH(GETDATE()) IN (7,8,9) THEN 'Summer'
        WHEN MONTH(GETDATE()) IN (10,11,12) THEN 'Fall'
        END
    )
GO


Select * FROM [Available Classes in This Term]