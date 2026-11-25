# Proyecto de Análisis OLAP y Consultas SQL

## Descripción del Proyecto
Este repositorio reúne la resolución del examen final de un diplomado en herramientas de SQL y Python, aplicando **SQL** sobre un esquema dimensional tipo estrella (*Data Warehouse*) para la empresa *Aglets Intl*. El objetivo fue responder preguntas de negocio y analizar ventas, clientes, productos y periodos temporales mediante consultas en **MySQL**.

## Archivo del Proyecto
* `Ramirez_Carlos_Final.sql`: script con las consultas analíticas y comentarios explicativos sobre el esquema `Aglets_Intl_OLAP`.

## Tecnologías y Herramientas Utilizadas
* **Base de Datos:** MySQL / MySQL Workbench
* **Lenguaje:** SQL (consultas analíticas `SELECT`, uniones, agregaciones y subconsultas)
* **Técnicas Aplicadas:** `JOIN` entre tabla de hechos y dimensiones, funciones de agregación (`SUM`, `COUNT`, `COUNT(DISTINCT ...)`), filtrado por tiempo y categoría, ordenamiento y subconsultas en `HAVING`.

## Estructura del Esquema (Modelo Estrella)
* `FactTable`: tabla de hechos con transacciones, ingresos (`Revenue`) y unidades (`Units`).
* `CustDim`: dimensión de clientes (`CustID`, `CustName`, `CustCity`, `CustCountry`).
* `ProdDim`: dimensión de productos (`ProdID`, `ProdName`, `ProdColor`, `ProdMaterial`, `ProdCategory`).
* `TimeDim`: dimensión de tiempo (`DateID`, `Week`, `Month`, `Quarter`, `Year`).

## Consultas Destacadas en el Script
1. **Análisis por Categoría y Periodo:** Identificación del trimestre y año con mayores ingresos y unidades vendidas para la categoría `Fashion`.
2. **Consultas Dinámicas con Subconsultas:** Evaluación de semanas y años en los que se vendieron todos los colores disponibles usando una subconsulta en `HAVING` en lugar de un número fijo, para que el cálculo se adapte si se incorporan nuevos colores.
