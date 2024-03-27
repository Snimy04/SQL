use classicmodels;


#day 3
#1
SELECT customerNumber, customerName, state, creditLimit
FROM customers
WHERE state IS NOT NULL
  AND creditLimit BETWEEN 50000 AND 100000
ORDER BY creditLimit DESC;

#2
SELECT DISTINCT productLine
FROM products
WHERE productLine LIKE '%cars';


#day 4
#1
select orderNumber,status,COALESCE(comments, '-') AS comments from orders
 where status='shipped' ;

#2 
 SELECT
    employeeNumber,
    firstName,
    jobTitle,
    CASE
        WHEN jobTitle = 'President' THEN 'P'
        WHEN jobTitle LIKE '%Sale% Manager%' THEN 'SM'
        WHEN jobTitle = 'Sales Rep' THEN 'SR'
        WHEN jobTitle LIKE '%VP%' THEN 'VP'
        ELSE jobTitle 
    END AS jobTitleAbbreviation
FROM employees
order by jobTitle;

#day 5
#1
SELECT YEAR(paymentDate) AS paymentYear, MIN(amount) AS minAmount
FROM payments
GROUP BY YEAR(paymentDate)
order by YEAR(paymentDate);

#2
SELECT
    YEAR(orderDate) AS orderYear,
    CONCAT('Q', QUARTER(orderDate)) AS orderQuarter,
    COUNT(DISTINCT customerNumber) AS uniqueCustomers,
    COUNT(*) AS totalOrders
FROM orders
GROUP BY orderYear, orderQuarter;

#3
SELECT
    DATE_FORMAT(paymentDate, '%b') AS month,
    CONCAT(ROUND(SUM(amount) / 1000), 'K') AS formattedAmount
FROM payments
GROUP BY month
HAVING SUM(amount) BETWEEN 500000 AND 1000000
ORDER BY SUM(amount) DESC;

#day 6
#1
CREATE TABLE Journey (
    Bus_ID INT NOT NULL,
    Bus_Name VARCHAR(255) NOT NULL,
    Source_Station VARCHAR(255) NOT NULL,
    Destination VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE,
    PRIMARY KEY (Bus_ID)
);

#2
CREATE TABLE Vendor (
    Vendor_ID INT NOT NULL,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE,
    Country VARCHAR(255) DEFAULT 'N/A',
    PRIMARY KEY (Vendor_ID)
);

#3
CREATE TABLE Movies (
    Movie_ID INT NOT NULL,
    Name VARCHAR(255) NOT NULL,
    Release_Year VARCHAR(4) DEFAULT '-',
    Cast VARCHAR(255) NOT NULL,
    Gender ENUM('Male', 'Female') NOT NULL,
    No_of_shows INT CHECK (No_of_shows >= 0),
    PRIMARY KEY (Movie_ID)
);

#4
#-->a
CREATE TABLE Product (
    product_id int AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    supplier_id int,
    foreign key (supplier_id) references suppliers(supplier_id) on delete set null ON UPDATE CASCADE);
    
   


#-->b
CREATE TABLE suppliers (
    supplier_id int AUTO_INCREMENT primary key  ,
    supplier_name VARCHAR(255) ,
	location TEXT
);

#-->c
create table stock(
id int AUTO_INCREMENT primary key ,
product_id int ,
balance_stock int,
foreign key (product_id) references product(product_id) on delete set null ON UPDATE CASCADE);

#day 7
#1
SELECT
    e.employeeNumber,
    CONCAT(e.firstName, ' ', e.lastName) AS SalesPerson,
    COUNT(DISTINCT c.customerNumber) AS UniqueCustomers
FROM
    Employees e
JOIN
    Customers c ON e.employeeNumber = c.salesRepEmployeeNumber
GROUP BY
    e.employeeNumber, SalesPerson
ORDER BY
    UniqueCustomers DESC;
    
#2
SELECT
    c.customerNumber,
    c.customerName,
    p.productCode,
    p.productName,
    SUM(od.quantityOrdered) AS Ordered_Qty,
    p.quantityInStock AS Total_Inventory,
    (p.quantityInStock - SUM(od.quantityOrdered)) AS Left_QTY
FROM
    Customers c
JOIN
    Orders o ON c.customerNumber = o.customerNumber
JOIN
    OrderDetails od ON o.orderNumber = od.orderNumber
JOIN
    Products p ON od.productCode = p.productCode
GROUP BY
    c.customerNumber, p.productCode
ORDER BY
    c.customerNumber;
    
    
#3
CREATE TABLE Laptop (
    Laptop_Name VARCHAR(255) PRIMARY KEY
);

    -- Create Colours table
CREATE TABLE Colours (
    Colour_Name VARCHAR(255) PRIMARY KEY
);

-- Insert sample data into Laptop table
INSERT INTO Laptop (Laptop_Name) VALUES
    ('DELL'),
    ('HP');
    

-- Insert sample data into Colours table
INSERT INTO Colours (Colour_Name) VALUES
    ('White'),
    ('Silver'),
    ('Black');


-- Perform a cross join and find the number of rows
SELECT
    Laptop.Laptop_Name,
    Colours.Colour_Name
FROM
    Laptop
CROSS JOIN
    Colours
ORDER BY
    Laptop.Laptop_Name, Colours.Colour_Name DESC;

#4
CREATE TABLE Project (
    EmployeeID INT PRIMARY KEY,
    FullName VARCHAR(255) NOT NULL,
    Gender VARCHAR(10) NOT NULL,
    ManagerID INT
);

select * from project;

INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);


delete from project;
SELECT
    E2.FullName AS ManagerName,
    E1.FullName AS EmployeeName
FROM
    Project E1
JOIN
    Project E2 ON E1.ManagerID = E2.EmployeeID
    order by managername;
    
    #day 8
    CREATE TABLE facility (
    Facility_ID INT ,
    Name VARCHAR(100) ,
    State VARCHAR(100),
    Country VARCHAR(100) 
);

    
#1
ALTER TABLE facility
MODIFY COLUMN Facility_ID INT AUTO_INCREMENT PRIMARY KEY;

#2
ALTER TABLE facility
ADD COLUMN City VARCHAR(100) NOT NULL AFTER Name;
desc facility;
use classicmodels;
#day 9
create table university(
ID int primary key,
name varchar(40) not null);


INSERT INTO University
VALUES (1, "Pune  University"), 
	   (2, "Mumbai University "),
	   (3, "Delhi University "),
	   (4, "Madras University"),
	   (5, "Nagpur University");
select * from university;

#day 10
CREATE VIEW products_status AS
SELECT
  YEAR(o.orderDate) AS year,
  concat(COUNT(productCode),"(",concat(round((count(productCode)/(select count(productcode)from orderdetails ))*100),
    '%)'
  ) )AS Value
FROM
  orders o
JOIN
  orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY
  YEAR(o.orderDate)
ORDER BY
  COUNT(productCode) DESC;


use classicmodels;


# day 11
#1
delimiter //
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetCustomerLevel`(IN cid INT)
BEGIN
    DECLARE status VARCHAR(20);
    DECLARE credit NUMERIC;

    -- Get the total credit for the specified customer
    SELECT SUM(Amount) INTO credit
    FROM payments
    WHERE customerNumber = cid;

    -- Determine the customer status based on the total credit
    IF credit > 50000 THEN
        SET status = 'platinum';
    ELSEIF credit >= 25000 AND credit <= 50000 THEN
        SET status = 'gold';
    ELSE
        SET status = 'silver';
    END IF;

    
    SELECT status AS CustomerStatus;
END //
delimiter ;

select * from customers;
select * from payments;

#2
DELIMITER //

CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Country_Payments`(IN inputYear INT, IN inputCountry VARCHAR(50))
BEGIN
    -- Declare variables
    DECLARE formattedAmount VARCHAR(20);
    DECLARE paymentYear INT;
    DECLARE paymentCountry VARCHAR(50);

    -- Select the formatted total amount, year, and country
    SELECT CONCAT(FORMAT(SUM(p.Amount), 0), 'K'), YEAR(p.paymentDate), c.country
    INTO formattedAmount, paymentYear, paymentCountry
    FROM Payments p
    JOIN Customers c ON p.customerNumber = c.customerNumber
    WHERE YEAR(p.paymentDate) = inputYear AND c.country = inputCountry
    GROUP BY paymentYear, paymentCountry;

    -- Output the formatted amount, year, and country
    SELECT paymentYear AS PaymentYear, paymentCountry AS PaymentCountry, formattedAmount AS FormattedAmount;
END //

DELIMITER ;

#day 12
#1
WITH OrderCounts AS (
    SELECT
        EXTRACT(YEAR FROM orderDate) AS Year,
        MONTHNAME(orderDate) AS Month,
        COUNT(*) AS Total_Orders
    FROM
        Orders
    GROUP BY
        Year, Month
)
SELECT
    currentYear.Year,
    currentYear.Month,
    currentYear.Total_Orders,
    CASE
        WHEN LAG(currentYear.Total_Orders) OVER (ORDER BY currentYear.Year, MONTH(currentYear.Month)) IS NULL THEN NULL
        ELSE
            CONCAT(
                ROUND(
                    ((currentYear.Total_Orders - LAG(currentYear.Total_Orders) OVER (ORDER BY currentYear.Year, MONTH(currentYear.Month))) / 
                    CAST(LAG(currentYear.Total_Orders) OVER (ORDER BY currentYear.Year, MONTH(currentYear.Month)) AS decimal)) * 100
                ),
                '%'
            )
    END AS '% YoY Change'
FROM
    OrderCounts currentYear
ORDER BY
    currentYear.Year, MONTH(currentYear.Month);
    



#2
CREATE TABLE emp_udf (
    Emp_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255),
    DOB DATE
);

INSERT INTO Emp_udf(Name, DOB)
VALUES 
("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");


delimiter //
CREATE DEFINER=`root`@`localhost` FUNCTION `calculate_age`(DOB DATE) RETURNS varchar(50) CHARSET latin1
    DETERMINISTIC
BEGIN
    DECLARE years INT;
    DECLARE months INT;

    -- Calculate the difference in years and months
    SET years = TIMESTAMPDIFF(YEAR, DOB, CURDATE());
    SET months = TIMESTAMPDIFF(MONTH, DATE_ADD(DOB, INTERVAL years YEAR), CURDATE());

    -- Build the age string
    RETURN CONCAT(years, ' years ', months, ' months');
END //
delimiter ;
-- Add an 'age' column to your existing table
ALTER TABLE emp_udf
ADD COLUMN age VARCHAR(50);

-- Update the 'age' column using the calculate_age_func function
UPDATE emp_udf
SET age = calculate_age(DOB);
select * from emp_udf;


#day 13
#1
SELECT customerNumber, customerName
FROM Customers
WHERE customerNumber NOT IN (
    SELECT customerNumber
    FROM Orders
);

#2
-- Customers with orders
SELECT
    c.customerNumber,
    c.customerName,
    COUNT(o.orderNumber) AS orderCount
FROM
    Customers c
LEFT JOIN
    Orders o ON c.customerNumber = o.customerNumber
GROUP BY
    c.customerNumber, c.customerName

UNION

-- Customers without orders
SELECT
    c.customerNumber,
    c.customerName,
    0 AS orderCount
FROM
    Customers c
WHERE
    c.customerNumber NOT IN (SELECT DISTINCT customerNumber FROM Orders);
    
#3
WITH RankedOrderDetails AS (
    SELECT
        orderNumber,
        quantityOrdered,
        RANK() OVER (PARTITION BY orderNumber ORDER BY quantityOrdered DESC) AS rnk
    FROM
        Orderdetails
)
SELECT
    orderNumber,
    MAX(quantityOrdered) AS secondHighestQuantity
FROM
    RankedOrderDetails
WHERE
    rnk = 2
GROUP BY
    orderNumber;
    
#4
SELECT
    orderNumber,
    COUNT(productCode) AS productCount
FROM
    Orderdetails
GROUP BY
    orderNumber
HAVING
    productCount > 0;  -- Optional, to exclude orders with no products
-- Find the min and max counts
SELECT
    MAX(productCount) AS maxProductCount,
     MIN(productCount) AS minProductCount
FROM (
    SELECT
        orderNumber,
        COUNT(productCode) AS productCount
    FROM
        Orderdetails
    GROUP BY
        orderNumber
    HAVING
        productCount > 0  -- Optional, to exclude orders with no products
) AS ProductCounts;
    

#5
SELECT
    productLine,
    COUNT(*) AS total
FROM
    Products
WHERE
    buyPrice > (SELECT AVG(buyPrice) FROM Products)
group by productline;

#day 14
CREATE TABLE Emp_EH (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(255),
    EmailAddress VARCHAR(255)
);

delimiter //
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertEmp_EH`(
    IN p_EmpID INT,
    IN p_EmpName VARCHAR(255),
    IN p_EmailAddress VARCHAR(255)
)
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Error occurred, show the message
        SELECT 'Error occurred' AS ErrorMessage;
    END;

    -- Insert values into Emp_EH table
    INSERT INTO Emp_EH (EmpID, EmpName, EmailAddress)
    VALUES (p_EmpID, p_EmpName, p_EmailAddress);

    -- Display success message
    SELECT 'Record inserted successfully' AS SuccessMessage;
END //
delimiter ;
select * from Emp_EH ;

#day 15
CREATE TABLE Emp_BIT (
    Name VARCHAR(255) ,
    Occupation VARCHAR(255),
    Working_date DATE,
    Working_hours INT
);

INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),
('Warner', 'Engineer', '2020-10-04', 10),
('Peter', 'Actor', '2020-10-04', 13),
('Marco', 'Doctor', '2020-10-04', 14),
('Brayden', 'Teacher', '2020-10-04', 12),
('Antonio', 'Business', '2020-10-04', 11);

-- Create a before insert trigger
DELIMITER //

CREATE TRIGGER BeforeInsert_Emp_BIT
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
BEGIN
    -- Make sure Working_hours is inserted as positive
    IF NEW.Working_hours < 0 THEN
        SET NEW.Working_hours = ABS(NEW.Working_hours);
    END IF;
END //

DELIMITER ;
 INSERT INTO Emp_BIT VALUES
('Rohan', 'engineer', '2020-10-08', -12);
select * from Emp_BIT;
		