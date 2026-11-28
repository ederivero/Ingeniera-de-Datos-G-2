-- DDL Parte II
-- En psql para poder cambiar o seleccionar la bd que queremos usar:
-- \c tienda

CREATE TABLE pruebas (id SERIAL PRIMARY KEY, dato VARCHAR(500));

-- DROP sirve para eliminar 
DROP TABLE pruebas;


-- Vacia / Elimina toda la data de la tabla sin eliminar su estructura
TRUNCATE TABLE pruebas;

-- Podemos combinar el ALTER con el DROP para eliminar una columna, constraint
ALTER TABLE pruebas DROP COLUMN dato;

