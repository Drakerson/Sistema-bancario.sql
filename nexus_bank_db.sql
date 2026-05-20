USE nexus_bank_db;
CREATE TABLE direcciones(
id_direcciones INT AUTO_INCREMENT PRIMARY KEY,
id_cliente INT,
 tipo_direccion VARCHAR(50) NOT NULL,
 calle_numero VARCHAR(255) NOT NULL, 
 ciudad VARCHAR(50) NOT NULL,
 provincia VARCHAR(50) NOT NULL,
 codigo_postal VARCHAR(20) NOT NULL,
  FOREIGN KEY (id_cliente)  REFERENCES clientes(id_cliente)
  )