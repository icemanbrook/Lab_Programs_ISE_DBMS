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

-- Your INSERT statements here


-- ==========================================
-- QUERIES
-- ==========================================

-- Q1


-- Q2
-- Your query

-- Q3
-- Your query

-- Q4
-- Your query

-- Q5
-- Your query