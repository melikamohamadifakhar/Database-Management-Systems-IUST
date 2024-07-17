--CREATE DATABASE MusicInstitute
--Create Table (Entity Person)
CREATE TABLE Person(
    p_ID BIGINT,
    p_SSN NVARCHAR(10) NOT NULL UNIQUE,
    p_First_Name NVARCHAR(15) NOT NULL, 
    p_Last_Name NVARCHAR(25) NOT NULL,
    p_Father_Name NVARCHAR(15) NOT NULL,
    --Constraint In Trigger
    p_Phone_Number NVARCHAR(11) NOT NULL,   
    p_Birth_Date DATE NOT NULL,
    p_Birth_Place NVARCHAR(15) NOT NULL,
    --Constraint In ADD
    p_Email NVARCHAR(MAX),
    p_Address NVARCHAR(MAX),--Delete LATER
    --Constraint In ADD
    p_LevelOf_Education NVARCHAR(MAX) NOT NULL,
    CONSTRAINT cons_SSN CHECK(p_SSN LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    PRIMARY KEY(p_ID)
)
--Specialization
--Create Table (SubEntity Student)
CREATE TABLE Student(
	s_PersonID BIGINT NOT NULL,
	Student_ID BIGINT,
    PRIMARY KEY(Student_ID),
	FOREIGN KEY (s_PersonID) REFERENCES Person(p_ID) ON DELETE CASCADE
)
--Specialization
--Create Table (SubEntity Instructor)
CREATE TABLE Instructor(
	i_PersonID BIGINT NOT NULL,
	Instructor_ID BIGINT,
    PRIMARY KEY(Instructor_ID),
	FOREIGN KEY (i_PersonID) REFERENCES Person(p_ID) ON DELETE CASCADE
)
--Create Table (Entity Instrument)
CREATE TABLE Instrument(
    Instrument_ID BIGINT,
    Instrument_Name NVARCHAR(30) UNIQUE,
    TypesOf_Instrument NVARCHAR(15),
    CONSTRAINT cons_TypInstrument CHECK(TypesOf_Instrument IN ('Percussion','Wind','String', 'Keyboard')),   
    PRIMARY KEY(Instrument_ID)
)
--Create Table (Entity Institute)
CREATE TABLE Institute(
	Institute_ID BIGINT,
	Institute_Name NVARCHAR(20) NOT NULL,
	Institute_Address NVARCHAR(MAX),
	Institute_Founder NVARCHAR(40) NOT NULL,
    PRIMARY KEY(Institute_ID)
)
--Create Table (Entity Educational_Book)
CREATE TABLE Educational_Book(
	Book_ID BIGINT,
	Book_Name NVARCHAR(15) NOT NULL,
	Book_Price BIGINT NOT NULL,
	Book_Author NVARCHAR(40) NOT NULL,
	Book_Publisher NVARCHAR(20) NOT NULL,
	Book_Circulation BIGINT,
    b_InstrumentID BIGINT NOT NULL,
    FOREIGN KEY (b_InstrumentID) REFERENCES Instrument(Instrument_ID) ON DELETE NO ACTION,
    CONSTRAINT cons_BookCirc CHECK(Book_Circulation >= 1),
    PRIMARY KEY(Book_ID)
)
--Create Table (Relation between Instructor and institute)
CREATE TABLE Is_MemberOf(
	m_InstructorID BIGINT NOT NULL,
	m_InstituteID BIGINT NOT NULL,
	FOREIGN KEY (m_InstructorID) REFERENCES Instructor(Instructor_ID) ON DELETE CASCADE,
	FOREIGN KEY (m_InstituteID) REFERENCES Institute(Institute_ID) ON DELETE CASCADE,
    PRIMARY KEY(m_InstituteID,m_InstructorID)
)
--Create Table (Entity class)
CREATE TABLE Class(
    Class_ID BIGINT,
	c_InstrumentID BIGINT NOT NULL,
	c_StudentID BIGINT,
	c_InstructorID BIGINT NOT NULL,
	c_InstituteId BIGINT NOT NULL,
    c_TermSeason NVARCHAR(10),
    c_TermYear INT,
    --StartSession and FinalSession in Add Column
    c_TimeOfClass TIME NOT NULL,-- in add constraint
    c_DayOfClass NVARCHAR(30),-- in add constraint
    c_Eligibility INT,-- in add constraint 1 or 0 date current > finalsession => 0
    c_RemainingSession INT,
    CONSTRAINT cons_Season CHECK(c_TermSeason IN ('Spring', 'Summer', 'Fall', 'Winter')),
    CONSTRAINT cons_TimeClass CHECK(c_TimeOfClass BETWEEN '08:30:00' AND '20:30:00'),
    CONSTRAINT cons_RemainSession CHECK (c_RemainingSession BETWEEN -1 AND 13),--Update CONSTRAINT,
    FOREIGN KEY(c_InstrumentID) REFERENCES Instrument(Instrument_ID) ON DELETE NO ACTION,
    FOREIGN KEY(c_StudentID) REFERENCES Student(Student_ID) ON DELETE NO ACTIOn,
    FOREIGN KEY(c_InstructorID) REFERENCES Instructor(Instructor_ID) ON DELETE NO ACTION,
    FOREIGN KEY(c_InstituteId) REFERENCES Institute(Institute_ID) ON DELETE NO ACTION,
    PRIMARY KEY (Class_ID)
)
--Create Table (Relation between edu_book and Class)
CREATE TABLE Is_StudiedIn(
	s_ClassID BIGINT NOT NULL,
	s_BookID BIGINT NOT NULL,
	FOREIGN KEY (s_BookID) REFERENCES Educational_Book(Book_ID) ON DELETE CASCADE,
	FOREIGN KEY (s_ClassID) REFERENCES Class(Class_ID) ON DELETE CASCADE,
    PRIMARY KEY(s_ClassID,s_BookID)
)   
--Create Table (Relation between instructor and instrument)
CREATE TABLE Teaches(
	t_InstructorID BIGINT NOT NULL,
	t_InstrumentID BIGINT NOT NULL,
    Teaching_Time BIGINT,--in month
	FOREIGN KEY (t_InstructorID) REFERENCES Instructor(Instructor_ID) ON DELETE CASCADE,
	FOREIGN KEY (t_InstrumentID) REFERENCES Instrument(Instrument_ID) ON DELETE CASCADE,
    PRIMARY KEY(t_InstructorID,t_InstrumentID)
)
--Create Table (Relation between student and instrument)
CREATE TABLE Is_Learning(
	l_StudentID BIGINT NOT NULL,
	l_InstrumentID BIGINT NOT NULL,
    Learning_Time BIGINT,--in month
	FOREIGN KEY (l_StudentID) REFERENCES Student(Student_ID) ON DELETE CASCADE,
	FOREIGN KEY (l_InstrumentID) REFERENCES Instrument(Instrument_ID) ON DELETE CASCADE,
    PRIMARY KEY(l_StudentID,l_InstrumentID)
)   

------------------------------------
--ALTER TABLE ADD AND DROP IN COLUMN
------------------------------------

--Update Column of Table
ALTER TABLE Person
DROP COLUMN p_Address
GO
-- ALTER TABLE Person
-- ADD p_Address NVARCHAR(MAX)
-- GO
--Update Column of Table
ALTER TABLE Class
ADD First_Session DATE NOT NULL,
    Final_Session DATE
GO
ALTER TABLE Educational_Book
ADD Book_level NVARCHAR(MAX) NOT NULL
GO
--UPDATE TABLE (Data type)
ALTER TABLE Class
ALTER COLUMN c_Eligibility BIT NOT NULL
GO