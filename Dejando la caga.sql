
USE CoderHouse

/* Consignas Clase 8 */

/* 1.- Indicar por jornada la cantidad de docentes que dictan y sumar los costos. 
Esta información sólo se desea visualizar para las asignaturas de desarrollo web. 
El resultado debe contener todos los valores registrados en la primera tabla, 
Renombrar la columna del cálculo de la cantidad de docentes como cant_docentes 
y la columna de la suma de los costos como suma_total. 
Keywords: Asignaturas,Staff, DocentesID, Jornada, Nombre, costo. */

-- PARA VER LAS TABLAS
SELECT * FROM Asignaturas
SELECT * FROM Staff 

-- COMIENZO DE LA SINTAXIS
SELECT T2.Jornada, 
COUNT(T1.DocentesID) AS Cant_Docentes, 
SUM(T2.Costo) AS suma_total				-- SELECCIONAMOS EL PRIMER TOPICO, JORNADA Y CONTAR DOCENTES, SUMAR LOS COSTOS PRIMERA PARTE
FROM Staff T1																			-- 
INNER JOIN Asignaturas T2				-- APLICAMOS UNION DE TABLAS VIENDO SOLO DONDE DOCENTE TIENE ASIGNATURAS (INNER FUNCIONA PARA ESTO)								
ON T1.Asignatura=T2.AsignaturasID		-- SELECCIONAMOS ASIGNATURAS COMO BASE DEL JOIN
WHERE T2.Nombre='Desarrollo Web'		-- CONDICIONAMOS A DESARROLLO WEB
GROUP BY T2.Jornada;					-- ORGANIZAMOS LA INFO


/* 2.-  Se requiere saber el id del encargado, el nombre, el apellido 
y cuantos son los docentes que tiene asignados cada encargado.
Luego filtrar los encargados que tienen como resultado 0 ya que 
son los encargados que NO tienen asignado un docente. 
Renombrar el campo de la operación como Cant_Docentes. 
Keywords: Docentes_id, Encargado, Staff, Nombre, Apellido,Encargado_ID. */

-- PARA VER LAS TABLAS
SELECT * FROM Encargado 
SELECT * FROM Staff 
 
 -- COMIENZO DE LA SINTAXIS
SELECT 
T1.Encargado_ID,
T1.Nombre, 
T1.Apellido,										-- HASTA AQUI LO PRIMERO QUE PIDE LA CONSIGNA
COUNT(T2.Encargado) AS Cant_Docentes
FROM Encargado T1									-- CONTAMOS LA CANTIDAD DE ENCARGADOS QUE TIENE CADA DOCENTE
LEFT JOIN Staff T2
ON T1.Encargado_ID = T2.Encargado					-- NUESTRA CONSIGNA PIDE LA UNION RESPECTO AL ENCARGADO
WHERE T1.Tipo LIKE '%Docentes%'						-- FILTRAR POR QUIENES SON ENCARGADO DE DOCENTES
GROUP BY T1.Encargado_ID, T1.Nombre, T1.Apellido	-- DEFINIMOS POR LO QUE SOLICITAMOS EN EL SELECT 
HAVING COUNT(T2.Encargado) = 0						-- LAS SENTENCIAS DE AGREGACION NO APILAN CON WHERE, SOLO CON HAVING LUEGO UN ORDER BY

-- RENATO FERNANDEZ QUEDA FUERA CON EL WHERE PERO DE ESTOS AMBOS ESTE ES TUTOR
-- ISAAC HENRIQUEZ ESTE ENTRA CON EL WHERE ESTE SI ES DOCENTE


-- esta es la sentencia del profe, me quedo con la duda porque supuestamente era solo docentes
select
t1.Encargado_ID,
t1.Nombre,
t1.Apellido,
count(t2.DocentesID)as Cant_docentes
from Encargado t1
Left join staff t2 on t1.Encargado_ID=t2.Encargado
GROUP by t1.Encargado_ID,t1.Nombre,t1.Apellido
having COUNT(t2.DocentesID)=0   
-- esta es la sentencia del profe, me quedo con la duda porque supuestamente era solo docentes


/* 3.- Se requiere saber todos los datos de asignaturas que no tienen 
un docente asignado.El modelo de la consulta debe partir desde la tabla docentes.
Keywords: Staff, Encargado, Asignaturas, costo, Area */ 

-- PARA VER LAS TABLAS
SELECT * FROM Encargado
SELECT * FROM Asignaturas

-- COMIENZO DE LA SINTAXIS
SELECT T2.*			 					-- TODOS LOS DATOS DE ASIGNATURA
FROM Staff T1							-- PARTIMOS DE LA TABLA Staff
RIGHT JOIN Asignaturas T2				-- SEGUNDEAMOS TABLA DE Asignaturas, COMO NOS PIDE PARTIR DE LA TABLA DOCENTES ES RIGHT (SEGUNDA OPCION)
ON T1.Asignatura = T2.AsignaturasID		-- NUESTRO VALOR A TOMAR ENTRE TABLAS ES SI EL VALOR Asignatura ESTÁ TOMADO POR UN STAFF
WHERE T1.Asignatura IS NULL				-- ELIMINAMOS LOS REGRISTROS QUE ESTEN EN AMBAS TABLAS (QUEREMOS LAS ASIGNATURAS QUE NO TIENEN RELACION CON STAFF)

/* ESTE ES EL RESULTADO DEL PROFE, AMBAS FUNCIONAN IGUAL
select
t2.*
from Staff t1
right join Asignaturas t2 on t1.Asignatura=t2.AsignaturasID
where t1.Encargado is null
group by t1.Encargado,t2.AsignaturasID,t2.Area,t2.Costo,t2.Jornada,t2.Jornada,t2.Nombre,t2.Tipo  
ESTE ES EL RESULTADO DEL PROFE, AMBAS FUNCIONAN IGUAL */

-- COMPROBADOR SI LA ASIGNATURA TIENE PROFESOR O NO
SELECT * 
FROM Staff
WHERE Asignatura = 34

/* 4.- Se quiere conocer la siguiente información de los docentes. 
El nombre completo concatenar el nombre y el apellido. 
Renombrar NombresCompletos, el documento, hacer un cálculo para conocer los meses de ingreso. 
Renombrar meses_ingreso, el nombre del encargado. 
Renombrar NombreEncargado, el teléfono del encargado. 
Renombrar TelefonoEncargado, el nombre del curso o carrera, la jornada y el nombre del área. 
Solo se desean visualizar solo los que llevan más de 3 meses.
Ordenar los meses de ingreso de mayor a menor.  
Keywords: Encargo,Area,Staff,jornada, fecha ingreso. */

-- PARA VER LAS TABLAS
SELECT * FROM Staff
SELECT * FROM Encargado
SELECT * FROM Asignaturas

-- COMIENZO DE LA SINTAXIS
SELECT 
CONCAT(T1.Nombre, ' ', T1.Apellido) AS NombreDocente,  -- CONCATENAMOS NOMBRE Y APELLIDO, RENOMBRAMOS 
T1.Documento,										
DATEDIFF(MONTH, (T1.[Fecha Ingreso]), GETDATE()) AS meses_ingreso,  -- OBTENEMOS LOS MESES DE INGRESO A LA FECHA
T2.Nombre AS NombreEncargado,
T2.Telefono AS TelefonoEncargado,
T3.Tipo,											-- FINALMENTE, EN EL SEGUNDO LEFT JOIN AGREGAMOS QUE PIDE TIPO JORNADA Y AREA DE ASIGNATURAS
T3.Jornada,
T3.Area
FROM Staff T1
LEFT JOIN Encargado T2
ON T1.Encargado = T2.Encargado_ID                   -- PRIMER JOIN OBTENEMOS LA RELACION DE STAFF CON ENCARGADO
LEFT JOIN Asignaturas T3
ON T3.AsignaturasID = T1.Asignatura                  -- SEGUNDO JOIN OBTENEMOS RELACION DE STAFF CON LA ASIGNATURA QUE IMPARTE
WHERE DATEDIFF(MONTH, (T1.[Fecha Ingreso]), GETDATE()) > 3-- VISUALIZAMOS SOLO AQUELLOS QUE LLEVAN MAS DE 3 MESES
ORDER BY meses_ingreso ASC

-- COMPROBACION CON CRISTOPHER ARAYA QUE SUPUESTAMENTE HACE CURSO TARDE AREA 2 42
-- LUISA ALVAREZ CARRERA TARDE 2 130
SELECT Tipo, Jornada, Area
FROM Asignaturas
WHERE AsignaturasID = 42
UNION
SELECT Tipo, Jornada, Area
FROM Asignaturas
WHERE AsignaturasID = 130
-- APROVAO JAJAN`T


/* 5.- Se requiere una listado unificado con nombre, apellido, documento y una marca indicando a que base corresponde. 
Renombrar como Marca 
Keywords: Encargo,Staff,Estudiantes */ 

-- TABLAS CON NOMBRE Y APELLIDO
SELECT count(*) FROM Encargado
100
SELECT COUNT(*) FROM Estudiantes
1000
SELECT COUNT(*) FROM Staff
300
-- DEBO TENER 1400 VALORES EN MI NUEVA LISTA
-- SERIAN LAS 3 TABLAS A UNIFICAR

-- COMIENZO DE LA SINTAXIS
SELECT 
Nombre, 
Apellido, 
Documento, 
'Encargado' AS Marca		-- MARCA DE ENCARGADOS
FROM Encargado
UNION						-- UNIMOS CON LA SIGUIENTE TABLA
SELECT 
Nombre, 
Apellido, 
Documento,
'Estudiante' AS Marca		-- MARCA DE ESTUDIANTES
FROM Estudiantes
UNION						-- UNIMOS CON LA SIGUIENTE TABLA
SELECT 
Nombre, 
Apellido, 
Documento,
'Staff' AS MARCA			-- MARCA DE STAFF
FROM Staff

FIN CONSIGA 8