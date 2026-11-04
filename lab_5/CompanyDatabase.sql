```sql
-- ============================================
-- DBMS LAB 5 - COMPANY DATABASE
-- ============================================

-- CREATE DATABASE
DROP DATABASE IF EXISTS CompanyDB;
CREATE DATABASE CompanyDB;
USE CompanyDB;


-- ============================================
-- CREATE TABLES
-- ============================================

CREATE TABLE DEPARTMENT (
    DNo INT AUTO_INCREMENT PRIMARY KEY,
    DName VARCHAR(50),
    MgrSSN VARCHAR(12),
    MgrStartDate DATE
);

CREATE TABLE EMPLOYEE (
    SSN VARCHAR(12) PRIMARY KEY,
    Name VARCHAR(100),
    Address VARCHAR(100),
    Sex CHAR(1),
    Salary DECIMAL(12,2),
    SuperSSN VARCHAR(12),
    DNo INT,
    FOREIGN KEY (DNo) REFERENCES DEPARTMENT(DNo),
    FOREIGN KEY (SuperSSN) REFERENCES EMPLOYEE(SSN)
);

ALTER TABLE DEPARTMENT
ADD FOREIGN KEY (MgrSSN) REFERENCES EMPLOYEE(SSN);

CREATE TABLE DLOCATION (
    DNo INT,
    DLoc VARCHAR(50),
    PRIMARY KEY (DNo, DLoc),
    FOREIGN KEY (DNo) REFERENCES DEPARTMENT(DNo)
);

CREATE TABLE PROJECT (
    PNo INT AUTO_INCREMENT PRIMARY KEY,
    PName VARCHAR(100),
    PLocation VARCHAR(50),
    DNo INT,
    FOREIGN KEY (DNo) REFERENCES DEPARTMENT(DNo)
);

CREATE TABLE WORKS_ON (
    SSN VARCHAR(12),
    PNo INT,
    Hours DECIMAL(5,2),
    PRIMARY KEY (SSN, PNo),
    FOREIGN KEY (SSN) REFERENCES EMPLOYEE(SSN),
    FOREIGN KEY (PNo) REFERENCES PROJECT(PNo)
);


-- ============================================
-- INSERT VALUES
-- ============================================

-- DEPARTMENT
INSERT INTO DEPARTMENT (DName) VALUES
('Accounts'),
('Research'),
('IT');


-- EMPLOYEE
INSERT INTO EMPLOYEE VALUES
('E001', 'John Scott', 'Mysuru', 'M', 800000, NULL, 1),
('E002', 'Alice Brown', 'Bengaluru', 'F', 650000, 'E001', 1),
('E003', 'David Miller', 'Mysuru', 'M', 550000, 'E001', 1),
('E004', 'Priya Sharma', 'Mandya', 'F', 700000, 'E001', 1),
('E005', 'Rohan Kumar', 'Bengaluru', 'M', 450000, 'E001', 1),
('E006', 'Sneha Rao', 'Hassan', 'F', 620000, 'E001', 1),
('E007', 'Michael Scott', 'Mysuru', 'M', 900000, NULL, 2),
('E008', 'Arjun Nair', 'Mysuru', 'M', 500000, NULL, 3);


-- DEPARTMENT MANAGERS
UPDATE DEPARTMENT SET
MgrSSN = 'E001', MgrStartDate = '2023-01-01'
WHERE DNo = 1;

UPDATE DEPARTMENT SET
MgrSSN = 'E007', MgrStartDate = '2022-06-01'
WHERE DNo = 2;

UPDATE DEPARTMENT SET
MgrSSN = 'E008', MgrStartDate = '2024-01-01'
WHERE DNo = 3;


-- DLOCATION
INSERT INTO DLOCATION VALUES
(1, 'Mysuru'),
(1, 'Bengaluru'),
(2, 'Mysuru'),
(3, 'Bengaluru');


-- PROJECT
INSERT INTO PROJECT (PName, PLocation, DNo) VALUES
('Payroll', 'Mysuru', 1),
('Accounts Automation', 'Bengaluru', 1),
('IoT', 'Mysuru', 2),
('Website Development', 'Bengaluru', 3);


-- WORKS_ON
INSERT INTO WORKS_ON VALUES
('E001', 1, 10),
('E001', 2, 12),
('E001', 3, 5),
('E002', 1, 8),
('E003', 1, 6),
('E004', 2, 8),
('E005', 1, 5),
('E006', 2, 7),
('E007', 3, 12),
('E008', 4, 15);


-- ============================================
-- DISPLAY TABLES
-- ============================================

SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;
SELECT * FROM DLOCATION;
SELECT * FROM PROJECT;
SELECT * FROM WORKS_ON;


-- ============================================
-- Q1. PROJECTS INVOLVING EMPLOYEE SCOTT
-- AS WORKER OR DEPARTMENT MANAGER
-- ============================================

SELECT DISTINCT P.PNo
FROM PROJECT P
JOIN WORKS_ON W ON P.PNo = W.PNo
JOIN EMPLOYEE E ON W.SSN = E.SSN
WHERE E.Name LIKE '%Scott'

UNION

SELECT DISTINCT P.PNo
FROM PROJECT P
JOIN DEPARTMENT D ON P.DNo = D.DNo
JOIN EMPLOYEE E ON D.MgrSSN = E.SSN
WHERE E.Name LIKE '%Scott';


-- ============================================
-- Q2. 10 PERCENT SALARY INCREASE
-- FOR EMPLOYEES WORKING ON IOT PROJECT
-- ============================================

SELECT DISTINCT E.SSN, E.Name,
       E.Salary AS CurrentSalary,
       ROUND(E.Salary * 1.10, 2) AS RevisedSalary
FROM EMPLOYEE E
JOIN WORKS_ON W ON E.SSN = W.SSN
JOIN PROJECT P ON W.PNo = P.PNo
WHERE P.PName = 'IoT';


-- ============================================
-- Q3. SALARY DETAILS OF ACCOUNTS DEPARTMENT
-- ============================================

SELECT SUM(E.Salary) AS TotalSalary,
       MAX(E.Salary) AS MaximumSalary,
       MIN(E.Salary) AS MinimumSalary,
       ROUND(AVG(E.Salary), 2) AS AverageSalary
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DNo = D.DNo
WHERE D.DName = 'Accounts';


-- ============================================
-- Q4. EMPLOYEES WORKING ON ALL PROJECTS
-- CONTROLLED BY THEIR OWN DEPARTMENT
-- ============================================

SELECT E.Name
FROM EMPLOYEE E
WHERE EXISTS (
    SELECT 1
    FROM PROJECT P
    WHERE P.DNo = E.DNo
)
AND NOT EXISTS (
    SELECT 1
    FROM PROJECT P
    WHERE P.DNo = E.DNo
    AND NOT EXISTS (
        SELECT 1
        FROM WORKS_ON W
        WHERE W.SSN = E.SSN
        AND W.PNo = P.PNo
    )
);


-- ============================================
-- Q5. DEPARTMENTS WITH MORE THAN 5 EMPLOYEES
-- COUNT EMPLOYEES EARNING ABOVE 600000
-- ============================================

SELECT D.DNo,
       COUNT(CASE WHEN E.Salary > 600000
                  THEN 1 END) AS EmployeesAbove600000
FROM DEPARTMENT D
JOIN EMPLOYEE E ON D.DNo = E.DNo
WHERE NOT EXISTS (
    SELECT 1
    FROM EMPLOYEE E2
    WHERE E2.DNo = D.DNo
    GROUP BY E2.DNo
    HAVING COUNT(*) <= 5
)
GROUP BY D.DNo
ORDER BY D.DNo;
```
