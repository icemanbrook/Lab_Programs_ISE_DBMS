-- =========================================================
-- LIBRARY DATABASE
-- =========================================================

CREATE DATABASE my_lib;

USE my_lib;


-- =========================================================
-- 1. CREATE TABLES
-- =========================================================

CREATE TABLE publisher (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    address VARCHAR(300),
    phone VARCHAR(20)
);


CREATE TABLE book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150),
    publisher_id INT,
    pub_year YEAR,
    FOREIGN KEY (publisher_id)
        REFERENCES publisher(publisher_id)
        ON DELETE SET NULL
);


CREATE TABLE book_authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    author_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (book_id)
        REFERENCES book(book_id)
        ON DELETE CASCADE
);


CREATE TABLE library_branch (
    branch_id INT AUTO_INCREMENT PRIMARY KEY,
    branch_name VARCHAR(100),
    address VARCHAR(300)
);


CREATE TABLE book_copies (
    book_id INT,
    branch_id INT,
    no_of_copies INT,
    FOREIGN KEY (book_id)
        REFERENCES book(book_id)
        ON DELETE CASCADE,
    FOREIGN KEY (branch_id)
        REFERENCES library_branch(branch_id)
        ON DELETE CASCADE
);


CREATE TABLE book_lending (
    book_id INT,
    branch_id INT,
    card_no INT,
    date_out DATE,
    due_date DATE,
    FOREIGN KEY (book_id)
        REFERENCES book(book_id)
        ON DELETE CASCADE,
    FOREIGN KEY (branch_id)
        REFERENCES library_branch(branch_id)
        ON DELETE CASCADE
);


-- =========================================================
-- 2. INSERT DATA
-- =========================================================

-- -------------------------
-- PUBLISHER
-- -------------------------

INSERT INTO publisher
(name, address, phone)
VALUES
('Adi', 'Goa', '994499'),
('Cy', 'Hyd', '987654'),
('Z', 'Bengaluru', '9465321');


-- -------------------------
-- BOOK
-- -------------------------

INSERT INTO book
(title, publisher_id, pub_year)
VALUES
('DBMS', 1, 2020),
('OS', 2, 2019),
('CN', 3, 2021),
('C Prog', 1, 2020),
('DSA', 2, 2022);


-- -------------------------
-- BOOK AUTHORS
-- -------------------------

INSERT INTO book_authors
(book_id, author_name)
VALUES
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'D'),
(5, 'E');


-- -------------------------
-- LIBRARY BRANCH
-- -------------------------

INSERT INTO library_branch
(branch_name, address)
VALUES
('JSS', 'Mysuru'),
('City', 'Bengaluru'),
('Central', 'Mysuru');


-- -------------------------
-- BOOK COPIES
-- -------------------------

INSERT INTO book_copies
(book_id, branch_id, no_of_copies)
VALUES
(1, 1, 5),
(1, 2, 3),
(2, 1, 4),
(3, 2, 6),
(4, 3, 2),
(5, 1, 5);


-- -------------------------
-- BOOK LENDING
-- -------------------------

INSERT INTO book_lending
(book_id, branch_id, card_no, date_out, due_date)
VALUES
(1, 1, 101, '2020-01-10', '2020-02-20'),
(1, 1, 102, '2021-05-10', '2021-05-20'),
(2, 1, 101, '2021-06-15', '2021-06-25'),
(3, 2, 103, '2022-01-10', '2022-01-20'),
(4, 3, 104, '2022-05-10', '2022-05-20'),

-- Extra records so Query 2 has a borrower
-- who borrowed more than 3 books
(2, 2, 101, '2020-03-10', '2020-03-20'),
(3, 2, 101, '2020-07-10', '2020-07-20'),
(4, 3, 101, '2022-01-10', '2022-01-20');


-- =========================================================
-- QUERY 1
-- Retrieve details of all books in the library:
-- book_id, title, publisher name, author name,
-- branch name and number of copies.
-- =========================================================

SELECT
    b.book_id,
    b.title,
    p.name AS publisher,
    ba.author_name,
    lb.branch_name,
    bc.no_of_copies
FROM book b
JOIN publisher p
    ON b.publisher_id = p.publisher_id
JOIN book_authors ba
    ON b.book_id = ba.book_id
JOIN book_copies bc
    ON b.book_id = bc.book_id
JOIN library_branch lb
    ON bc.branch_id = lb.branch_id;


-- =========================================================
-- QUERY 2
-- Find borrowers who have borrowed more than 3 books
-- between January 2020 and June 2022.
-- =========================================================

SELECT
    card_no,
    COUNT(*) AS no_of_books
FROM book_lending
WHERE date_out BETWEEN '2020-01-01' AND '2022-06-30'
GROUP BY card_no
HAVING COUNT(*) > 3;


-- =========================================================
-- QUERY 3
-- Delete a book from BOOK table and update the contents
-- of other tables using DML statements.
--
-- Here we delete book_id = 1.
-- =========================================================

DELETE FROM book_authors
WHERE book_id = 1;

DELETE FROM book_copies
WHERE book_id = 1;

DELETE FROM book_lending
WHERE book_id = 1;

DELETE FROM book
WHERE book_id = 1;


-- =========================================================
-- QUERY 4
-- Create a view for BOOK table based on year of publication
-- and demonstrate its working with a simple query.
-- =========================================================

CREATE VIEW book_year_view AS
SELECT
    book_id,
    title,
    publisher_id,
    pub_year
FROM book;


-- Demonstrate the view

SELECT *
FROM book_year_view
WHERE pub_year = 2020;


-- =========================================================
-- QUERY 5
-- Create a view of all books and their number of copies
-- currently available in the library.
-- =========================================================

CREATE VIEW available_books AS
SELECT
    b.book_id,
    b.title,
    SUM(bc.no_of_copies) AS total_copies
FROM book b
JOIN book_copies bc
    ON b.book_id = bc.book_id
GROUP BY
    b.book_id,
    b.title;


-- Demonstrate the view

SELECT *
FROM available_books;


-- =========================================================
-- QUERY 6
-- Demonstrate the usage of VIEW creation.
-- =========================================================

CREATE VIEW book_details AS
SELECT
    book_id,
    title,
    publisher_id
FROM book;


-- Use the view

SELECT *
FROM book_details;


-- Drop the view

DROP VIEW book_details;