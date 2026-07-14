/* =========================================================================
   PROYECTO: NEXUS BANK - SISTEMA DE GESTIÓN DE BASE DE DATOS RELACIONAL
   DESCRIPCIÓN: Diseño e implementación de la arquitectura de datos para un 
                banco, incluyendo gestión de clientes, cuentas, tarjetas, 
                préstamos y automatización de pagos.
   ========================================================================= */

-- -------------------------------------------------------------------------
-- FASE 1: CREACIÓN DE LA ESTRUCTURA BASE (DDL - Data Definition Language)
-- -------------------------------------------------------------------------

-- 1. TABLA PRINCIPAL: Clientes
-- Es el núcleo del sistema. Todas las demás tablas dependen de esta.
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. TABLA: Direcciones (Relación 1:N con Clientes)
-- Permite que un cliente tenga múltiples direcciones (Trabajo, Residencial).
CREATE TABLE direcciones (
    id_direccion INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    tipo_direccion VARCHAR(20) NOT NULL,
    calle_numero VARCHAR(150) NOT NULL,
    ciudad VARCHAR(50) NOT NULL,
    provincia VARCHAR(50) NOT NULL,
    codigo_postal VARCHAR(10),
    CONSTRAINT fk_direccion_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- 3. TABLA: Contactos (Relación 1:N con Clientes)
-- Implementa un candado (CHECK) para obligar a que el tipo sea solo Celular o Correo.
CREATE TABLE contactos (
    id_contacto INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    tipo_contacto VARCHAR(20) CHECK (tipo_contacto IN ('Celular', 'Correo')),
    valor_contacto VARCHAR(100) NOT NULL,
    es_principal BOOLEAN DEFAULT 0,
    CONSTRAINT fk_contacto_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- 4. TABLA: Cuentas (Relación 1:N con Clientes)
-- Usa DECIMAL(15,2) para manejar dinero con exactitud (hasta centavos).
CREATE TABLE cuentas (
    id_cuenta INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    tipo_cuenta VARCHAR(50) NOT NULL,
    saldo_actual DECIMAL(15,2) DEFAULT 0.00,
    CONSTRAINT fk_cuenta_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- 5. TABLA: Tarjetas (Relación 1:1 o 1:N con Cuentas)
-- Vincula el plástico bancario directamente al saldo de una cuenta.
CREATE TABLE tarjetas (
    id_tarjeta INT AUTO_INCREMENT PRIMARY KEY,
    id_cuenta INT NOT NULL,
    numero_tarjeta VARCHAR(16) NOT NULL UNIQUE,
    nombre_titular VARCHAR(100) NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    cvv VARCHAR(4) NOT NULL,
    CONSTRAINT fk_tarjeta_cuenta FOREIGN KEY (id_cuenta) REFERENCES cuentas(id_cuenta)
);

-- 6. TABLA: Préstamos (Relación 1:N con Clientes)
-- Registra el crédito otorgado. El estado por defecto es 'Activo'.
CREATE TABLE prestamos (
    id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    monto_aprobado DECIMAL(15,2) NOT NULL,
    tasa_interes DECIMAL(5,2) NOT NULL,
    plazo_meses INT NOT NULL,
    estado VARCHAR(20) DEFAULT 'Activo',
    CONSTRAINT fk_prestamo_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- 7. TABLA: Pago de Préstamos (Relación 1:N con Préstamos)
-- Libro mayor de amortizaciones. Registra cada abono de capital.
CREATE TABLE pago_prestamos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_prestamo INT NOT NULL,
    monto_pagado DECIMAL(15,2) NOT NULL,
    fecha_pago DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pago_prestamo FOREIGN KEY (id_prestamo) REFERENCES prestamos(id_prestamo)
);


-- -------------------------------------------------------------------------
-- FASE 2: POBLACIÓN DE DATOS MOCK (DML - Data Manipulation Language)
-- -------------------------------------------------------------------------

-- Inserción de Direcciones (Ejemplo de segmentación geográfica)
INSERT INTO direcciones (id_cliente, tipo_direccion, calle_numero, ciudad, provincia, codigo_postal)
VALUES
    (2, 'Trabajo', 'Av. Libertad #12, Centro', 'Bonao', 'Monseñor Nouel', '42000'),
    (3, 'Residencial', 'Calle Duarte #85, Los Multi', 'Bonao', 'Monseñor Nouel', '42000'),
    (4, 'Trabajo', 'Calle Aniana Vargas #40, Sector Eljardín', 'Bonao', 'Monseñor Nouel', '42000'),
    (5, 'Residencial', 'Calle 12 #5, Barrio Prosperidad', 'Bonao', 'Monseñor Nouel', '42000');
    -- (Nota: Puedes añadir el resto de los registros que insertamos previamente).

-- Inserción de Contactos (Respetando el CHECK de 'Celular' y 'Correo')
INSERT INTO contactos (id_cliente, tipo_contacto, valor_contacto, es_principal)
VALUES
    (2, 'Celular', '809-290-2002', 1),
    (2, 'Correo', 'carlos.mendoza@email.com', 0),
    (3, 'Celular', '829-385-3003', 1),
    (3, 'Correo', 'maria.vargas@email.com', 0);

-- Inserción de Emisión de Tarjetas
INSERT INTO tarjetas (id_cuenta, numero_tarjeta, nombre_titular, fecha_vencimiento, cvv)
VALUES 
    (27, '4540234567890123', 'CARLOS MENDOZA', '2031-05-01', '152'),
    (28, '4540345678901234', 'MARIA VARGAS', '2031-08-01', '463'),
    (29, '4540456789012345', 'JOSE LUCAS', '2031-11-01', '782');

-- Inserción de Transacciones (Abonos a Préstamos)
INSERT INTO pago_prestamos (id_prestamo, monto_pagado, fecha_pago)
VALUES 
     (1, 12238.16, CURRENT_TIMESTAMP),
     (2, 5646.57, CURRENT_TIMESTAMP),
     (3, 5646.57, CURRENT_TIMESTAMP),
     (4, 5646.57, CURRENT_TIMESTAMP);


-- -------------------------------------------------------------------------
-- FASE 3: AUTOMATIZACIÓN Y REPORTES AVANZADOS (Vistas y Triggers)
-- -------------------------------------------------------------------------

-- VISTA: Reporte Gerencial de Clientes
-- Propósito: Consolidar datos de 5 tablas diferentes usando LEFT JOIN para 
-- crear un modelo de datos plano, ideal para conectar a herramientas de BI (Power BI).
CREATE VIEW v_reporte_gerencial_clientes AS
SELECT 
    c.id_cliente,
    c.nombre AS nombre_cliente,
    d.ciudad,
    d.provincia,
    co.valor_contacto AS celular,
    cu.id_cuenta,
    cu.saldo_actual,
    p.monto_aprobado AS credito_otorgado,
    p.estado AS estado_prestamo
FROM clientes c
LEFT JOIN direcciones d ON c.id_cliente = d.id_cliente AND d.tipo_direccion = 'Residencial'
LEFT JOIN contactos co ON c.id_cliente = co.id_cliente AND co.tipo_contacto = 'Celular'
LEFT JOIN cuentas cu ON c.id_cliente = cu.id_cliente
LEFT JOIN prestamos p ON c.id_cliente = p.id_cliente;

-- TRIGGER: Auditoría de Cierre de Préstamos
-- Propósito: Automatizar la lógica de negocio bancaria. Al registrar un pago,
-- el motor calcula el saldo restante. Si la deuda llega a cero, cambia el estado
-- del préstamo a 'Pagado' de forma automática, previniendo errores humanos.
DELIMITER $$

CREATE TRIGGER tg_auditar_cierre_prestamo
AFTER INSERT ON pago_prestamos
FOR EACH ROW
BEGIN
    DECLARE total_abonado DECIMAL(15,2);
    DECLARE monto_credito DECIMAL(15,2);
    
    -- Sumar todos los pagos realizados a ese préstamo
    SELECT SUM(monto_pagado) INTO total_abonado 
    FROM pago_prestamos 
    WHERE id_prestamo = NEW.id_prestamo;
    
    -- Obtener el monto original aprobado
    SELECT monto_aprobado INTO monto_credito 
    FROM prestamos 
    WHERE id_prestamo = NEW.id_prestamo;
    
    -- Si el cliente pagó la totalidad, actualizar el estado
    IF total_abonado >= monto_credito THEN
        UPDATE prestamos 
        SET estado = 'Pagado' 
        WHERE id_prestamo = NEW.id_prestamo;
    END IF;
END$$

DELIMITER ;
