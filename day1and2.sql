USE Northwind;

CREATE DATABASE marcus_1_db;

USE marcus_1_db;

CREATE TABLE film_table
(
    film_id INT IDENTITY(1,1),
    film_name VARCHAR(20),
    film_type VARCHAR(20),
    director VARCHAR(20),     
    star_rating VARCHAR(10),
    plot_summary VARCHAR(MAX),
    PRIMARY KEY (film_id),
);

-- Discussion on improvements
--Create 2 tables and have primary keys in both
--In one of the tables add a foreign key and reference that to the primary key in another table
--ON DELETE CASCADE which if you apply to a primary key will automatically delete that data from foreign key
--Discussioin(Improvements)

/*DROP TABLE film_table;*/

ALTER TABLE film_table
ADD release_date DATETIME;

ALTER TABLE film_table
DROP COLUMN plot_summary;


INSERT INTO film_table
(
    film_name,film_type,director,star_rating,release_date
)
VALUES
(
    'Django Unchained', 'Action', 'Tarantino', 4, '20121111' 
),
(
    'Bad Boys 2', 'Comedy', 'Bay', 3.5, '20030101' 
),
(
    'Wolf of Wallstreet', 'Comedy/Crime', 'Scoresese', 5, '20131225' 
)

/*SELECT * FROM film_table*/


CREATE TABLE film_costings
(
    costings_id INT IDENTITY(1,1),
    film_id INT,
    film_name VARCHAR(20),
    dvd_price VARCHAR(5),
    lowest_new_rrp VARCHAR(5),
    PRIMARY KEY (costings_id),
    FOREIGN KEY (film_id) REFERENCES film_table(film_id) ON DELETE CASCADE
);

INSERT INTO film_costings
(
    film_name, dvd_price, lowest_new_rrp
)
VALUES 
(
'Django Unchained', 2.30, 4, 
)

SP_HELP film_costings

USE Northwind

SELECT * FROM Customers WHERE City = "Paris"; 

SELECT * FROM Employees WHERE TitleOfCourtesy = "Dr."

SELECT CompanyName, City, Country, Region FROM Customers WHERE Region='BC'; 

SELECT CustomerID, City FROM Customers WHERE Country = 'France'

SELECT ProductName, UnitPrice FROM Products WHERE CategoryID = 1 AND Discontinued = '0'

SELECT ProductName, UnitPrice FROM Products WHERE UnitsInStock > 0 AND Unitprice > 29.99

SELECT ProductName, UnitPrice FROM Products WHERE UnitsInStock > 0 OR Unitprice > 29.99

SELECT COUNT(*) FROM Products WHERE UnitsInStock > 0 OR Unitprice > 29.99

SELECT COUNT(*) FROM Products WHERE UnitsInStock > 0 AND Unitprice > 29.99

SELECT DISTINCT Country FROM Customers WHERE ContactTitle = 'OWNER'

SELECT DISTINCT Country FROM Customers WHERE ContactTitle = 'OWNER' AND Country LIKE '_e%'

SELECT DISTINCT Country FROM Customers WHERE ContactTitle = 'OWNER' AND Country LIKE '___i%'

SELECT DISTINCT Country FROM Customers WHERE ContactTitle = 'OWNER' AND Country LIKE '[bs]%'

SELECT DISTINCT Country FROM Customers WHERE ContactTitle = 'OWNER' AND Country LIKE '[^MSD]%'

SELECT * FROM Customers WHERE Region LIKE '_A'

SELECT COUNT(*) FROM Customers WHERE Region IN ('WA', 'SP')

SELECT COUNT(*) FROM EmployeeTerritories WHERE TerritoryID BETWEEN 06800 AND 09999

SELECT ProductName, ProductID FROM Products WHERE UnitPrice < 5.00

SELECT * FROM Categories WHERE CategoryName LIKE '[bs]%' 

SELECT EmployeeID, COUNT(*) AS "Numnber of Orders" FROM Orders GROUP BY EmployeeID HAVING EmployeeID IN (5,7)

SELECT Region, CompanyName AS 'Company Name', CONCAT(City, ',',Country) AS 'City' FROM Customers WHERE Region IS NOT NULL 

SELECT * FROM Employees

SELECT FirstName + ' ' + LastName AS 'Employee name' FROM Employees

SELECT DISTINCT Country FROM Customers WHERE Region IS NOT NULL

-- Read Joins - INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL JOIN.
-- Join practice:

CREATE DATABASE joining_db

USE joining_db

CREATE TABLE countries
(
    country_id INT IDENTITY (1,1),
    country_name VARCHAR(15),
    PRIMARY KEY (country_id),
)

INSERT INTO countries
(
    country_name
)
VALUES
(
    'Spain'
),
(
    'France'
),
(
    'Germany'
)
(
    'Sweden'
)
(
    'Repubic of Ireland'
)


CREATE TABLE cities
(
    country_id INT,
    city_id INT IDENTITY (1,1),
    city_name VARCHAR(20),
    PRIMARY KEY (city_id),
    FOREIGN KEY (country_id) REFERENCES countries(country_id)
)

INSERT INTO cities
(
    country_id, city_name
)
VALUES
(
    3,'Munich'
),
(
    2,'Paris'
),
(
    1,'Madrid'
)
(
    5,'Cork'
)

--Left join syntax

SELECT * FROM countries LEFT JOIN cities ON countries.country_id = cities.country_id 

--right join syntax

SELECT * FROM countries RIGHT JOIN cities ON countries.country_id = cities.country_id 


--Inner join syntax

SELECT * FROM countries INNER JOIN cities ON countries.country_id = cities.country_id 


--Outer join syntax

SELECT * FROM countries FULL OUTER JOIN cities ON countries.country_id = cities.country_id 






-- (12%4)*5/2+5-2
USE Northwind
SELECT UnitPrice, Quantity, Discount, UnitPrice * Quantity AS "Gross Total" FROM [Order Details]

SELECT UnitPrice, Quantity, Discount, (UnitPrice * (1 - Discount)) * Quantity AS "Net Total" FROM [Order Details] GROUP BY UnitPrice ORDER BY "Net Total" DESC

-- Using Group By to remove duplicate OrderID's to show Gross Total in 'receipt like' format. 
SELECT OrderID, UnitPrice, Quantity, Discount, UnitPrice * Quantity AS "Gross Total" FROM [Order Details] GROUP BY OrderID, UnitPrice, Quantity, Discount ORDER by "Gross Total" DESC

--Using nested functions
SELECT PostalCode AS "Post Code", LEFT(PostalCode, CHARINDEX(' ',PostalCode)-1) AS "Postal Code Region", CHARINDEX(' ', PostalCode) AS "Space Found", Country FROM Customers WHERE Country='UK'

SELECT ProductName FROM Products WHERE ProductName LIKE'%''%'

--Using charindex
SELECT ProductName FROM Products WHERE CHARINDEX('''',ProductName)>0

--Using Datetime
SELECT DATEADD(d,5,OrderDate) AS "Due Date", DATEDIFF(d, OrderDate, ShippedDate) AS "Ship Days" FROM Orders

SELECT FirstName + ' ' + LastName AS "Name", DATEDIFF(dd,BirthDate, GETDATE())/365.25 AS "Age" FROM Employees

-- Select Cases
SELECT DATEDIFF(d, OrderDate, ShippedDate) AS "Days for Delivery ", CASE WHEN DATEDIFF(d, OrderDate, ShippedDate)<10 THEN 'On Time' ELSE 'Overdue' END AS "Status" FROM Orders 

SELECT DATEDIFF(yyyy,BirthDate, GETDATE()) AS "AGE", 
CASE 
WHEN DATEDIFF(yyyy,BirthDate, GETDATE())>65
THEN 'Retired'
WHEN DATEDIFF(yyyy,BirthDate, GETDATE())>60
THEN 'Retirement due'
ELSE 'More than 5 year left til retirement'
END AS "Retirement Status"
FROM Employees

-- Using aggregate functions with GROUP BY
SELECT SupplierID, SUM(UnitsOnOrder) AS "Total On Order",
AVG(UnitsOnOrder) AS "AVG on Order",
MAX(UnitsOnOrder) AS "Max On Order"
FROM Products
GROUP BY SupplierID


SELECT CategoryID, AVG(ReorderLevel) AS "AVG Reorder level"
FROM Products
GROUP BY CategoryID


-- using group by clause with order by
SELECT TOP 1 CategoryID, AVG(ReorderLevel) AS "AVG Reorder level"
FROM Products
GROUP BY CategoryID 
ORDER BY "AVG Reorder level" DESC

-- Using group by having with aggregate functions
SELECT SupplierID, 
SUM(UnitsOnOrder) AS "Total on order",
AVG(UnitsOnOrder) AS "AVG on order"
FROM Products
GROUP BY SupplierID
HAVING AVG(UnitsOnOrder)>5

-- Using an inner join.
Use Northwind

SELECT * From Suppliers

SELECT SupplierID, CompanyName AS "Supplier Name", AVG(UnitsOnOrder) AS "Average Units on Order"
FROM Products INNER JOIN Suppliers
ON SupplierID=SupplierID
GROUP BY SupplierID, CompanyName 


--uSING LEFT JOIN
SELECT 


--Joining from more than two tables.
SELECT ProductName, UnitPrice, CompanyName AS "Supplier", CatergoryName AS "Category"
FROM Products
INNER JOIN Suppliers ON SupplierID = SupplierID  
INNER JOIN Categories ON  CategoryID = CategoryID


-- Joining from more than two tables task 2.
SELECT Order, OrderDate, Freight, FirstName +' '+ LastName AS 
FROM
INNER JOIN ON
INNER JOIN ON

SELECT OrderID, CONVERT(VARCHAR()) 

--Sub queries
/* Find out the company names of the customerids who have placed an order*/
SELECT CompanyName AS "Customers"
FROM Customers
WHERE CustomerID IN
-- Below is the sub query
(SELECT CustomerID FROM Orders)

-- Join alternative of the above 
SELECT DISTINCT CompanyName
FROM Customers
INNER JOIN Orders ON Orders.CustomerID = Customers.CustomerID

/* Find out the company names of the customerids who have not placed an order*/
SELECT CompanyName AS "Customers"
FROM Customers
WHERE CustomerID NOT IN 
(SELECT CustomerID FROM Orders)

-- Where a nested query acts as an outer part, as a column
SELECT OrderID, ProductID, UnitPrice, Quantity, Discount,
(SELECT MAX(UnitPrice) FROM [Order Details]) AS "Max Price"
FROM [Order Details]

-- Advanced query, Where the nested query acts a table
SELECT od.ProductID, sq1.totalamt AS "Total Sold for this Product", UnitPrice, UnitPrice*Quantity/totalamt *100 AS "% of Total"
FROM [Order Details] od
INNER JOIN
(SELECT ProductID, SUM(UnitPrice*Quantity)AS totalamt
FROM [Order Details]
GROUP BY ProductID) sq1 ON sq1.ProductID = od.ProductID

USE Northwind
--task
SELECT *
FROM [Order Details] 
WHERE ProductID IN
(SELECT ProductID
FROM Products WHERE Discontinued=1)

-- The inner join version of the task
SELECT od.OrderID, od. 
FROM
WHERE o.ProductID IN 
INNER JOIN Products ON p.ProductID=od.ProductID


--Union ALL example creating a single column that shows all the employeeids and supplierids.
SELECT EmployeeID AS "Employee/Supplier"
FROM Employees
UNION ALL
SELECT SupplierID
FROM Suppliers