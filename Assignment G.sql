create database Proceedure;
use Proceedure;

CREATE TABLE Employees1 (
    id INT PRIMARY KEY,
    Name VARCHAR(50),
    Department VARCHAR(30),
    Salary INT
);

INSERT INTO Employees1 VALUES 
	(1, "Alice", "HR", 50000),
    (2, "Bob", "IT", 70000),
    (3, "Charlie", "IT", 60000),
    (4, "David", "HR", 55000),
    (5, "Eva", "Finance", 65000);
    
    
-- Simple example of a stored procedure
Delimiter //
create procedure ShowAllEmployees() 
BEGIN 
	SELECT * FROM EMPLOYEES1;
END //
DELIMITER ;

CALL ShowAllEmployees();

-- -------------------------- x -------------------------- 

-- Create a procedure to show all employees details
DELIMITER //
CREATE PROCEDURE ShowAllEmployees2()
BEGIN
    SELECT * 
    FROM Employees1;
END //
DELIMITER ;

Call ShowAllEmployees2();

-- -------------------------- x -------------------------- 

-- Create a stored procedure to fetch all employees from a specific department
Delimiter //
create procedure GetEmployeesByDept(IN Dept VARCHAR(30)) 
BEGIN 
	SELECT * FROM EMPLOYEES1 where Department = Dept;
END //
DELIMITER ;

Call GetEmployeesByDept("IT");

-- -------------------------- x -------------------------- 

-- Create a procedure to increase salary by a given percentage for a department
DELIMITER //
Create procedure IncreaseSalaryPercentage(In Dept_Name varchar(50), in percent_increase decimal (5, 2))
Begin
	Update employees1
    Set salary = salary + (salary * percent_increase / 100) where department = dept_name;
END // 
DELIMITER ;

CALL IncreaseSalaryPercentage("IT", 10);
Select*From Employees1;

-- -------------------------- x -------------------------- 

-- Create a procedure to return total salary of all employees
DELIMITER //
Create Procedure TotalSalary()
Begin
	Select SUM(Salary) as Total_Salary from Employees1;
END // 
DELIMITER ; 

CALL TotalSalary();

-- -------------------------- x -------------------------- 

-- Create a stored procedure to insert a new employee
DELIMITER // 
Create Procedure AddEmployee(
	IN Emp_ID INT,
	IN Emp_Name Varchar(50), 
    IN Emp_dept Varchar(50), 
    IN Emp_salary INT) 
Begin 
	Insert into employees1(id, name, department, salary) values (Emp_ID, emp_name, emp_dept, emp_salary);
End // 
DELIMITER ;

CALL AddEmployee(6, 'Frank', 'Finance', 62000);

-- -------------------------- x -------------------------- 

-- Create a procedure to delete an employee by ID
DELIMITER //
Create procedure DeleteEmployeeByID2(IN EmpID int)
BEGIN
	Delete from Employees1
    where id = EmpID;
End //
DELIMITER ;

CALL DeleteEmployeeByID2(3);

-- -------------------------- x -------------------------- 

-- Create a procedure to return average salary 
DELIMITER //
create procedure AvgSalary()
Begin 
	Select AVG(Salary) as Average_Salary from Employees1;
END // 
DELIMITER ;

CALL AvgSalary()

-- -------------------------- x -------------------------- 

-- Create a procedure to get employees above a salary
DELIMITER //
Create procedure EmployeesAboveaSalary(in EmpSalary int)
Begin
	Select * from Employees1 where salary>EmpSalary;
End //
DELIMITER ; 

cALL EmployeesAboveaSalary(55000);

-- -------------------------- x -------------------------- 

-- Create a procedure to get highest salaried employee
DELIMITER //
Create procedure HighestSalariedEmployee()
Begin
	Select MAX(Salary) as Highest_Salary from Employees1;
END // 
DELIMITER ;

CALL HighestSalariedEmployee();

-- -------------------------- x -------------------------- 

-- Create a procedure to update Employee Name
DELIMITER //
CREATE PROCEDURE UpdateEmployeeName(
    IN EmpID INT,
    IN NewName VARCHAR(50)
)
BEGIN
    UPDATE Employees1
    SET Name = NewName
    WHERE id = EmpID;
END //
DELIMITER ;

CALL UpdateEmployeeName(2, "Robert");

-- -------------------------- x -------------------------- 