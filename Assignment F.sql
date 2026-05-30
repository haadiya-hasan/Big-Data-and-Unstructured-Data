create database Assignment_F;
use Assignment_F;

-- 1. Add Two Numbers

DELIMITER //
CREATE FUNCTION add_numbers(a DOUBLE, b DOUBLE)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
    RETURN a + b;
END //
DELIMITER ;

SELECT add_numbers(20, 10);

-- 2. Find the Square of a Number

DELIMITER //
CREATE FUNCTION square_number(num DOUBLE)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
    RETURN num * num;
END //
DELIMITER ;

SELECT square_number(15) AS 'Square of 15';

-- 3. Check if a Number is Even or Odd

DELIMITER //
CREATE FUNCTION even_or_odd(num INT)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    IF num % 2 = 0 THEN
        RETURN 'Even';
    ELSE
        RETURN 'Odd';
    END IF;
END //
DELIMITER ;

SELECT even_or_odd(0) AS 'Even or Odd Result';

-- 4. Find the Maximum of Three Numbers

DELIMITER //
CREATE FUNCTION max_of_three(a DOUBLE, b DOUBLE, c DOUBLE)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
    RETURN GREATEST(a, b, c);
END //
DELIMITER ;

SELECT max_of_three(32, 31.5, 31) AS 'Maximum Value';

-- 5. Calculate the Sum of First n Natural Numbers

DELIMITER //
CREATE FUNCTION sum_natural_numbers(n INT)
RETURNS INT
DETERMINISTIC
BEGIN
    IF n < 0 THEN
        RETURN 0;
    END IF;
    RETURN (n * (n + 1)) / 2;
END //
DELIMITER ;

SELECT sum_natural_numbers(101) AS 'Sum of 1 to 100';

-- 6. Return the Length of a String

DELIMITER //
CREATE FUNCTION string_length(str VARCHAR(255))
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN LENGTH(str);
END //
DELIMITER ;

SELECT string_length('Big and Unstructured Data') AS 'String Length';

-- 7. Reverse a String

DELIMITER //
CREATE FUNCTION reverse_string(str VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN REVERSE(str);
END //
DELIMITER ;

SELECT reverse_string('Functions in MySQL') AS 'Reversed String';

-- 8. Count Vowels

DELIMITER //
CREATE FUNCTION count_vowels(str VARCHAR(255))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_vowels INT DEFAULT 0;
    DECLARE i INT DEFAULT 1;
    DECLARE current_char CHAR(1);
    
    WHILE i <= LENGTH(str) DO
        SET current_char = LOWER(SUBSTRING(str, i, 1));
        IF current_char IN ('a', 'e', 'i', 'o', 'u') THEN
            SET total_vowels = total_vowels + 1;
        END IF;
        SET i = i + 1;
    END WHILE;
    
    RETURN total_vowels;
END //
DELIMITER ;

SELECT count_vowels('Assignment Submission') AS 'Total Vowels';

-- 9. Find Factorial

DELIMITER //
CREATE FUNCTION find_factorial(n INT)
RETURNS BIGINT
DETERMINISTIC
BEGIN
    DECLARE result BIGINT DEFAULT 1;
    DECLARE i INT DEFAULT 1;
    
    IF n < 0 THEN 
        RETURN NULL; 
    END IF;
    
    WHILE i <= n DO
        SET result = result * i;
        SET i = i + 1;
    END WHILE;
    
    RETURN result;
END //
DELIMITER ;

SELECT find_factorial(15) AS 'Factorial of 15';


-- 10. HCF of 2 Numbers

DELIMITER //

CREATE FUNCTION hcf(a INT, b INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE temp INT;

    WHILE b != 0 DO
        SET temp = b;
        SET b = a % b;
        SET a = temp;
    END WHILE;

    RETURN a;
END //

DELIMITER ;

SELECT hcf(48, 18);