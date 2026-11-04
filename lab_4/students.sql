-- ============================================
-- DBMS LAB 4 - COLLEGE DATABASE
-- ============================================

-- CREATE DATABASE
DROP DATABASE IF EXISTS CollegeDB;
CREATE DATABASE CollegeDB;
USE CollegeDB;


-- ============================================
-- CREATE TABLES
-- ============================================

CREATE TABLE STUDENT (
    USN VARCHAR(20) PRIMARY KEY,
    SName VARCHAR(50),
    Address VARCHAR(100),
    Phone VARCHAR(15),
    Gender CHAR(1)
);

CREATE TABLE SEMSEC (
    SSID INT AUTO_INCREMENT PRIMARY KEY,
    Sem INT,
    Sec CHAR(1)
);

CREATE TABLE CLASS (
    USN VARCHAR(20),
    SSID INT,
    PRIMARY KEY (USN, SSID),
    FOREIGN KEY (USN) REFERENCES STUDENT(USN),
    FOREIGN KEY (SSID) REFERENCES SEMSEC(SSID)
);

CREATE TABLE SUBJECT (
    Subcode VARCHAR(10) PRIMARY KEY,
    Title VARCHAR(100),
    Sem INT,
    Credits INT
);

CREATE TABLE IAMARKS (
    USN VARCHAR(20),
    Subcode VARCHAR(10),
    SSID INT,
    Test1 INT,
    Test2 INT,
    Test3 INT,
    FinalIA DECIMAL(5,2),
    PRIMARY KEY (USN, Subcode),
    FOREIGN KEY (USN) REFERENCES STUDENT(USN),
    FOREIGN KEY (Subcode) REFERENCES SUBJECT(Subcode),
    FOREIGN KEY (SSID) REFERENCES SEMSEC(SSID)
);


-- ============================================
-- INSERT VALUES
-- ============================================

-- STUDENT
INSERT INTO STUDENT VALUES
('01JSTIS001', 'Akash', 'Mysuru', '9876543210', 'M'),
('01JSTIS002', 'Rahul', 'Bengaluru', '9876543211', 'M'),
('01JSTIS003', 'Priya', 'Mysuru', '9876543212', 'F'),
('01JSTIS004', 'Arjun', 'Hassan', '9876543213', 'M'),
('01JSTIS005', 'Sneha', 'Mandya', '9876543214', 'F'),
('01JSTIS006', 'Kiran', 'Mysuru', '9876543215', 'M'),
('01JSTIS007', 'Divya', 'Bengaluru', '9876543216', 'F');


-- SEMSEC
INSERT INTO SEMSEC (Sem, Sec) VALUES
(5, 'A'),
(5, 'B'),
(8, 'A'),
(8, 'B'),
(8, 'C');


-- CLASS
INSERT INTO CLASS VALUES
('01JSTIS001', 1),
('01JSTIS002', 2),
('01JSTIS003', 2),
('01JSTIS004', 3),
('01JSTIS005', 3),
('01JSTIS006', 4),
('01JSTIS007', 5);


-- SUBJECT
INSERT INTO SUBJECT VALUES
('CS501', 'DBMS', 5, 4),
('CS502', 'CN', 5, 4),
('CS801', 'AI', 8, 4);


-- IAMARKS
INSERT INTO IAMARKS
(USN, Subcode, SSID, Test1, Test2, Test3, FinalIA) VALUES
('01JSTIS001', 'CS501', 1, 16, 18, 17, 0),
('01JSTIS001', 'CS502', 1, 15, 17, 16, 0),
('01JSTIS002', 'CS501', 2, 18, 17, 19, 0),
('01JSTIS003', 'CS501', 2, 12, 14, 13, 0),
('01JSTIS004', 'CS801', 3, 18, 19, 17, 0),
('01JSTIS005', 'CS801', 3, 14, 15, 13, 0),
('01JSTIS006', 'CS801', 4, 10, 11, 9, 0),
('01JSTIS007', 'CS801', 5, 19, 18, 20, 0);


-- ============================================
-- DISPLAY TABLES
-- ============================================

SELECT * FROM STUDENT;
SELECT * FROM SEMSEC;
SELECT * FROM CLASS;
SELECT * FROM SUBJECT;
SELECT * FROM IAMARKS;


-- ============================================
-- Q1. STUDENTS IN 5TH SEMESTER B SECTION
-- ============================================

SELECT S.*
FROM STUDENT S
JOIN CLASS C ON S.USN = C.USN
JOIN SEMSEC SS ON C.SSID = SS.SSID
WHERE SS.Sem = 5 AND SS.Sec = 'B';


-- ============================================
-- Q2. MALE AND FEMALE STUDENT COUNT
-- IN EACH SEMESTER AND SECTION
-- ============================================

SELECT SS.Sem, SS.Sec, S.Gender,
       COUNT(*) AS Total_Students
FROM STUDENT S
JOIN CLASS C ON S.USN = C.USN
JOIN SEMSEC SS ON C.SSID = SS.SSID
GROUP BY SS.Sem, SS.Sec, S.Gender
ORDER BY SS.Sem, SS.Sec, S.Gender;


-- ============================================
-- Q3. VIEW OF EVENT 1 MARKS
-- ============================================

CREATE VIEW Event1_Marks AS
SELECT S.USN, S.SName, SUB.Subcode,
       SUB.Title, I.Test1 AS Event1_Marks
FROM STUDENT S
JOIN IAMARKS I ON S.USN = I.USN
JOIN SUBJECT SUB ON I.Subcode = SUB.Subcode
WHERE S.USN = '01JSTIS001';

SELECT * FROM Event1_Marks;


-- ============================================
-- Q4. CALCULATE AND UPDATE FINAL IA
-- AVERAGE OF BEST TWO TEST MARKS
-- ============================================

UPDATE IAMARKS
SET FinalIA = (
    GREATEST(Test1, Test2) +
    GREATEST(LEAST(Test1, Test2), Test3)
) / 2;

SELECT * FROM IAMARKS;


-- ============================================
-- Q5. CATEGORIZE 8TH SEMESTER STUDENTS
-- ============================================

SELECT S.USN, S.SName, S.Address, S.Phone,
       S.Gender, SS.Sem, SS.Sec, I.FinalIA,
       CASE
           WHEN I.FinalIA BETWEEN 17 AND 20
               THEN 'Outstanding'
           WHEN I.FinalIA BETWEEN 12 AND 16
               THEN 'Average'
           WHEN I.FinalIA < 12
               THEN 'Weak'
       END AS CAT
FROM STUDENT S
JOIN CLASS C ON S.USN = C.USN
JOIN SEMSEC SS ON C.SSID = SS.SSID
JOIN IAMARKS I ON S.USN = I.USN AND C.SSID = I.SSID
WHERE SS.Sem = 8
AND SS.Sec IN ('A', 'B', 'C')
ORDER BY SS.Sec, S.USN;
