USE  nexus_bank_db;
 CREATE TABLE pago_prestamos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_prestamo INT,
    monto_pagado DECIMAL(15,2) NOT NULL CHECK (monto_pagado > 0),
    fecha_pago DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
       FOREIGN KEY (id_prestamo) REFERENCES prestamos(id_prestamo)
       );