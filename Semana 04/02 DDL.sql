-- DDL Data Definition Language
-- CREATE | ALTER | DROP
-- INT Columnas netamente con contenido numerico
-- VARCHAR(60) > UTILIZARA el espacio de memoria NECESARIO para el texto
-- CHAR(60) > SIEMPRE se reservara un espacio de memoria para los 60 caracteres (~5kb)
-- Juan Paz Aquino
-- Juan Martin Pedro Rodriguez de los Castillos Humala

-- TEXT > ilimitado siempre usara lo que necesite

-- NUMERIC(p,s) > Almacenar precios o valores que tengan parte decimal en la cual 'p' indicara
-- cuandos enteros usaremos y 's' indicara cuantos decimales usaremos

-- DATE > Almacena fechas pero sin hora (Maximo el dia) 
-- ISO 8601 YYYY-MM-DD HH:MM:ssss:mmmm
-- TIMESTAMP > Almacena fechas hasta ms

-- BOOLEAN > Almacena dos unicos valores Verdadero(1) o Falso(0)


-- RESTRICCIONES
-- PRIMARY KEY : identifica la fila como llave primaria
-- FOREIGN KEY : identifica la columna como llave foranea y restringira sus valores a los valores en otra tabla
-- NOT NULL | NULL : No permite valores vacios, es decir siempre se tiene que poner valor
-- UNIQUE : No permite valores repetidos (unicidad)
-- CHECK : Valida una condicion estipulado 
-- DEFAULT : Asigna un valor por defecto si al momento de hacer la insercion no se le da un valor

CREATE DATABASE tienda;
CREATE TABLE clientes (
	cliente_id 		SERIAL 			PRIMARY KEY,
	cliente_nombre	VARCHAR(100)	NOT NULL,
	cliente_ciudad	VARCHAR(60)		NOT NULL
);

CREATE TABLE productos (
	producto_id		SERIAL			PRIMARY KEY,
	nombre_producto	VARCHAR(100)	NOT NULL UNIQUE,
	precio_lista	NUMERIC(10,2)	NOT NULL CHECK (precio_lista >=0)
);

CREATE TABLE pedidos (
	pedido_id		SERIAL			PRIMARY KEY,
	fecha			DATE			NOT NULL DEFAULT NOW(),
	cliente_id		INTEGER		NOT NULL, -- REFERENCES clientes(cliente_id)
	-- Otra forma de crear FK es poniendole nombre ala restriccion
	CONSTRAINT fk_pedidos_clientes FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);

CREATE TABLE detalle_pedidos (
	pedido_id		SERIAL 			NOT NULL,
	producto_id		INT				NOT NULL REFERENCES productos(producto_id),
	cantidad		INT				NOT NULL CHECK (cantidad> 0),
	precio_unitario	NUMERIC(10,2)	NOT NULL CHECK (precio_unitario >=0),
	PRIMARY KEY (pedido_id, producto_id),
	FOREIGN KEY (pedido_id) REFERENCES pedidos(pedido_id) ON DELETE CASCADE	
);







