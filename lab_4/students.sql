--Create DB
DROP DATABASE IF EXISTS CollegeDB;
CREATE DATABASE CollegeDB;
USE CollegeDB;

--Create table
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

--Insert values
INSERT INTO STUDENT (USN, SName, Address, Phone, Gender) VALUES
('01JSTIS001', 'Akash', 'Mysuru', '9876543210', 'M'),
('01JSTIS002', 'Rahul', 'Bengaluru', '9876543211', 'M'),
('01JSTIS003', 'Priya', 'Mysuru', '9876543212', 'F'),
('01JSTIS004', 'Sneha', 'Mandya', '9876543213', 'F'),
('01JSTIS005', 'Arjun', 'Hassan', '9876543214', 'M'),
('01JSTIS006', 'Ananya', 'Mysuru', '9876543215', 'F'),
('01JSTIS007', 'Vikas', 'Bengaluru', '9876543216', 'M'),
('01JSTIS008', 'Neha', 'Mysuru', '9876543217', 'F'),
('01JSTIS009', 'Kiran', 'Mandya', '9876543218', 'M'),
('01JSTIS010', 'Pooja', 'Mysuru', '9876543219', 'F'),
('01JSTIS011', 'Rohan', 'Hassan', '9876543220', 'M'),
('01JSTIS012', 'Divya', 'Bengaluru', '9876543221', 'F');

INSERT INTO SEMSEC (Sem, Sec) VALUES
(5, 'A'),
(5, 'B'),
(6, 'A'),
(6, 'B'),
(8, 'A'),
(8, 'B'),
(8, 'C');

INSERT INTO CLASS (USN, SSID) VALUES
('01JSTIS001', 1),
('01JSTIS002', 2),
('01JSTIS003', 2),
('01JSTIS004', 2),
('01JSTIS005', 3),
('01JSTIS006', 4),
('01JSTIS007', 5),
('01JSTIS008', 5),
('01JSTIS009', 6),
('01JSTIS010', 6),
('01JSTIS011', 7),
('01JSTIS012', 7);

INSERT INTO SUBJECT (Subcode, Title, Sem, Credits) VALUES
('CS501', 'Database Management Systems', 5, 4),
('CS502', 'Computer Networks', 5, 4),
('CS503', 'Operating Systems', 5, 4),
('CS504', 'Software Engineering', 5, 3),
('CS505', 'Web Technology', 5, 3),
('CS601', 'Machine Learning', 6, 4),
('CS602', 'Cloud Computing', 6, 4),
('CS801', 'Artificial Intelligence', 8, 4),
('CS802', 'Big Data Analytics', 8, 4),
('CS803', 'Cyber Security', 8, 4),
('CS804', 'Project Management', 8, 3);

INSERT INTO IAMARKS
(USN, Subcode, SSID, Test1, Test2, Test3, FinalIA) VALUES

('01JSTIS001', 'CS501', 1, 16, 18, 17, 0),
('01JSTIS001', 'CS502', 1, 15, 17, 16, 0),
('01JSTIS001', 'CS503', 1, 14, 16, 15, 0),
('01JSTIS002', 'CS501', 2, 18, 17, 19, 0),
('01JSTIS002', 'CS502', 2, 15, 14, 16, 0),
('01JSTIS003', 'CS501', 2, 12, 14, 13, 0),
('01JSTIS003', 'CS502', 2, 16, 15, 17, 0),
('01JSTIS004', 'CS501', 2, 10, 11, 9, 0),
('01JSTIS004', 'CS502', 2, 13, 12, 14, 0);

INSERT INTO IAMARKS
(USN, Subcode, SSID, Test1, Test2, Test3, FinalIA) VALUES
('01JSTIS005', 'CS601', 3, 15, 17, 16, 0),
('01JSTIS005', 'CS602', 3, 14, 16, 15, 0),
('01JSTIS006', 'CS601', 4, 12, 13, 14, 0),
('01JSTIS006', 'CS602', 4, 10, 11, 12, 0);

INSERT INTO IAMARKS
(USN, Subcode, SSID, Test1, Test2, Test3, FinalIA) VALUES

('01JSTIS007', 'CS801', 5, 18, 19, 17, 0),
('01JSTIS007', 'CS802', 5, 17, 18, 19, 0),
('01JSTIS008', 'CS801', 5, 14, 15, 13, 0),
('01JSTIS008', 'CS802', 5, 12, 14, 13, 0),
('01JSTIS009', 'CS801', 6, 16, 17, 15, 0),
('01JSTIS009', 'CS802', 6, 15, 14, 16, 0),
('01JSTIS010', 'CS801', 6, 10, 11, 9, 0),
('01JSTIS010', 'CS802', 6, 12, 10, 11, 0),
('01JSTIS011', 'CS801', 7, 19, 18, 20, 0),
('01JSTIS011', 'CS802', 7, 18, 19, 17, 0),
('01JSTIS012', 'CS801', 7, 13, 14, 12, 0),
('01JSTIS012', 'CS802', 7, 11, 13, 12, 0);


--Queries
--Q1. List all student details studying in fifth semester 'B' section
SELECT S.*
FROM STUDENT S
JOIN CLASS C
ON S.USN = C.USN
JOIN SEMSEC SS
ON C.SSID = SS.SSID
WHERE SS.Sem = 5
AND SS.Sec = 'B';

--Q2. Total number of male and female students in each semester and section
SELECT SS.Sem,
       SS.Sec,
       S.Gender,
       COUNT(*) AS Total_Students
FROM STUDENT S
JOIN CLASS C
ON S.USN = C.USN
JOIN SEMSEC SS
ON C.SSID = SS.SSID
GROUP BY SS.Sem, SS.Sec, S.Gender
ORDER BY SS.Sem, SS.Sec, S.Gender;

--Q3. Create a view of Event 1 marks of student 01JSTIS001 in all subjects
CREATE VIEW Event1_Marks AS
SELECT S.USN,
       S.SName,
       SUB.Subcode,
       SUB.Title,
       I.Test1 AS Event1_Marks
FROM STUDENT S
JOIN IAMARKS I
ON S.USN = I.USN
JOIN SUBJECT SUB
ON I.Subcode = SUB.Subcode
WHERE S.USN = '01JSTIS001';

--Q4. Calculate Final IA and update the table
UPDATE IAMARKS
SET FinalIA = (
    GREATEST(Test1, Test2) +
    GREATEST(
        LEAST(Test1, Test2),
        Test3
    )
) / 2;

SELECT *
FROM IAMARKS;

--Q5. Categorize 8th semester A, B and C students
SELECT S.USN,
       S.SName,
       SS.Sem,
       SS.Sec,
       I.Subcode,
       I.FinalIA,
       CASE
           WHEN I.FinalIA >= 17 THEN 'Outstanding'
           WHEN I.FinalIA >= 12 THEN 'Average'
           ELSE 'Weak'
       END AS CAT
FROM STUDENT S
JOIN CLASS C
ON S.USN = C.USN
JOIN SEMSEC SS
ON C.SSID = SS.SSID
JOIN IAMARKS I
ON S.USN = I.USN
AND C.SSID = I.SSID
WHERE SS.Sem = 8
AND SS.Sec IN ('A', 'B', 'C')
ORDER BY SS.Sec, S.USN;