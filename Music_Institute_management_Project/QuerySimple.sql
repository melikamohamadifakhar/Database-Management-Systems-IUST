--Query Number 15
--Tedad class haye har amouzeshgah
SELECT Ie.Institute_Name [Institute],
    COUNT(*) [Number Of Class]
FROM Institute Ie JOIN Class C
ON C.c_InstituteID = Ie.Institute_ID
GROUP BY C.c_InstituteID, Ie.Institute_Name 


--Query Number 16
-- Ghadimi Tarin Honarjoo ha
SELECT CONCAT(p.p_First_Name, ' ', p.p_Last_Name) [Student Name],
    It.Instrument_Name [Instrument] ,
    Il.Learning_Time [Learning Time(in month)]
FROM Is_Learning Il JOIN Instrument It
ON Il.l_InstrumentID = It.Instrument_ID
JOIN Student S ON Il.l_StudentID = S.Student_ID
JOIN Person P ON P.P_ID = S.s_PersonID
WHERE Il.Learning_Time = (SELECT MAX(Learning_Time) FROM Is_Learning)


--Query Number 17 
-- Honar Jooyani ke Bishtar az 3 ta saz Baladan
SELECT CONCAT(P.p_First_Name, ' ', p.p_Last_Name) [Student Name]
FROM Student S JOIN Person P
ON S.s_PersonID = p.P_ID
WHERE S.Student_ID IN 
    (SELECT l_StudentID
    FROM Is_Learning l 
    GROUP BY l_StudentID
    HAVING COUNT(*) > 3) 

--Query Number 18
--Mahboob tarin saz ta alan (Class Haye Null hesab nistan)
SELECT I.Instrument_Name [Instrument], 
    COUNT(*) [Number Of Classes]
FROM Instrument I JOIN Class C 
ON I.Instrument_ID = C.c_InstrumentID
WHERE C.c_StudentID IS NOT NULL
GROUP BY I.Instrument_Name
HAVING COUNT(*) > ALL (
    SELECT COUNT(*) 
    FROM Is_Learning 
    GROUP BY l_InstrumentID)

--Query Number 19
-- Amouzeshgah haei ke hameye saz ha ro tadris nemikonand
(SELECT Institute_ID FROM Institute)
EXCEPT
(
    SELECT Ie.Institute_ID
    FROM Institute Ie 
    WHERE NOT EXISTS (
    (Select Instrument_Id FROM Instrument)
    EXCEPT
    (SELECT It.Instrument_ID
    FROM Class C JOIN Instrument It 
    ON It.Instrument_ID = C.c_InstrumentID
    WHERE  C.c_InstituteId = Ie.Institute_ID)
    )
)
--KOMAKI Query 19
-- SELECT Ie.Institute_Name [Institute],
--     COUNT(*) [Number Of Class] , IT.Instrument_ID
-- FROM Institute Ie JOIN Class C
-- ON C.c_InstituteID = Ie.Institute_ID
-- JOIN Instrument It ON C.c_InstrumentID = It.INstrument_ID
-- GROUP BY C.c_InstituteID, Ie.Institute_Name, It.Instrument_ID

--Query Number 20
--Class Haei ke hameye ketab haye saz marboote dar an tadris shode
SELECT C.Class_ID
FROM Class C JOIN Is_StudiedIn S ON s.s_ClassID = C.Class_ID
GROUP BY C.Class_ID, C.c_InstrumentID
HAVING COUNT(*) = 
    (SELECT COUNT(*) 
    FROM Educational_Book B 
    WHERE C.c_InstrumentID = B.b_InstrumentID 
    GROUP BY B.b_InstrumentID)