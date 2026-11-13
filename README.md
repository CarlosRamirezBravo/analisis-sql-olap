#  Proyecto de Análisis OLAP & Consultas SQL Avanzadas

## Descripción del Proyecto
Este repositorio contiene la resolución práctica de un caso de estudio y examen analítico utilizando **SQL** sobre un esquema de base de datos multidimensional (Data Warehouse / Modelo Estrella) para la empresa *Aglets Intl*. El objetivo principal fue extraer, transformar y responder preguntas de negocio críticas utilizando consultas avanzadas en **MySQL**.

##  Tecnologías y Herramientas Utilizadas
* **Base de Datos:** MySQL / MySQL Workbench
* **Lenguaje:** SQL (DDL, DML, Consultas complejas)
* **Técnicas Aplicadas:** Joins multitabla, Agregaciones (`SUM`, `COUNT`), Subconsultas correlacionadas y dinámicas, Filtrado temporal y optimización de conjuntos de datos.

##  Estructura del Esquema (Modelo Estrella)
* `FactTable`: Tabla de hechos que almacena transacciones, ingresos (`Revenue`) y unidades vendidas (`Units`).
* `CustDim`: Dimensión de Clientes (ID, Nombre, Ciudad, País).
* `ProdDim`: Dimensión de Productos (ID, Nombre, Color, Material, Categoría).
* `TimeDim`: Dimensión de Tiempo (Fecha, Semana, Mes, Trimestre, Año).

##  Ejemplos de Consultas Destacadas en el Script
1. **Análisis de Rendimiento por Categoría y Tiempo:** Identificación de trimestres con mayores ingresos para categorías específicas de productos.
2. **Consultas Dinámicas Escalables (Subconsultas):** Resolución de problemas complejos de supply chain utilizando subconsultas en la cláusula `HAVING` para garantizar que la lógica se adapte automáticamente si se agregan nuevos registros (como nuevos colores de productos), evitando constantes estáticas.
