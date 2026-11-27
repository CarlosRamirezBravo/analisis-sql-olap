# Proyecto de Análisis OLAP y Consultas SQL (`Aglets_Intl_OLAP`)

## Descripción del Proyecto
Resolución de un caso práctico de análisis comercial y de cadena de suministro aplicando **SQL** sobre un esquema dimensional tipo estrella (*Data Warehouse*) para la empresa *Aglets Intl*. El objetivo fue responder preguntas clave de negocio sobre ventas, clientes, categorías de productos y cobertura semanal de inventario mediante consultas analíticas en **MySQL**.

## Archivo del Proyecto
* [`aglets_olap_analisis.sql`](./aglets_olap_analisis.sql): script con las consultas analíticas documentadas sobre el esquema `Aglets_Intl_OLAP`.

## Tecnologías y Técnicas Aplicadas
* **Base de Datos:** MySQL / MySQL Workbench
* **Lenguaje:** SQL
* **Técnicas:** `JOIN` entre tabla de hechos y dimensiones, agregaciones (`SUM`, `COUNT`, `COUNT(DISTINCT ...)`), filtrado temporal y geográfico, ordenamiento (`ORDER BY`, `LIMIT`) y subconsulta dinámica en `HAVING`.

## Estructura del Esquema (Modelo Estrella)
* `FactTable`: tabla de hechos con transacciones, ingresos (`Revenue`) y unidades (`Units`).
* `CustDim`: dimensión de clientes (`CustID`, `CustName`, `CustCity`, `CustCountry`).
* `ProdDim`: dimensión de productos (`ProdID`, `ProdName`, `ProdColor`, `ProdMaterial`, `ProdCategory`).
* `TimeDim`: dimensión de tiempo (`DateID`, `Week`, `Month`, `Quarter`, `Year`).

## Consultas Destacadas
1. **Desempeño por Categoría y Periodo:** Identificación del trimestre y año con mayores ingresos y unidades vendidas para la categoría `Fashion`.
2. **Desglose Geográfico:** Cálculo de ingresos totales en `USA` durante `2014` por categoría y ranking de clientes en Q4 2014.
3. **Cobertura Dinámica de Colores (*Supply Chain*):** Detección de semanas y años en los que se vendieron todos los colores disponibles mediante una subconsulta en `HAVING`, evitando constantes fijas para que el cálculo se adapte automáticamente si se agregan nuevos colores al catálogo.
