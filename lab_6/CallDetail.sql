```sql
-- ============================================
-- DBMS LAB 6 - PARTITIONED PRIMARY INDEX
-- ============================================

-- CREATE DATABASE
DROP DATABASE IF EXISTS CallDetailDB;
CREATE DATABASE CallDetailDB;
USE CallDetailDB;


-- ============================================
-- CREATE TABLE WITH RANGE PARTITIONING
-- ============================================

CREATE TABLE calldetail (
    phone_number DECIMAL(10,0) NOT NULL,
    call_start TIMESTAMP NOT NULL,
    call_duration INT,
    call_description VARCHAR(30),

    PRIMARY KEY (phone_number, call_start),
    INDEX idx_call_start (call_start)
)
PARTITION BY RANGE (UNIX_TIMESTAMP(call_start)) (
    PARTITION p_before2023 VALUES LESS THAN (1672531200),
    PARTITION p2023 VALUES LESS THAN (1704067200),
    PARTITION p2024 VALUES LESS THAN (1735689600),
    PARTITION p2025 VALUES LESS THAN (1767225600),
    PARTITION p2026 VALUES LESS THAN (1798761600),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);


-- ============================================
-- INSERT SAMPLE DATA
-- ============================================

INSERT INTO calldetail VALUES
(9876543210, '2022-05-10 10:15:00', 120, 'Personal'),
(9876543210, '2023-01-15 11:30:00', 300, 'Business'),
(9876543211, '2024-02-10 09:00:00', 420, 'Business'),
(9876543210, '2025-03-12 13:10:00', 240, 'Business'),
(9876543212, '2025-11-05 16:30:00', 360, 'Personal'),
(9876543213, '2026-04-18 08:45:00', 150, 'Business');


-- ============================================
-- DISPLAY ALL RECORDS
-- ============================================

SELECT * FROM calldetail;


-- ============================================
-- Q1. DISPLAY CALLS OF A PHONE NUMBER
-- WITHOUT A PARTITION KEY FILTER
-- ============================================

SELECT *
FROM calldetail
WHERE phone_number = 9876543210;


-- ============================================
-- Q2. RETRIEVE CALLS MADE DURING 2025
-- USING PARTITION KEY
-- ============================================

SELECT *
FROM calldetail
WHERE UNIX_TIMESTAMP(call_start) >= 1735689600
AND UNIX_TIMESTAMP(call_start) < 1767225600;


-- ============================================
-- Q3. DISPLAY PARTITION INFORMATION
-- ============================================

SELECT PARTITION_NAME, TABLE_ROWS
FROM INFORMATION_SCHEMA.PARTITIONS
WHERE TABLE_SCHEMA = 'CallDetailDB'
AND TABLE_NAME = 'calldetail';


-- ============================================
-- Q4. CHECK QUERY EXECUTION PLAN
-- ============================================

EXPLAIN PARTITIONS
SELECT *
FROM calldetail
WHERE UNIX_TIMESTAMP(call_start) >= 1735689600
AND UNIX_TIMESTAMP(call_start) < 1767225600;


-- ============================================
-- Q5. CHECK SPECIFIC PARTITION
-- ============================================

EXPLAIN PARTITIONS
SELECT *
FROM calldetail PARTITION (p2025)
WHERE UNIX_TIMESTAMP(call_start) >= 1735689600
AND UNIX_TIMESTAMP(call_start) < 1767225600;
```
