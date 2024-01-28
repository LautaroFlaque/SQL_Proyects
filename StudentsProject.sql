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

/*6a. Cantidad de alumnos con notas menores al promedio en los tres exámenes*/

SELECT
COUNT(F1) AS StudentsScoresLessThanAVG,
CAST(AVG(MathScore) AS NUMERIC(5,2)) AS MathScoreAverage,
CAST(AVG(ReadingScore) AS NUMERIC(5,2)) AS ReadingScoreAverage,
CAST(AVG(WritingScore) AS NUMERIC(5,2)) AS WritingScoreAverage
FROM Students
WHERE MathScore < (SELECT
                   CAST(AVG(MathScore) AS NUMERIC(5,2))
				   FROM Students)
AND ReadingScore < (SELECT
                    CAST(AVG(ReadingScore) AS NUMERIC(5,2))
				    FROM Students)
AND WritingScore < (SELECT
                    CAST(AVG(WritingScore) AS NUMERIC(5,2))
				    FROM Students)
;

/*6b. Cantidad de alumnos con notas mayores al promedio en los tres exámenes*/

SELECT
COUNT(F1) AS StudentsScoresMoreThanAVG,
CAST(AVG(MathScore) AS NUMERIC(5,2)) AS MathScoreAverage,
CAST(AVG(ReadingScore) AS NUMERIC(5,2)) AS ReadingScoreAverage,
CAST(AVG(WritingScore) AS NUMERIC(5,2)) AS WritingScoreAverage
FROM Students
WHERE MathScore > (SELECT
                   CAST(AVG(MathScore) AS NUMERIC(5,2))
				   FROM Students)
AND ReadingScore > (SELECT
                    CAST(AVG(ReadingScore) AS NUMERIC(5,2))
				    FROM Students)
AND WritingScore > (SELECT
                    CAST(AVG(WritingScore) AS NUMERIC(5,2))
				    FROM Students)
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

/*9a. Recuento de estudiantes, teniendo en cuenta cantidad de hermanos y si son los primeros hijos.*/

SELECT
COUNT(F1) AS Students,
UPPER(IsFirstChild) AS IsFirstChild,
NrSiblings
FROM Students
WHERE IsFirstChild IS NOT NULL AND NrSiblings IS NOT NULL
GROUP BY IsFirstChild, NrSiblings
ORDER BY NrSiblings ASC
;

/*9b. Podríamos hacer un recuento más útil en función de la cantidad de hermanos que tienen.
Lo agrupo de acuerdo a si los estudiantes tienen de uno a tres hermanos, si tienen cuatro o más o si no tienen.*/

SELECT
IsFirstChild,
(SELECT COUNT(F1) FROM Students WHERE NrSiblings = 0 AND IsFirstChild = 'no') AS NoSiblings,
(SELECT COUNT(F1) FROM Students WHERE NrSiblings BETWEEN 1 AND 3 AND IsFirstChild = 'no') AS OneToThreeSiblings,
(SELECT COUNT(F1) FROM Students WHERE NrSiblings BETWEEN 4 AND 7 AND IsFirstChild = 'no') AS FourToSevenSiblings
FROM Students
WHERE IsFirstChild IS NOT NULL AND NrSiblings IS NOT NULL AND IsFirstChild = 'no'
GROUP BY IsFirstChild
;

SELECT
IsFirstChild,
(SELECT COUNT(F1) FROM Students WHERE NrSiblings = 0 AND IsFirstChild = 'yes') AS NoSiblings,
(SELECT COUNT(F1) FROM Students WHERE NrSiblings BETWEEN 1 AND 3 AND IsFirstChild = 'yes') AS OneToThreeSiblings,
(SELECT COUNT(F1) FROM Students WHERE NrSiblings BETWEEN 4 AND 7 AND IsFirstChild = 'yes') AS FourToSevenSiblings
FROM Students
WHERE IsFirstChild IS NOT NULL AND NrSiblings IS NOT NULL AND IsFirstChild = 'yes'
GROUP BY IsFirstChild
;
