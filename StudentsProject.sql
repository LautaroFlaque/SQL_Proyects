USE StudentsProject

;

/*En primer lugar, traemos todos los datos de la tabla Students.*/

SELECT *

FROM Students

;

/*Podemos ver antes que nada que existen valores nulos.

Podría eliminar las filas que contengan algún valor nulo,

pero significaría una pérdida de otros datos que pueden servirnos de mucho.

Por lo tanto lo dejamos así. Cuando tengamos que realizar las consultas, filtramos los valores nulos con IS NOT NULL*/

/*Nota sobre la columna F1: es un artefacto de cuando se importó el CSV original a la tabla sin asignarle

nombre a la primera columna (SQL Server la nombró F1 por default al importarla). En la práctica es el

índice de fila / ID de cada estudiante; se usa en las consultas de abajo únicamente para contar filas

con COUNT(). Si tuviera que rehacer la tabla, la llamaría StudentID.*/

/* Preguntas:

1. Promedio de notas general.

2. Promedio de notas según género.

3. Promedio de notas según cantidad de horas de estudio semanales.

4. Promedio de notas según práctica de deportes del estudiante.

5. Recuento de estudiantes según género y práctica de deportes.

6. Cantidad de alumnos con notas menores y mayores al promedio en los tres exámenes.

7. Recuento de estudiantes según el grupo étnico.

8. Promedio de notas según grupo étnico.

9. Recuento de estudiantes, teniendo en cuenta cantidad de hermanos y si son primeros hijos.

*/

/*1. Promedio de notas general.*/

SELECT

COUNT(F1) AS Students,

CAST(AVG(MathScore) AS NUMERIC(5,2)) AS MathScoreAverage,

CAST(AVG(ReadingScore) AS NUMERIC(5,2)) AS ReadingScoreAverage,

CAST(AVG(WritingScore) AS NUMERIC(5,2)) AS WritingScoreAverage

FROM Students

;

/*2. Promedio de notas según género.*/

SELECT

Gender,

CAST(AVG(MathScore) AS NUMERIC(5,2)) AS MathScoreAverage,

CAST(AVG(ReadingScore) AS NUMERIC(5,2)) AS ReadingScoreAverage,

CAST(AVG(WritingScore) AS NUMERIC(5,2)) AS WritingScoreAverage

FROM Students

GROUP BY Gender

;

/*3. Promedio de notas según cantidad de horas de estudio semanales.*/

SELECT

WklyStudyHours,

CAST(AVG(MathScore) AS NUMERIC(5,2)) AS MathScoreAverage,

CAST(AVG(ReadingScore) AS NUMERIC(5,2)) AS ReadingScoreAverage,

CAST(AVG(WritingScore) AS NUMERIC(5,2)) AS WritingScoreAverage

FROM Students

WHERE WklyStudyHours IS NOT NULL

GROUP BY WklyStudyHours

ORDER BY MathScoreAverage DESC

;

/*4. Promedio de notas según práctica de deportes del estudiante.*/

SELECT

PracticeSport,

CAST(AVG(MathScore) AS NUMERIC(5,2)) AS MathScoreAverage,

CAST(AVG(ReadingScore) AS NUMERIC(5,2)) AS ReadingScoreAverage,

CAST(AVG(WritingScore) AS NUMERIC(5,2)) AS WritingScoreAverage

FROM Students

WHERE PracticeSport IS NOT NULL

GROUP BY PracticeSport

;

/*5. Recuento de estudiantes según género y práctica de deportes.*/

SELECT

Gender,

PracticeSport,

COUNT(F1) AS Students

FROM Students

WHERE Gender IS NOT NULL AND PracticeSport IS NOT NULL

GROUP BY Gender, PracticeSport

ORDER BY Gender

;

/*6. Cantidad de alumnos con notas menores y mayores al promedio en los tres exámenes.

Antes esto eran dos consultas separadas (6a y 6b), cada una repitiendo el mismo subquery de AVG

tres veces (una por materia) para poder compararlo contra la fila. Con un CTE calculamos los tres

promedios una sola vez arriba y los reutilizamos para ambas comparaciones con SUM(CASE WHEN...),

en una sola consulta.*/

WITH Promedios AS (

SELECT

AVG(MathScore) AS MathAvg,

AVG(ReadingScore) AS ReadingAvg,

AVG(WritingScore) AS WritingAvg

FROM Students

)

SELECT

SUM(CASE WHEN s.MathScore < p.MathAvg AND s.ReadingScore < p.ReadingAvg AND s.WritingScore < p.WritingAvg THEN 1 ELSE 0 END) AS StudentsBelowAvgAllThree,

SUM(CASE WHEN s.MathScore > p.MathAvg AND s.ReadingScore > p.ReadingAvg AND s.WritingScore > p.WritingAvg THEN 1 ELSE 0 END) AS StudentsAboveAvgAllThree,

CAST(p.MathAvg AS NUMERIC(5,2)) AS MathScoreAverage,

CAST(p.ReadingAvg AS NUMERIC(5,2)) AS ReadingScoreAverage,

CAST(p.WritingAvg AS NUMERIC(5,2)) AS WritingScoreAverage

FROM Students AS s

CROSS JOIN Promedios AS p

;

/*7. Recuento de estudiantes según el grupo étnico.*/

SELECT

COUNT(F1) AS Students,

EthnicGroup

FROM Students

WHERE EthnicGroup IS NOT NULL

GROUP BY EthnicGroup

;

/*8. Promedio de notas según grupo étnico.*/

SELECT

EthnicGroup,

CAST(AVG(MathScore) AS NUMERIC(5,2)) AS MathScoreAverage,

CAST(AVG(ReadingScore) AS NUMERIC(5,2)) AS ReadingScoreAverage,

CAST(AVG(WritingScore) AS NUMERIC(5,2)) AS WritingScoreAverage

FROM Students

WHERE EthnicGroup IS NOT NULL

GROUP BY EthnicGroup

ORDER BY MathScoreAverage DESC

;

/*9. Recuento de estudiantes según cantidad de hermanos, agrupados en rangos (sin hermanos / de uno a

tres / de cuatro a siete), separado por si son o no primeros hijos.

Antes esto eran dos consultas casi idénticas (9a filtraba IsFirstChild = 'yes', 9b lo mismo con 'no'),

cada una con tres subqueries de COUNT repetidas contra la misma tabla. Con SUM(CASE WHEN...) agrupando

directamente por IsFirstChild, se resuelve todo en una sola pasada sobre la tabla.*/

SELECT

IsFirstChild,

SUM(CASE WHEN NrSiblings = 0 THEN 1 ELSE 0 END) AS NoSiblings,

SUM(CASE WHEN NrSiblings BETWEEN 1 AND 3 THEN 1 ELSE 0 END) AS OneToThreeSiblings,

SUM(CASE WHEN NrSiblings BETWEEN 4 AND 7 THEN 1 ELSE 0 END) AS FourToSevenSiblings

FROM Students

WHERE IsFirstChild IS NOT NULL AND NrSiblings IS NOT NULL

GROUP BY IsFirstChild

;
