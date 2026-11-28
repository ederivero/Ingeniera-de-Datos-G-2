-- DML (Data Manipulation Language)
-- Aca ya no nos importa como hemos definido las tablas, columnas, relaciones, etc
-- Aca ya manejamos con los datos que tienen la tabla

-- INSERT sirve para agregar data

ALTER TABLE clientes RENAME COLUMN correo TO cliente_correo;
-- Al declarar una columna que tiene un valor por defecto y si queremos usar ese valor por defecto
-- entonces usaremos el comodin DEFAULT
INSERT INTO clientes (cliente_id, cliente_nombre, cliente_ciudad, cliente_correo) VALUES
(DEFAULT, 'Eduardo', 'Arequipa', 'ederivero@gmail.com'),
(DEFAULT, 'Roxana', 'Chiclayo', 'rruiz@hotmail.com'),
(DEFAULT, 'Javier Perez', 'Puno', 'jperez@gmail.com');

INSERT INTO productos VALUES (DEFAULT, 'Laptop', 3599.00),
							 (DEFAULT, 'Mouse Gamer 1080dpi', 315.19),
							 (DEFAULT, 'Teclado Drop Mecanico RGB', 473.48);

-- Al hacer un insert se puede evitar llamar a las columnas que tiene valor por defecto
-- o autoincrementables 
INSERT INTO pedidos (fecha, cliente_id) VALUES
					('2026-11-01', 1),
					('2026-10-18', 1),
					('2026-10-31', 2),
					('2026-09-28', 3);


INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio_unitario) VALUES
							(1, 1, 1, 3599.00),
							(1, 2, 1, 280.00),
							(2, 3, 2, 470.00),
							(3, 2, 3, 315.19),
							(3, 3, 3, 448.20),
							(4, 1, 1, 3345.80);



-- UPDATE > modificar los registros de la tabla
-- SIEMPRE EN EL UPDATE TENER UNA CONDICIONAL NUNCA DEJARLO LIBRE
-- BEGIN TRANSACTION;
-- ROLLBACK TRANSACTION;
-- WHERE Es la condicion que sirve para dar los resultados que cumplan con esa condicion
UPDATE productos 
SET precio_lista = 3349.99 
WHERE producto_id = 1;


INSERT INTO productos (nombre_producto, precio_lista) VALUES ('LAPTOP ULTRA PRO', 1.10);

-- DELETE > Elimina el registro de la tabla, no se elimina la tabla
-- SIEMPRE COLOCAR UN WHERE
DELETE FROM productos WHERE producto_id = 4;



-- SELECT > visualizar la data 
SELECT producto_id, nombre_producto FROM productos;
-- Si el nombre de la tabla es muy largo se puede poner alias
-- El alias sirve para poder simplificar el nombre de la tabla 
SELECT p.producto_id, p.nombre_producto FROM productos AS p;

-- En los select se pueden utilizar las condicionales para filtrar los datos segun sea necesario
SELECT p.producto_id, p.nombre_producto 
FROM productos AS p
WHERE p.precio_lista < 2000.99;

-- En el WHERE se pueden combinar varios filtros con los operadores AND y OR
-- x AND y > Se tienen que cumplir las dos condiciones para que el registro sea devuelto
-- x OR y  > Se tiene que cumplir al menos una de las dos condiciones 
SELECT p.producto_id, p.nombre_producto 
FROM productos AS p
WHERE p.precio_lista < 2000.99 AND p.precio_lista > 999.00;

SELECT p.producto_id, p.nombre_producto, p.precio_lista  
FROM productos AS p
WHERE p.precio_lista < 2000.99 OR p.precio_lista > 999.00;

-- El uso de parentesis es IMPORTANTISIMO
-- El orden de los parentesis , es decir, lo que esta en los parentesis sera validado primeramente
-- y luego lo que esta afuera
SELECT p.producto_id, p.nombre_producto, p.precio_lista  
FROM productos AS p
WHERE p.producto_id  < 3 AND (p.precio_lista < 999.00 AND p.precio_lista > 2);

-- Si queremos obtener todas las columnas implicadas entonces podemos usar el *
-- En el caso que tengamos en el ordenamiento dos registros con el mismo valor podemos usar un segundo
-- ordenamiento
SELECT * 
FROM clientes
ORDER BY cliente_nombre ASC, cliente_id DESC;

-- JOIN
-- INNER JOIN ()
-- Mostrar todos los clientes que tengan pedidos y todos los pedidos que tengan clientes
SELECT * 
FROM clientes AS c INNER JOIN pedidos AS p ON c.cliente_id = p.cliente_id ;


INSERT INTO clientes (cliente_nombre, cliente_ciudad, cliente_correo ) VALUES ('Juancito', 'Pucallpa', 'jyng@yahoo.es');

-- LEFT JOIN
-- Mostrar todos los clientes y que pedidos tienen
SELECT * 
FROM clientes AS c LEFT JOIN pedidos AS p ON c.cliente_id = p.cliente_id ;

-- RIGHT JOIN
-- Mostrar todos los pedidos y si tienen clientes
SELECT * 
FROM clientes AS c RIGHT JOIN pedidos AS p ON c.cliente_id = p.cliente_id ;

-- Los join se pueden trabar con mas de una interseccion

SELECT * 
FROM clientes AS c INNER JOIN pedidos AS p ON c.cliente_id = p.cliente_id 
				   INNER JOIN detalle_pedidos dp ON dp.pedido_id  = p.pedido_id  
				   INNER JOIN productos prod ON dp.producto_id = prod.producto_id  ;



SELECT c.cliente_nombre , p.pedido_id, p.fecha , dp.cantidad , dp.precio_unitario , prod.nombre_producto , prod.precio_lista  
FROM clientes AS c INNER JOIN pedidos AS p ON c.cliente_id = p.cliente_id 
				   INNER JOIN detalle_pedidos dp ON dp.pedido_id  = p.pedido_id  
				   INNER JOIN productos prod ON dp.producto_id = prod.producto_id;

