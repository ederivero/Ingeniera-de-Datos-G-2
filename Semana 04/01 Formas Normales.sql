create database prueba2;

-- mas atomica es el dato
-- el dato va almacenado en una columna
-- columna pertenece a una tabla
-- tabla pertenece a una bd

-- Informacion es el dato con contexto
-- Eduardo (Nombre de un alumno)
-- Tabla es un conjunto de filas y columnas, la tabla representa una entidad
-- Fila: Registro de la tabla
-- Columna: un atributo de la tabla
-- Clave primaria (Primary Key PK) es una columna o un conjunto de columnas que 
-- identifican cada fila de forma unica
-- Clave foranea (Foreign Key FK) columna que referencia la clave primaria de otra tabla
-- Las tablas que no tienen FK (Foreign Key) se suelen llamar tablas Maestros

-- SQL (Structured Query Language) Lenguaje Estructurado de Consultas
-- DDL (Data Definition Language) Lenguaje de Definicion de Datos > CREATE, ALTER, DROP
-- DML (Data Manipulation Language) Lenguaje de Manipulacion de Datos > INSERT, UPDATE, DELETE, SELECT

-- Clientes
-- cliente_id (FK) | cliente_nombre | cliente_ciudad
-- 1		  	   | Eduardo Perez  | Arequipa
-- 2 		       | Ana Luisa M	| Cuzco

-- Por lo general las PK suelen ser autoincrementables
-- Ultimamente para evitar vulnerabilidades en nuestros registros se suele colocar las PK
-- con UUID (Universal Unique IDentifier) Identificador Unico Universal
-- Es un conjunto de numeros hexadecimales en el cual se genera aleatoriamente y jamas
-- se repite
-- 1234a
-- abcd4
-- 1956f
-- Numero hexadecimal es un numero que no solamente llega del 0-9 sino que ademas usa letras
-- desde la a - f (16 numeros en total)
-- a > 10
-- b2 

-- FORMAS NORMALES
-- La normalizacion forma de organizar las tablas para eliminar redundancia
-- Dependencias funcionales
-- La notacion A -> B indica que el valor de A determina el valor de B. 
-- Ejemplo: cliente_id > cliente_ciudad

-- En las tablas se puede tener como maximo una columna serial
-- Tabla sin normalizar
CREATE TABLE pedido_sin_normalizar (
	pedido_id 		INTEGER,
	fecha 			DATE,
	cliente_id 		INT,
	cliente_nombre	VARCHAR(100),
	cliente_ciudad	VARCHAR(60),
	productos		VARCHAR(500) -- varios productos en un solo campo
);


-- DML 
INSERT INTO pedido_sin_normalizar VALUES
(100, '2026-11-01', 1, 'Ana Perez', 'Ayacucho', 'Laptop:1:3500; Mouse:2:50'),
(101, '2026-11-03', 2, 'Luis Martinez', 'Cuzco', 'Teclado:1:120'),
(102, '2026-11-05', 1, 'Ana Perez', 'Ayacucho', 'Mouse:1:50');


-- 1FN una tabla esta en la 1FN cuando:
-- Cada columna guarda un valor atomico
-- No hay grupos repetidos de columnas
-- Cada fila tiene una clave primaria

CREATE TABLE pedido_1fn(
	pedido_id		INT,
	fecha			DATE,
	cliente_id		INT,
	cliente_nombre	VARCHAR(100),
	cliente_ciudad	VARCHAR(100),
	producto_id		INT,
	nombre_producto	VARCHAR(100),
	cantidad		INT,
	precio_unitario	NUMERIC(10,2),
	-- Colocamos la llave primaria de la tabla
	-- Las PK generalmente suelen ser de una sola columna PEEEERO hay escenarios en los
	-- cuales se debe agregar una conjuncion, es decir, que la restriccion indicara que 
	-- no se puede repetir los mismos valores de las dos o mas tablas en otro registro
	-- no puede haber dos registros con el mismo pedido_id y producto_id
	-- pedido_id		producto_id
	-- 100    			50
	-- 101				50
	-- 100				50 (X)
	-- 100				54	
	PRIMARY KEY (pedido_id, producto_id)
)

INSERT INTO pedido_1fn VALUES
(100, '2026-11-01', 1, 'Ana Perez', 'Ayacucho', 50, 'Laptop', 1, 3500.00),
(100, '2026-11-01', 1, 'Ana Perez', 'Ayacucho',20, 'Mouse', 2, 50.00),
(101, '2026-11-03', 2, 'Luis Martinez', 'Cuzco', 30,'Teclado', 1, 120.00),
(102, '2026-11-05', 1, 'Ana Perez', 'Ayacucho', 20,'Mouse', 1, 50.00);

-- Mal insert ya que se viola la restriccion de unicidad de la llave primaria compuesta
INSERT INTO pedido_1fn VALUES
(100, '2026-11-01', 1, 'Ana Perez', 'Ayacucho', 50, 'Laptop', 1, 3500.00);


-- 2FN
-- Estar en la 1FN
-- Ningun atributo que no es clave depende de una parte de la clave
-- El atributo nombre_producto depende solo de producto_id, separar esas dependencias

CREATE TABLE producto (
	producto_id	INT PRIMARY KEY,
	nombre_producto VARCHAR(100)
);

CREATE TABLE cliente (
	cliente_id INT PRIMARY KEY,
	cliente_nombre	VARCHAR(100),
	cliente_ciudad	VARCHAR(100)
);

CREATE TABLE detalle_pedido_2fn (
	pedido_id 		INT,
	fecha			DATE,
	producto_id 	INT,
	cliente_id 		INT,
	cantidad 		INT,
	precio_unitario NUMERIC(10,2),
	
	PRIMARY KEY (pedido_id, producto_id)
);

INSERT INTO producto VALUES (50, 'Laptop') , (20, 'Mouse'),(30,'Teclado');
INSERT INTO cliente VALUES (1, 'Ana Perez'),(2, 'Luis Martinez');
INSERT INTO detalle_pedido_2fn VALUES 
(100, '2026-11-01', 50, 1, 1, 3500.00),
(100, '2026-11-01', 20, 1, 2, 50.00),
(101, '2026-11-03', 30, 2, 1, 120.00),
(102, '2026-11-05', 20, 1, 1, 50.00);


-- Al no tener una restriccion en las representaciones de otras tablas tendremos errores de escritura
INSERT INTO detalle_pedido_2fn VALUES 
(100, '2026-11-01', 850, 1259, 1, 3500.00);
DELETE FROM detalle_pedido_2fn WHERE pedido_id = 100 AND cliente_id = 1259;


-- 3FN
-- Estar en 2FN
-- Ningun atributo que no es clave depende de otro atributo que no es clave
-- Esa dependencia se llama transitiva. Ejemplo> pedido_id > cliente_id
-- Se tiene que crear restricciones en las representaciones de otras tablas (FK)
CREATE TABLE detalle_pedido (
	pedido_id 		INT,
	fecha			DATE,
	producto_id 	INT REFERENCES producto(producto_id), -- Representacion de un producto de la tabla producto
	cliente_id 		INT REFERENCES cliente(cliente_id) , -- Representacion de un cliente
	cantidad 		INT,
	precio_unitario NUMERIC(10,2),
	
	PRIMARY KEY (pedido_id, producto_id)
);

INSERT INTO detalle_pedido VALUES 
(100, '2026-11-01', 50, 1, 1, 3500.00),
(100, '2026-11-01', 20, 1, 2, 50.00),
(101, '2026-11-03', 30, 2, 1, 120.00),
(102, '2026-11-05', 20, 1, 1, 50.00);

-- Ahora si no permitira insertar registros que tengan llaves foraneas incorrectas
INSERT INTO detalle_pedido VALUES 
(104, '2026-11-01', 50, 1259, 1, 3500.00);



