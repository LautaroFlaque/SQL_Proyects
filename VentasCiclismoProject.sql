USE VentasCiclismo
;

/*Primero que nada, vamos a llamar a todas las tablas de la base de datos*/

SELECT * FROM Ventas;
SELECT * FROM Country;
SELECT * FROM ProductCategory;
SELECT * FROM States;
SELECT * FROM SubCategory;

/*Luego de una primera observaci�n a las tablas, podemos realizarnos varias preguntas, y con eso realizar las consultas correspondientes:

1. Cantidades totales de productos vendidos por subcategor�a. Costos y precios totales.
2. Costos y precios totales por pa�s.
3. Costos y precios unitarios promedio por pa�s.
4. Cantidad de ventas realizadas, costos y precios seg�n g�nero.
5. Promedio de costos y precios unitarios seg�n categor�a de producto.
6. Estados Unidos: costos y precios unitarios promedio por estado.
7. Alemania: edad promedio y cantidad de ventas seg�n g�nero.
8. B�squedas puntuales. Quiero saber, por ejemplo, el pa�s, categor�a y subcategor�a de producto de la venta con n�mero 15000.
9. B�squedas puntuales. Quiero saber el g�nero, la edad, el estado donde compr� y la cantidad de productos que compr� de la venta con n�mero 25000.
10. B�squedas puntuales. Quiero saber el estado, el g�nero, la ganancia y la subcategor�a de producto de las ventas que se realizaron el dia 09/02/2016.

*/

/*1. Cantidades totales de productos vendidos por subcategor�a. Costos y precios totales.*/

SELECT
sub.Name_SubCategory,
SUM(v.Quantity) AS TotalQuantity,
CAST(SUM(v.Cost) AS NUMERIC(12,2)) AS CostoTotal,
CAST(SUM(v.Revenue) AS NUMERIC(12,2)) AS PrecioTotal,
CAST((SUM(v.Revenue) - SUM(v.Cost)) AS numeric(12,2)) AS GananciaPorProductoTotal
FROM Ventas AS v
JOIN SubCategory AS sub
ON v.ID_SubCategory = sub.ID_SubCategory
GROUP BY sub.Name_SubCategory
ORDER BY GananciaPorProductoTotal DESC
;

/*2. Costos y precios totales por pa�s.*/

SELECT
c.Name_Country,
CAST(SUM(v.Cost) AS NUMERIC(12,2)) AS CostoTotal,
CAST(SUM(v.Revenue) AS NUMERIC(12,2)) AS PrecioTotal,
CAST((SUM(v.Revenue) - SUM(v.Cost)) AS numeric(12,2)) AS GananciaPorPaisTotal
FROM Ventas AS v
JOIN Country AS c
ON v.ID_Country = c.ID_Country
GROUP BY c.Name_Country
ORDER BY GananciaPorPaisTotal DESC
;

/*3. Costos y precios unitarios promedio por pa�s.*/

SELECT
c.Name_Country,
CAST(AVG(v.Unit_Cost) AS NUMERIC(12,2)) AS CostoPromTotal,
CAST(AVG(v.Unit_Price) AS NUMERIC(12,2)) AS PrecioPromTotal,
CAST((AVG(v.Unit_Price) - AVG(v.Unit_Cost)) AS numeric(12,2)) AS GananciaPorPaisProm
FROM Ventas AS v
JOIN Country AS c
ON v.ID_Country = c.ID_Country
GROUP BY c.Name_Country
ORDER BY GananciaPorPaisProm DESC
;

/*4. Cantidad de ventas realizadas, costos y precios totales seg�n g�nero.*/

SELECT
Customer_Gender,
COUNT(SaleIndex) AS Ventas,
CAST(SUM(Cost) AS NUMERIC(12,2)) AS CostoTotal,
CAST(SUM(Revenue) AS NUMERIC(12,2)) AS PrecioTotal,
CAST((SUM(Revenue) - SUM(Cost)) AS numeric(12,2)) AS GananciaPorGeneroTotal
FROM Ventas
GROUP BY Customer_Gender
ORDER BY GananciaPorGeneroTotal DESC
;

/*5. Promedio de costos y precios unitarios seg�n categor�a de producto*/

SELECT
p.Name_ProductCategory,
CAST(AVG(v.Unit_Cost) AS NUMERIC(12,2)) AS CostoPromTotal,
CAST(AVG(v.Unit_Price) AS NUMERIC(12,2)) AS PrecioPromTotal,
CAST((AVG(v.Unit_Price) - AVG(v.Unit_Cost)) AS numeric(12,2)) AS GananciaPorCatProm
FROM Ventas AS v
JOIN ProductCategory AS p
ON v.ID_ProductCategory = p.ID_ProductCategory
GROUP BY p.Name_ProductCategory
ORDER BY GananciaPorCatProm DESC
;

/*6. Estados Unidos: costos y precios unitarios promedio por estado.*/

SELECT
s.Name_State,
CAST(AVG(v.Unit_Cost) AS NUMERIC(12,2)) AS CostoPromTotal,
CAST(AVG(v.Unit_Price) AS NUMERIC(12,2)) AS PrecioPromTotal,
CAST((AVG(v.Unit_Price) - AVG(v.Unit_Cost)) AS numeric(12,2)) AS GananciaPorEstadoProm
FROM Ventas AS v
JOIN States AS s
ON v.ID_State = s.ID_State
JOIN Country AS c
ON v.ID_Country = c.ID_Country
WHERE c.Name_Country = 'United States'
GROUP BY s.Name_State
ORDER BY GananciaPorEstadoProm DESC
;

/*7. Alemania: edad promedio y cantidad de ventas seg�n g�nero.*/

SELECT
v.Customer_Gender,
CAST(AVG(v.Customer_Age) AS NUMERIC(12,2)) AS EdadPromedio,
COUNT(v.SaleIndex) AS Ventas
FROM Ventas AS v
JOIN Country AS c
ON v.ID_Country = c.ID_Country
WHERE c.Name_Country = 'Germany'
GROUP BY v.Customer_Gender
;

/*8. B�squedas puntuales. Quiero saber, por ejemplo, el pa�s, categor�a, subcategor�a y ganancia de producto de la venta con n�mero 15000.*/

SELECT
v.SaleIndex,
c.Name_Country,
p.Name_ProductCategory,
sub.Name_SubCategory,
CAST((v.Revenue - v.Cost) AS numeric(12,2)) AS Ganancia
FROM Ventas AS v
JOIN Country AS c
ON v.ID_Country = c.ID_Country
JOIN ProductCategory AS p
ON v.ID_ProductCategory = p.ID_ProductCategory
JOIN SubCategory AS sub
ON v.ID_SubCategory = sub.ID_SubCategory
WHERE v.SaleIndex = 15000
;

/*9. B�squedas puntuales. Quiero saber el g�nero, la edad, el estado donde compr� y la cantidad de productos que compr� de la venta con n�mero 25000.*/

SELECT
v.SaleIndex,
v.Customer_Gender,
v.Customer_Age,
s.Name_State,
v.Quantity
FROM Ventas AS v
JOIN States AS s
ON v.ID_State = s.ID_State
WHERE v.SaleIndex = 25000
;

/*10. B�squedas puntuales. Quiero saber el estado, el g�nero, la ganancia y la subcategor�a de producto de las ventas que se realizaron el dia 09/02/2016.
Para realizar esta consulta, voy a tener que modificar la tabla para poder encontrar de manera correcta la fecha: hay que modificar el tipo de dato de la columna 
Date, de datetime a date*/

ALTER TABLE Ventas
ALTER COLUMN [Date] Date
;

/*Ahora s� podemos realizar la consulta*/

SELECT
[Date],
v.Customer_Gender,
CAST((v.Revenue - v.Cost) AS numeric(12,2)) AS Ganancia,
sub.Name_SubCategory
FROM Ventas AS v
JOIN SubCategory AS sub
ON v.ID_SubCategory = sub.ID_SubCategory
WHERE [Date] = '2016/02/09'
;
