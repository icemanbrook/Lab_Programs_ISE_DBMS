-- ==========================================
-- DBMS LAB - MOVIE DATABASE
-- ==========================================

-- CREATE DATABASE
CREATE DATABASE MovieDB;
USE MovieDB;


-- ==========================================
-- TABLE CREATION
-- ==========================================

CREATE TABLE ACTOR (
    Act_id INT AUTO_INCREMENT PRIMARY KEY,
    Act_Name VARCHAR(50),
    Act_Gender CHAR(1)
);

CREATE TABLE DIRECTOR (
    Dir_id INT AUTO_INCREMENT PRIMARY KEY,
    Dir_Name VARCHAR(50),
    Dir_Phone VARCHAR(15)
);

CREATE TABLE MOVIES (
    Mov_id INT AUTO_INCREMENT PRIMARY KEY,
    Mov_Title VARCHAR(100),
    Mov_Year INT,
    Mov_Lang VARCHAR(30),
    Dir_id INT,
    FOREIGN KEY (Dir_id) REFERENCES DIRECTOR(Dir_id)
);

CREATE TABLE MOVIE_CAST (
    Act_id INT,
    Mov_id INT,
    Role VARCHAR(50),
    PRIMARY KEY (Act_id, Mov_id),
    FOREIGN KEY (Act_id) REFERENCES ACTOR(Act_id),
    FOREIGN KEY (Mov_id) REFERENCES MOVIES(Mov_id)
);

CREATE TABLE RATING (
    Mov_id INT,
    Rev_Stars INT,
    FOREIGN KEY (Mov_id) REFERENCES MOVIES(Mov_id)
);


-- ==========================================
-- INSERT DATA
-- ==========================================

INSERT INTO ACTOR (Act_Name, Act_Gender) VALUES
('Leonardo DiCaprio', 'M'),
('Tom Hanks', 'M'),
('Meryl Streep', 'F'),
('Brad Pitt', 'M'),
('Emma Stone', 'F'),
('Robert De Niro', 'M');

INSERT INTO DIRECTOR (Dir_Name, Dir_Phone) VALUES
('Hitchcock', '1111111111'),
('Steven Spielberg', '2222222222'),
('Christopher Nolan', '3333333333'),
('Martin Scorsese', '4444444444');

INSERT INTO MOVIES (Mov_Title, Mov_Year, Mov_Lang, Dir_id) VALUES
('Psycho', 1960, 'English', 1),
('Jaws', 1975, 'English', 2),
('Schindlers List', 1993, 'English', 2),
('Catch Me If You Can', 2002, 'English', 2),
('Inception', 2010, 'English', 3),
('Killers of the Flower Moon', 2023, 'English', 4),
('The Departed', 2006, 'English', 4),
('The Wolf of Wall Street', 2013, 'English', 4),
('The Great Gatsby', 2013, 'English', 3),
('Once Upon a Time', 2019, 'English', 4);

INSERT INTO MOVIE_CAST (Act_id, Mov_id, Role) VALUES
(1, 4, 'Frank Abagnale'),
(1, 9, 'Jay Gatsby'),
(1, 10, 'Rick Dalton'),

(2, 2, 'Brody'),
(2, 3, 'Oskar Schindler'),

(3, 3, 'Edith Schindler'),
(3, 6, 'Mollie Burkhart'),

(4, 7, 'Billy Costigan'),
(4, 8, 'Jordan Belfort'),
(4, 10, 'Cliff Booth'),

(5, 9, 'Daisy Buchanan'),
(5, 6, 'Mollie'),

(6, 6, 'William Hale'),
(6, 7, 'Frank Costello'),

(2, 1, 'Arbogast');

INSERT INTO RATING (Mov_id, Rev_Stars) VALUES
(1, 4),
(1, 5),
(2, 5),
(2, 4),
(3, 5),
(4, 4),
(4, 5),
(5, 5),
(5, 4),
(6, 5),
(7, 4),
(7, 5),
(8, 4),
(9, 3);



-- ==========================================
-- QUERIES
-- ==========================================

-- Q1
SELECT M.Mov_Title
FROM MOVIES M
JOIN DIRECTOR D
ON M.Dir_id = D.Dir_id
WHERE D.Dir_Name = 'Hitchcock';

-- Q2
SELECT DISTINCT M.Mov_Title
FROM MOVIES M
JOIN MOVIE_CAST MC
ON M.Mov_id = MC.Mov_id
WHERE MC.Act_id IN (
    SELECT Act_id
    FROM MOVIE_CAST
    GROUP BY Act_id
    HAVING COUNT(Mov_id) >= 2
);

-- Q3
SELECT DISTINCT A.Act_Name
FROM ACTOR A
JOIN MOVIE_CAST MC1
ON A.Act_id = MC1.Act_id
JOIN MOVIES M1
ON MC1.Mov_id = M1.Mov_id
JOIN MOVIE_CAST MC2
ON A.Act_id = MC2.Act_id
JOIN MOVIES M2
ON MC2.Mov_id = M2.Mov_id
WHERE M1.Mov_Year < 2000
AND M2.Mov_Year > 2020;

-- Q4
SELECT M.Mov_Title,
       COUNT(R.Rev_Stars) AS Number_Of_Ratings,
       MAX(R.Rev_Stars) AS Highest_Stars
FROM MOVIES M
JOIN RATING R
ON M.Mov_id = R.Mov_id
GROUP BY M.Mov_id, M.Mov_Title
HAVING COUNT(R.Rev_Stars) >= 1
ORDER BY M.Mov_Title;

-- Q5
UPDATE RATING R
JOIN MOVIES M
ON R.Mov_id = M.Mov_id
JOIN DIRECTOR D
ON M.Dir_id = D.Dir_id
SET R.Rev_Stars = 5
WHERE D.Dir_Name = 'Steven Spielberg';

--To Check
SELECT M.Mov_Title, R.Rev_Stars
FROM MOVIES M
JOIN DIRECTOR D
ON M.Dir_id = D.Dir_id
JOIN RATING R
ON M.Mov_id = R.Mov_id
WHERE D.Dir_Name = 'Steven Spielberg';