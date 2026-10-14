```sql
-- ============================================
-- DBMS LAB 6
-- PARTITIONED PRIMARY INDEX
-- CALL DETAIL DATABASE
-- ============================================

DROP DATABASE IF EXISTS CallDetailDB;
CREATE DATABASE CallDetailDB;
USE CallDetailDB;


-- ============================================
-- 1. CREATE TABLE WITH PARTITIONING
-- ============================================

CREATE TABLE calldetail (
    phone_number DECIMAL(10,0) NOT NULL,
    call_start TIMESTAMP NOT NULL,
    call_duration INT,
    call_description VARCHAR(30),

    PRIMARY KEY (phone_number, call_start),

    INDEX idx_call_start (call_start)
)
PARTITION BY RANGE (YEAR(call_start)) (
    PARTITION p_before_2023 VALUES LESS THAN (2023),
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p2025 VALUES LESS THAN (2026),
    PARTITION p2026 VALUES LESS THAN (2027),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);


-- ============================================
-- 2. INSERT SAMPLE DATA
-- ============================================

INSERT INTO calldetail
(phone_number, call_start, call_duration, call_description)
VALUES
(9876543210, '2022-05-10 10:15:00', 120, 'Personal'),
(9876543210, '2023-01-15 11:30:00', 300, 'Business'),
(9876543211, '2023-06-20 14:45:00', 180, 'Personal'),
(9876543212, '2024-02-10 09:00:00', 420, 'Business'),
(9876543213, '2024-08-25 17:20:00', 60, 'Personal'),
(9876543210, '2025-03-12 13:10:00', 240, 'Business'),
(9876543214, '2025-11-05 16:30:00', 360, 'Personal'),
(9876543215, '2026-04-18 08:45:00', 150, 'Business'),
(9876543216, '2026-09-22 19:15:00', 200, 'Personal');


-- ============================================
-- 3. DISPLAY ALL RECORDS
-- ============================================

SELECT * FROM calldetail;


-- ============================================
-- 4. QUERY WITHOUT PARTITION FILTER
-- ============================================

SELECT *
FROM calldetail
WHERE phone_number = 9876543210;


-- ============================================
-- 5. QUERY USING PARTITION KEY
-- Retrieve calls made during 2025
-- ============================================

SELECT *
FROM calldetail
WHERE call_start >= '2025-01-01 00:00:00'
  AND call_start <  '2026-01-01 00:00:00';


-- ============================================
-- 6. CHECK PARTITION INFORMATION
-- ============================================

SELECT
    PARTITION_NAME,
    TABLE_ROWS
FROM INFORMATION_SCHEMA.PARTITIONS
WHERE TABLE_SCHEMA = 'CallDetailDB'
  AND TABLE_NAME = 'calldetail';


-- ============================================
-- 7. VIEW THE QUERY EXECUTION PLAN
-- ============================================

EXPLAIN
SELECT *
FROM calldetail
WHERE call_start >= '2025-01-01 00:00:00'
  AND call_start <  '2026-01-01 00:00:00';


-- ============================================
-- 8. CHECK WHICH PARTITIONS ARE USED
-- ============================================

EXPLAIN
SELECT *
FROM calldetail PARTITION (p2025)
WHERE call_start >= '2025-01-01 00:00:00'
  AND call_start <  '2026-01-01 00:00:00';
```
