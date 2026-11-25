-- SQL Portion of the Final Exam
--

-- Please use this file as a template.

-- What to enter in this template:
-- 1) Your SQL Queries
-- 2) Any assumptions you make as comments
-- 3) Question 0 below, shows an example of how to do this
-- 
-- What NOT to enter in this template
-- 1) do NOT enter the results of your query
-- 2) do NOT enter the row count returned
-- 3) do NOT put extra queries that are not commented out
-- 4) do NOT leave your queries unformatted
-- 5) Do not leave any SELECT * FROM table queries
-- not following these instructions can result in lost points

-- How your instructor will use this
-- 1) Your instructor will run this script on the Database Server as is
-- 2) Therefore please ensure everything is either a comment or perfect SQL
-- 3) Make sure to include the semicolons

-- I recommend you save your work often
-- Save this template as Lastname_Firstname_Final.sql
-- You will upload your completed script when your are finished


-- Please consider the following Schema and Tables:
-- 
--       CREATE TABLE CustDim (
--           CustID       INT(9)      NOT NULL PRIMARY KEY,
--           CustName     VARCHAR(12) NOT NULL,
--           CustCity     VARCHAR(20) NOT NULL,
--           CustCountry  VARCHAR(20) NOT NULL
--       );
--       
--       CREATE TABLE ProdDim (
--           ProdID       INT(9)      NOT NULL PRIMARY KEY,
--           ProdName     VARCHAR(12) NOT NULL,
--           ProdColor    VARCHAR(15) NOT NULL,
--           ProdMaterial VARCHAR(15) NOT NULL,
--           ProdCategory VARCHAR(15) NOT NULL
--       );
--       
--       CREATE TABLE TimeDim (
--           DateID       DATE        NOT NULL PRIMARY KEY,
--           Week         INT(2)      NOT NULL,
--           Month        INT(2)      NOT NULL,
--           Quarter      INT(1)      NOT NULL,
--           Year         INT(4)
--       );
--       
--       CREATE TABLE FactTable (
--           DateID       DATE        NOT NULL,
--           ProdID       INT(9)      NOT NULL,
--           CustID       INT(9)      NOT NULL,
--           Revenue      DECIMAL(10,2),
--           Units        INT(9),
--           PRIMARY KEY(DateID, ProdID, CustID)
--       );

USE Aglets_Intl_OLAP; 

-- (0) How many products are there?
-- ** ASSUMPTIONS **
-- I assume that if all products exist in the database



-- (1) How many colors do Aglets come in?  
## Asumo que queremos contar el número total de colores únicos disponibles en la tabla ProdDim.
SELECT count(distinct(prodcolor)) as cantidad_colores  FROM  ProdDim; 


-- (2) What is the top revenue producing color for all time and how much 
--     revenue has it created? Assume ties are not possible.
##Asumo que unimos FactTable con ProdDim usando ProdID, agrupamos por ProdColor, sumamos Revenue, ordenamos de forma descendente y limitamos a 1.
SELECT p.ProdColor, SUM(f.Revenue) AS TotalRevenue FROM FactTable f
JOIN ProdDim p ON f.ProdID = p.ProdID
GROUP BY p.ProdColor
ORDER BY TotalRevenue DESC
LIMIT 1;


-- (3) Show the total revenue for the Quarter 4 of 2014 by Customer  
--     Display in decreasing order of revenue
##Asumo que unimos FactTable con CustDim y TimeDim, filtramos por el Trimestre 4 y el Año 2014, agrupamos por cliente y ordenamos por ingresos totales de forma descendente.
SELECT c.CustName, SUM(f.Revenue) AS ingresos_totales FROM FactTable f 
JOIN CustDim c ON f.CustID = c.CustID JOIN TimeDim t ON f.DateID = t.DateID
WHERE t.Quarter = 4 AND t.Year = 2014
GROUP BY c.CustID, c.CustName
ORDER BY ingresos_totales  DESC;

-- (4) What is the Total Revenue generated from country "USA" in 2014 
##Asumo que unimos FactTable con CustDim y TimeDim, filtramos por el país "USA" y el año 2014, y sumamos los ingresos
SELECT SUM(f.Revenue) AS ingresos_totales_USA FROM FactTable f 
JOIN CustDim c ON f.CustID = c.CustID JOIN TimeDim t ON f.DateID = t.DateID
WHERE c.CustCountry = 'USA' AND t.Year = 2014;

-- (5) Which quarter in all of the years had the highest revenue for  
-- 'Fashion' Product Category?  Please show the Quarter and Year, along 
-- with the total Revenue and total units sold for that quarter. There should 
-- only be one row returned. You can safely assume there are no ties. 
##Asumo que filtramos por la categoría Fashion, unimos FactTable con ProdDim y TimeDim, agrupamos por Año y Trimestre, sumamos Ingresos y Unidades, ordenamos por ingresos descendentes y limitamos a 1

SELECT t.Year, t.Quarter, SUM(f.Revenue) AS ingresos_totales, SUM(f.Units) AS TotalUnits
FROM FactTable f JOIN ProdDim p ON f.ProdID = p.ProdID JOIN TimeDim t ON f.DateID = t.DateID
WHERE p.ProdCategory = 'Fashion'
GROUP BY t.Year, t.Quarter
ORDER BY ingresos_totales DESC
LIMIT 1;


-- (6) Show the Total Revenue generated from the country "USA" in 2014  
--     grouped by product category 
##Asumo que unimos FactTable, CustDim, TimeDim y ProdDim, filtramos por país "USA" y año 2014, agrupamos por categoría de producto y sumamos los ingresos
SELECT p.ProdCategory, SUM(f.Revenue) AS ingresos_totales
FROM FactTable f
JOIN CustDim c ON f.CustID = c.CustID
JOIN TimeDim t ON f.DateID = t.DateID
JOIN ProdDim p ON f.ProdID = p.ProdID
WHERE c.CustCountry = 'USA' AND t.Year = 2014
GROUP BY p.ProdCategory;


-- (7) Aglets Intl is trying to manage their supply chain. The cost of dyes and  
-- paints are rising and an Executive asked, "Is there ever a week were we  
-- get orders for all of our colors?" Construct a query to show the Year and  
-- Week where they sold any product in every color offered. Your columns  
-- should be "Year", "Week" and "CountOfColorsSold". Ensure your results are  
-- sorted by Increasing "Year" and "Week".  
-- Once you have finished the query, look at it one more time, if you have a  
-- number in your query (e.g. 6), remove it and have a subquery calculate  
-- this value for full credit. What happens if next week they add a new  
-- color and your query has a fixed constant value? 

## Lo que hice fue utilizar una subconsulta en lugar de un valor fijo en la cláusula HAVING. 
## Esto evita tener constantes estáticas y permite que la consulta sea dinámica y escalable. 
## De esta forma, si en el futuro se agregan nuevos colores a la base de datos, la consulta 
## se actualizará automáticamente y siempre entregará de forma correcta las semanas en 
## las que se vendió el total correspondiente de colores

SELECT t.Year, t.Week, COUNT(DISTINCT p.ProdColor) AS CountOfColorsSold
FROM TimeDim t
JOIN FactTable f ON t.DateID = f.DateID
JOIN ProdDim p ON f.ProdID = p.ProdID
GROUP BY t.Year, t.Week
HAVING COUNT(DISTINCT p.ProdColor) = (SELECT COUNT(DISTINCT ProdColor) FROM ProdDim)
ORDER BY t.Year ASC, t.Week ASC;



-- (8) The buds table buds(name, buddy) contains the relationship between 
-- people and their buddies. Which buds like the same beer? In other words, 
-- show the list of people and buddies where both the person and the buddy 
-- likes the same beer. 
##de acuerdo con las instrucciones otorgadas por el profesor, los datos/tablas 
##requeridos para responder esta pregunta no se encuentran disponibles en el 
##material o esquema entregado para realizar la prueba. Por lo tanto, se indica 
## explícitamente que los datos no están presentes para el desarrollo de esta consulta.

USE bbb; 



