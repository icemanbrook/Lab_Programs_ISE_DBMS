```sql
-- ============================================
-- DBMS LAB 5 - COMPANY DATABASE
-- ============================================

DROP DATABASE IF EXISTS CompanyDB;
CREATE DATABASE CompanyDB;
USE CompanyDB;


-- ============================================
-- 1. TABLE CREATION
-- ============================================

CREATE TABLE DEPARTMENT (
    DNo INT AUTO_INCREMENT PRIMARY KEY,
    DName VARCHAR(50) NOT NULL,
    MgrSSN VARCHAR(12),
    MgrStartDate DATE
);

CREATE TABLE EMPLOYEE (
    SSN VARCHAR(12) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Address VARCHAR(150),
    Sex CHAR(1),
    Salary DECIMAL(12,2),
    SuperSSN VARCHAR(12),
    DNo INT,
    FOREIGN KEY (DNo) REFERENCES DEPARTMENT(DNo),
    FOREIGN KEY (SuperSSN) REFERENCES EMPLOYEE(SSN)
);

-- Add the manager foreign key after EMPLOYEE exists.
ALTER TABLE DEPARTMENT
ADD CONSTRAINT fk_department_manager
FOREIGN KEY (MgrSSN) REFERENCES EMPLOYEE(SSN);

CREATE TABLE DLOCATION (
    DNo INT,
    DLoc VARCHAR(50),
    PRIMARY KEY (DNo, DLoc),
    FOREIGN KEY (DNo) REFERENCES DEPARTMENT(DNo)
);

CREATE TABLE PROJECT (
    PNo INT AUTO_INCREMENT PRIMARY KEY,
    PName VARCHAR(100) NOT NULL,
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
-- 2. INSERT DEPARTMENT DATA
-- ============================================

INSERT INTO DEPARTMENT (DName, MgrSSN, MgrStartDate)
VALUES
('Accounts', NULL, NULL),
('Research', NULL, NULL),
('IT', NULL, NULL);


-- ============================================
-- 3. INSERT EMPLOYEE DATA
-- ============================================

INSERT INTO EMPLOYEE
(SSN, Name, Address, Sex, Salary, SuperSSN, DNo)
VALUES
('E001', 'John Scott', 'Mysuru', 'M', 800000, NULL, 1),
('E002', 'Alice Brown', 'Bengaluru', 'F', 650000, 'E001', 1),
('E003', 'David Miller', 'Mysuru', 'M', 550000, 'E001', 1),
('E004', 'Priya Sharma', 'Mandya', 'F', 700000, 'E001', 1),
('E005', 'Rohan Kumar', 'Bengaluru', 'M', 450000, 'E001', 1),
('E006', 'Sneha Rao', 'Hassan', 'F', 620000, 'E001', 1),
('E007', 'Michael Scott', 'Mysuru', 'M', 900000, NULL, 2),
('E008', 'Neha Patil', 'Bengaluru', 'F', 750000, 'E007', 2),
('E009', 'Arjun Nair', 'Mysuru', 'M', 500000, 'E007', 3);

-- Set department managers.
UPDATE DEPARTMENT
SET MgrSSN = 'E001', MgrStartDate = '2023-01-01'
WHERE DNo = 1;

UPDATE DEPARTMENT
SET MgrSSN = 'E007', MgrStartDate = '2022-06-01'
WHERE DNo = 2;

UPDATE DEPARTMENT
SET MgrSSN = 'E009', MgrStartDate = '2024-01-01'
WHERE DNo = 3;


-- ============================================
-- 4. INSERT DEPARTMENT LOCATIONS
-- ============================================

INSERT INTO DLOCATION (DNo, DLoc)
VALUES
(1, 'Mysuru'),
(1, 'Bengaluru'),
(2, 'Bengaluru'),
(2, 'Mysuru'),
(3, 'Bengaluru');


-- ============================================
-- 5. INSERT PROJECT DATA
-- ============================================

INSERT INTO PROJECT (PName, PLocation, DNo)
VALUES
('Payroll', 'Mysuru', 1),
('Accounts Automation', 'Bengaluru', 1),
('IoT', 'Mysuru', 2),
('Website Development', 'Bengaluru', 3);


-- ============================================
-- 6. INSERT WORKS_ON DATA
-- ============================================

INSERT INTO WORKS_ON (SSN, PNo, Hours)
VALUES
('E001', 1, 10),
('E001', 2, 12),
('E001', 3, 5),

('E002', 1, 8),
('E002', 2, 10),

('E003', 1, 6),
('E004', 2, 8),
('E005', 1, 5),
('E006', 2, 7),

('E007', 3, 12),
('E007', 4, 8),
('E008', 3, 10),
('E009', 4, 15);


-- ============================================
-- 7. DISPLAY TABLE CONTENTS
-- ============================================

SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;
SELECT * FROM DLOCATION;
SELECT * FROM PROJECT;
SELECT * FROM WORKS_ON;


-- ============================================
-- QUERY 1
-- List project numbers for projects involving
-- an employee named Scott as a worker or as
-- manager of the department controlling the project.
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
-- QUERY 2
-- Show resulting salaries if every employee
-- working on the IoT project gets a 10% raise.
-- This query displays the revised salaries
-- without modifying the stored salaries.
-- ============================================

SELECT DISTINCT E.SSN,
       E.Name,
       E.Salary AS CurrentSalary,
       ROUND(E.Salary * 1.10, 2) AS RevisedSalary
FROM EMPLOYEE E
JOIN WORKS_ON W ON E.SSN = W.SSN
JOIN PROJECT P ON W.PNo = P.PNo
WHERE P.PName = 'IoT';


-- ============================================
-- QUERY 3
-- Find the sum, maximum, minimum and average
-- salary of employees in the Accounts department.
-- ============================================

SELECT D.DName,
       SUM(E.Salary) AS TotalSalary,
       MAX(E.Salary) AS MaximumSalary,
       MIN(E.Salary) AS MinimumSalary,
       ROUND(AVG(E.Salary), 2) AS AverageSalary
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DNo = D.DNo
WHERE D.DName = 'Accounts'
GROUP BY D.DNo, D.DName;


-- ============================================
-- QUERY 4
-- Retrieve employees who work on ALL projects
-- controlled by their own department.
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
-- QUERY 5
-- For every department with more than five
-- employees, display its department number
-- and the number of employees earning
-- more than Rs. 6,00,000.
-- Uses NOT EXISTS as required.
-- ============================================

SELECT D.DNo,
       COUNT(CASE
                 WHEN E.Salary > 600000 THEN 1
             END) AS EmployeesAbove600000
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