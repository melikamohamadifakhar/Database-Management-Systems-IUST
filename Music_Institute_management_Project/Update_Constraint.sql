-------------------------
--ADD AND DROP CONSTRAINT
-------------------------
--ADD Constraint
ALTER TABLE Person
ADD CONSTRAINT cons_lvlOfEdu CHECK(p_LevelOf_Education IN
    ('Elementary','High School','Diploma','Bachelor','Master','PHD')),
    CONSTRAINT cons_Email CHECK (p_Email LIKE '[A-Za-z]%@%.%'),
    CONSTRAINT cons_BirthDate CHECK(DATEDIFF(YEAR, p_Birth_Date, GETDATE()) >= 7)
GO
--ADD CONSTRAINT
ALTER TABLE Class
ADD CONSTRAINT cons_Elig CHECK(c_Eligibility = 0 OR c_Eligibility = 1),
    CONSTRAINT cons_dyOfClass CHECK(c_DayOfClass IN ('Monday', 'Tuesday', 'Wednesday',
    'Thursday', 'Friday', 'Saturday', 'Sunday')),
    CONSTRAINT cons_FirstFinal CHECK(First_Session < Final_Session)
GO

--Update Constraint (We have to drop and add CONSTRAINT)
--DROP CONTRAINT of Create Table
ALTER TABLE Class
DROP CONSTRAINT cons_RemainSession
GO
--ADD new CONSTRAINT for Class Table
ALTER TABLE Class
ADD CONSTRAINT cons_RemainSession CHECK(c_RemainingSession BETWEEN 0 AND 13)
GO

--Update Constraint (We have to drop and add CONSTRAINT)
--DROP CONTRAINT of Create Table
ALTER TABLE Instrument
DROP CONSTRAINT cons_TypInstrument
GO
--ADD new CONSTRAINT for Class Table
ALTER TABLE Instrument
ADD CONSTRAINT cons_TypInstrument CHECK(TypesOf_Instrument IN ('Percussion','Wind','String'))
GO


--DROP CONTRAINT of Create Table
ALTER TABLE Educational_Book
DROP CONSTRAINT cons_BookCirc
GO
ALTER TABLE Educational_Book
ADD CONSTRAINT cons_Booklvl CHECK (Book_level IN ('Beginner', 'Intermediate', 'Advanced'))
GO

ALTER TABLE Class
ADD CONSTRAINT c_Eligibility DEFAULT 0 FOR c_Eligibility
GO