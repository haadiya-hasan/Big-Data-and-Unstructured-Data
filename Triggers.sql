-- Trigger


-- TRIGGER WITH INSERT
create database Triggers;
use Triggers;

create table inventory(product_id int primary key, product_name varchar(50), quantity int);
create table sales (sale_id int auto_increment primary key, product_id int, amount DECIMAL(10, 2), sale_date DATE, quantity_sold int);

insert into inventory (product_id, product_name, quantity) values
(1, "PRODUCT A", 100), (2, "PRODUCT B", 150), (3, "PRODUCT C", 200);

-- 3. Create a trigger

Delimiter //
Create trigger after_sales_insert 
after insert on sales
	for each row 
    begin 
		update inventory set quantity = quantity - NEW.quantity_sold 
        where product_id = NEW.product_id;
End //
Delimiter ;

-- 4. Insert a new sale to test the trigger

Insert into sales (product_id, amount, sale_date, quantity_sold) values (1, 50.00, '2024-07-01', 10);

select * from inventory;	

-- drop the triggers if needed
show triggers;
drop trigger after_sales_insert;


-- TRIGGER WITH DELETE

create table employees(emp_id int primary key, name varchar(50), department varchar(50));
create table deleted_employees_log(log_id int auto_increment primary key, emp_id int, name varchar(50), department varchar(50), deleted_at DATETIME);

Delimiter //
Create trigger after_employee_delete 
after delete on employees 
for each row 
begin 
	insert into deleted_employees_log(emp_id, name, department, deleted_at) 
    values (OLD.emp_id, OLD.name, OLD.department, NOW());

END //
Delimiter ;

insert into employees (emp_id, name, department) values (1, "Alice", "HR"), (2, "Bob", "IT"), (3, "Charlie", "Finance");

select*from employees;
delete from employees where emp_id = 2;
select * from deleted_employees_log;

-- -------------------------------------------------------------x-------------------------------------------------------------

create table employees1 (emp_id int primary key, name varchar(50), salary decimal(10, 2));
create table employees_log(log_id int auto_increment primary key, emp_id int, action varchar(50), log_time timestamp default current_timestamp);
Insert into employees1 (emp_id, name, salary) values (1, "Amit", 50000.00), (2, "Neha", 62000.00), (3, "Ravi", 45000.00), (4, "Priya", 70000.00);

-- 1. Create a Trigger to log insert activity
Delimiter //
Create trigger employee_insert after insert on employees1 for each row
begin
	insert into employees_log(emp_id, action) VALUES (NEW.emp_id, "New Employee Added");
END //
Delimiter ;

INSERT INTO employees1
(emp_id, name, salary)
VALUES (5, 'Karan', 55000.00);

Insert into employees1 (emp_id, name, salary) VALUES (6, 'Kallie', 23000.00);

SELECT * FROM employees_log;

-- 2. Create a trigger to log salary update

Delimiter //
create trigger salary_update after update on employees1 for each row
begin
	if old.salary<>new.salary then
    insert into employees_log(emp_id, action)
    values (
		new.emp_id, "Salary updated");
        
	end if;
end //
delimiter ;


UPDATE employees1
SET salary = 90000
WHERE emp_id = 1;

SELECT * FROM employees_log;

-- 3. Create a Trigger to convert Employee name to uppercase

DELIMITER //

CREATE TRIGGER trg_uppercase_name
BEFORE INSERT
ON employees1
FOR EACH ROW
BEGIN
    SET NEW.name = UPPER(NEW.name);
END //

DELIMITER ;

UPDATE employees1
SET name='priya'
WHERE emp_id=4;

select * from employees_log;

-- Create a trigger to prevent negative salary

delimiter //
create trigger before_insert_salary before insert on employees1 for each row
begin if new.salary < 0 then signal sqlstate '45000' set message_text = 'salary cannot be negative'; end if;
end //  
Delimiter ;

insert into employees1 values (7, "Neha", -5000);
insert into employees1 values (7, "Natasha", 50000);

select * from employees1;

-- 5. Create a trigger to restrict salary reduction
DELIMITER //

CREATE TRIGGER restrict_salary_reduction BEFORE UPDATE ON employees1 FOR EACH ROW BEGIN
    IF NEW.salary < OLD.salary THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Salary reduction not allowed';
    END IF;
END //
DELIMITER ;

UPDATE employees1
SET salary = 70000
WHERE emp_id = 1;

-- 6. Create a trigger to log name changes
DELIMITER //

CREATE TRIGGER trg_log_name_change
AFTER UPDATE
ON employees1
FOR EACH ROW
BEGIN
    IF OLD.name <> NEW.name THEN
        INSERT INTO employees_log(emp_id, action)
        VALUES (
            NEW.emp_id,
            'NAME UPDATED'
        );
    END IF;
END //

DELIMITER ;

UPDATE employees1
SET name = 'Rahul'
WHERE emp_id = 1;

SELECT * FROM employees_log;

-- 7. Create a trigger to store old and new salary change

CREATE TABLE salary_changes (
    change_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

Delimiter //
CREATE TRIGGER log_salary_update
AFTER UPDATE ON employees1
FOR EACH ROW
BEGIN
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO salary_changes (emp_id, old_salary, new_salary) 
        VALUES (NEW.emp_id, OLD.salary, NEW.salary);
    END IF;
END //
Delimiter ;

update employees1 set salary = 100300 where emp_id = 1;

select*from salary_changes;

-- 8. Create a trigger to automatically increase salary by 10%

delimiter //
create trigger increase_salary before update on employees1
for each row
begin 
	set new.salary = new.salary+ (new.salary*0.10);
end //

update employees1 set salary = 550000 where emp_id = 3;

select*from employees1;

-- 9. Trigger to Prevent Duplicate Employee Names

delimiter //
CREATE TRIGGER prevent_duplicate_name
BEFORE INSERT ON employees1
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM employees1
        WHERE name = NEW.name
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee name already exists';
    END IF;
END //

DELIMITER ;

-- 10. Trigger to Log Employee Deletion

DELIMITER //

CREATE TRIGGER log_employee_delete
AFTER DELETE ON employees1
FOR EACH ROW
BEGIN
    INSERT INTO employees_log(emp_id, action)
    VALUES (OLD.emp_id, 'EMPLOYEE DELETED');
END //

DELIMITER ;

-- 11. Trigger to Set Minimum Salary

DELIMITER //

CREATE TRIGGER set_min_salary
BEFORE INSERT ON employees1
FOR EACH ROW
BEGIN
    IF NEW.salary < 10000 THEN
        SET NEW.salary = 10000;
    END IF;
END //

DELIMITER ;

-- 12. Trigger to Add ₹5000 Bonus to New Employees

DELIMITER //

CREATE TRIGGER joining_bonus
BEFORE INSERT ON employees1
FOR EACH ROW
BEGIN
    SET NEW.salary = NEW.salary + 5000;
END //

DELIMITER ;

-- 13. Trigger to Store Deleted Employee Details

CREATE TABLE deleted_employees (
    emp_id INT,
    name VARCHAR(50),
    salary DECIMAL(10,2),
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 14. Trigger to Restrict Salary Above ₹2,00,000

DELIMITER //

CREATE TRIGGER max_salary_insert
BEFORE INSERT ON employees1
FOR EACH ROW
BEGIN
    IF NEW.salary > 200000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary cannot exceed 200000';
    END IF;
END //

DELIMITER ;

-- 15. Trigger to Track Employee Promotions

DELIMITER //

CREATE TRIGGER promotion_log
AFTER UPDATE ON employees1
FOR EACH ROW
BEGIN
    IF NEW.salary - OLD.salary > 10000 THEN
        INSERT INTO employees_log(emp_id, action)
        VALUES (NEW.emp_id, 'PROMOTION GIVEN');
    END IF;
END //

DELIMITER ;
