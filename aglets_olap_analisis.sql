-- ============================================================================
-- Análisis OLAP sobre Modelo Estrella (Data Warehouse: Aglets_Intl_OLAP)
-- Autor: Carlos Ramírez Bravo
-- Motor: MySQL
-- ============================================================================
-- Esquema de referencia:
--   CustDim(CustID, CustName, CustCity, CustCountry)
--   ProdDim(ProdID, ProdName, ProdColor, ProdMaterial, ProdCategory)
--   TimeDim(DateID, Week, Month, Quarter, Year)
--   FactTable(DateID, ProdID, CustID, Revenue, Units)
-- ============================================================================

USE Aglets_Intl_OLAP;

-- 1. ¿Cuántos colores distintos de productos existen en el catálogo?
-- Se cuenta el total de valores únicos de ProdColor en la dimensión de productos.
SELECT
    COUNT(DISTINCT ProdColor) AS cantidad_colores
FROM ProdDim;


-- 2. ¿Cuál es el color que genera mayores ingresos históricos y cuánto ha generado?
-- Unión de FactTable con ProdDim para agregar Revenue por ProdColor.
SELECT
    p.ProdColor,
    SUM(f.Revenue) AS TotalRevenue
FROM FactTable f
JOIN ProdDim p ON f.ProdID = p.ProdID
GROUP BY p.ProdColor
ORDER BY TotalRevenue DESC
LIMIT 1;


-- 3. Ingresos totales del Q4 de 2014 por cliente (orden descendente).
-- Unión de hechos con clientes y tiempo, filtrando por Quarter = 4 y Year = 2014.
SELECT
    c.CustName,
    SUM(f.Revenue) AS ingresos_totales
FROM FactTable f
JOIN CustDim c ON f.CustID = c.CustID
JOIN TimeDim t ON f.DateID = t.DateID
WHERE t.Quarter = 4
  AND t.Year = 2014
GROUP BY c.CustID, c.CustName
ORDER BY ingresos_totales DESC;


-- 4. Ingresos totales generados en Estados Unidos ('USA') durante el año 2014.
SELECT
    SUM(f.Revenue) AS ingresos_totales_USA
FROM FactTable f
JOIN CustDim c ON f.CustID = c.CustID
JOIN TimeDim t ON f.DateID = t.DateID
WHERE c.CustCountry = 'USA'
  AND t.Year = 2014;


-- 5. Trimestre y año con mayores ingresos para la categoría 'Fashion' (incluyendo unidades vendidas).
SELECT
    t.Year,
    t.Quarter,
    SUM(f.Revenue) AS ingresos_totales,
    SUM(f.Units) AS TotalUnits
FROM FactTable f
JOIN ProdDim p ON f.ProdID = p.ProdID
JOIN TimeDim t ON f.DateID = t.DateID
WHERE p.ProdCategory = 'Fashion'
GROUP BY t.Year, t.Quarter
ORDER BY ingresos_totales DESC
LIMIT 1;


-- 6. Ingresos totales en 'USA' durante 2014 desglosados por categoría de producto.
SELECT
    p.ProdCategory,
    SUM(f.Revenue) AS ingresos_totales
FROM FactTable f
JOIN CustDim c ON f.CustID = c.CustID
JOIN TimeDim t ON f.DateID = t.DateID
JOIN ProdDim p ON f.ProdID = p.ProdID
WHERE c.CustCountry = 'USA'
  AND t.Year = 2014
GROUP BY p.ProdCategory
ORDER BY ingresos_totales DESC;


-- 7. Análisis de Supply Chain: ¿En qué años y semanas se vendieron todos los colores del catálogo?
-- Se utiliza una subconsulta dinámica en HAVING en lugar de una constante fija,
-- asegurando escalabilidad si en el futuro se incorporan nuevos colores a ProdDim.
SELECT
    t.Year,
    t.Week,
    COUNT(DISTINCT p.ProdColor) AS CountOfColorsSold
FROM TimeDim t
JOIN FactTable f ON t.DateID = f.DateID
JOIN ProdDim p ON f.ProdID = p.ProdID
GROUP BY t.Year, t.Week
HAVING COUNT(DISTINCT p.ProdColor) = (
    SELECT COUNT(DISTINCT ProdColor) FROM ProdDim
)
ORDER BY t.Year ASC, t.Week ASC;
