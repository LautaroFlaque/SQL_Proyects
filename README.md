# SQL Server — Consultas de análisis

Proyectos con los que practiqué el tipo de consultas que se presentan en el día a día de análisis de datos comercial/contable: agregaciones, joins entre tablas de dimensión, subqueries, CTEs y funciones de ventana. Las dos bases son datasets públicos y conocidos (no datos ficticios armados a mano): el de estudiantes es el clásico "Students Performance in Exams" de Kaggle (~1000 filas), y el de ciclismo es un dataset de ventas de bicicletas también público, con las tablas normalizadas en dimensiones (Country, States, ProductCategory, SubCategory) para poder practicar joins reales.

---

## 🚴 Ventas de ciclismo (`VentasCiclismoProject.sql`)

Análisis de ventas de una tienda de bicicletas con operaciones en 6 países (Australia, Canadá, Estados Unidos, Alemania, Francia y Reino Unido), cruzando costos, precios y cantidades contra las dimensiones de producto y geografía. Incluye, además de las agregaciones por país/categoría/género, una consulta con `RANK() OVER (PARTITION BY ...)` para sacar el top 3 de subcategorías más rentables en cada país sin tener que escribir una consulta por país.

**Resultados** (calculados sobre el dataset real, 113.036 filas):

El promedio general esconde bastante variación entre productos: **Bicicletas de ruta (Road Bikes)** son la subcategoría más rentable en ganancia total (~10,08M), seguida de Mountain Bikes (~8,16M) y Helmets (~3,38M) — y ese podio se repite exactamente igual en los 6 países cuando se lo mide por país (consulta 11): las bicicletas dominan la ganancia total en todos lados, mientras que accesorios y ropa son más bien un juego de volumen (Tires and Tubes vende 514.051 unidades pero aporta bastante menos ganancia total que Road Bikes).

Por país, **Estados Unidos** genera la mayor ganancia total (~11,07M), seguido de Australia (~6,78M); pero si se mira la ganancia *promedio por unidad vendida* (consulta 3), el orden cambia por completo: Australia lidera (~248 de ganancia promedio por unidad) y Estados Unidos cae al quinto lugar de seis (~170), apenas por encima de Canadá que es el último (~95) — es decir, EE.UU. gana más en total simplemente por volumen, no porque cada venta individual sea más rentable. Dentro de EE.UU., Massachusetts tiene la ganancia promedio por unidad más alta (1.054), muy por encima del resto de los estados.

Por categoría de producto, Bikes tiene una ganancia promedio por unidad (~770) muy superior a Clothing (~15) y Accessories (~11), como es esperable dado el precio unitario de cada rubro. Por género, la diferencia es marginal: los hombres generan levemente más ventas y ganancia total que las mujeres (58.312 vs. 54.724 ventas), pero la proporción es pareja. En Alemania puntualmente, la edad promedio de compra es prácticamente igual entre géneros (35,2 años en mujeres, 34,5 en hombres) y el volumen de ventas también está parejo (5.572 vs. 5.526).

**Nota de calidad de datos:** el dataset público tiene años duplicados — las 24.443 filas de 2013 son un duplicado exacto de las 24.443 filas de 2015, las 29.398 de 2014 se repiten igual en 2016, y lo mismo pasa entre 2011 y 2012 (2.677 filas cada uno). Es un defecto conocido del dataset original, no algo introducido acá, pero vale la pena tenerlo en cuenta: cualquier análisis que agrupe por año sin filtrar esto va a contar cada operación real dos veces.

Las consultas 8, 9 y 10 son búsquedas puntuales por número de venta o fecha (pensadas para mostrar cómo se combinan los joins para responder una pregunta concreta sobre un registro), así que no tienen un "resultado" agregado que resumir acá — el resultado depende de qué número de venta o fecha se consulte.

---

## 🎓 Rendimiento de estudiantes (`StudentsProject.sql`)

Análisis de las notas de matemática, lectura y escritura de 1000 estudiantes, cruzadas contra género, grupo étnico, hábitos de estudio y contexto familiar. Incluye limpieza de nulos, agregaciones con `GROUP BY`, subqueries, y dos consultas reescritas con CTE y `SUM(CASE WHEN...)` para evitar repetir la misma lógica dos o tres veces (antes eran 4 consultas casi idénticas, ahora son 2).

**Resultados verificados** contra el dataset público real (1000 filas, sin nulos en género/grupo étnico/notas):

El promedio general es 66,09 en matemática, 69,17 en lectura y 68,05 en escritura (consulta 1). Por género (consulta 2), se da un patrón cruzado interesante: los varones promedian más alto en matemática (68,73 vs. 63,63 en mujeres), pero las mujeres promedian más alto tanto en lectura (72,61 vs. 65,47) como en escritura (72,47 vs. 63,31) — la brecha en lectura/escritura a favor de las mujeres es incluso más grande que la brecha en matemática a favor de los varones.

De los 1000 estudiantes, 365 quedan por debajo del promedio en los tres exámenes a la vez (con un promedio de 51,71/54,73/52,95) y 374 quedan por encima en los tres a la vez (80,19/82,98/82,13) — consulta 6. Por grupo étnico (consultas 7 y 8), el grupo C es el más numeroso (319 estudiantes), mientras que el grupo A es el menos numeroso (89) y a la vez el que peor promedia en las tres materias (61,63 / 64,67 / 62,67); el grupo E, el segundo grupo más chico (140), es en cambio el que mejor promedia (73,82 / 73,03 / 71,41) — el tamaño del grupo no explica el desempeño.

**Pendiente:** las consultas 3, 4, 5 y 9 (horas de estudio semanales, práctica de deportes, y cantidad de hermanos/orden de nacimiento) necesitan columnas — `WklyStudyHours`, `PracticeSport`, `NrSiblings`, `IsFirstChild` — que no están en el dataset base de Kaggle que usé para verificar los resultados de arriba; existen en una versión "extendida" de este mismo dataset que todavía no tengo confirmada. La lógica de esas consultas ya está resuelta (9 quedó reescrita con `SUM(CASE WHEN...)` en una sola consulta en vez de dos), pero los resultados de esa sección se completan cuando se consiga el CSV extendido.

---

## Stack

`SQL Server` · `T-SQL` (CTEs, funciones de ventana, subqueries correlacionadas y no correlacionadas)
