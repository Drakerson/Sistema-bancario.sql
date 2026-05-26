ALTER TABLE cuentas
ADD CONSTRAINT chk_estado_cuenta 
CHECK (estado IN ('Activa', 'Inactiva', 'Bloqueada', 'Cerrada'));

INSERT INTO tipos_cuentas (nombre_tipo, tasa_interes) 
VALUES 
    ('Ahorro', 2.50),
    ('Corriente', 0.00);
 
    
   
INSERT INTO tipos_transacciones (nombre_transaccion)
VALUES 
    ('Depósito'),
    ('Retiro'),
    ('Transferencia');
  
 

      
   INSERT INTO cuentas (id_cliente, id_tipo_cuenta, fecha_apertura, numero_cuenta, saldo_actual, estado)
VALUES 
    (1, 1, CURRENT_DATE, '100-000001-1', 15500.50, 'Activa'),
    (2, 2, CURRENT_DATE, '100-000002-2', 8230.00, 'Activa'),
    (3, 1, CURRENT_DATE, '100-000003-3', 230.05, 'Activa'),
    (4, 2, CURRENT_DATE, '100-000004-4', 25000.75, 'Activa'),
    (5, 2, CURRENT_DATE, '100-000005-5', 8526.41, 'Inactiva'),
    (6, 2, CURRENT_DATE, '100-000006-6', 76294.52, 'Activa'),
    (7, 1, CURRENT_DATE, '100-000007-7', 4856.48, 'Activa'),
    (8, 2, CURRENT_DATE, '100-000008-8', 102.54, 'Inactiva'),
    (9, 1, CURRENT_DATE, '100-000009-9', 458341.45, 'Cerrada'),
    (10, 1, CURRENT_DATE, '100-000010-0', 48676.57, 'Activa'),
    (11, 1, CURRENT_DATE, '100-000011-1', 94614.24, 'Inactiva'),
    (12, 2, CURRENT_DATE, '100-000012-2', 45.63, 'Activa'),
    (13, 1, CURRENT_DATE, '100-000013-3', 861.35, 'Cerrada'),
    (14, 2, CURRENT_DATE, '100-000014-4', 876.94, 'Activa'),
    (15, 2, CURRENT_DATE, '100-000015-5', 0.00, 'Inactiva'),
    (16, 1, CURRENT_DATE, '100-000016-6', 160000.16, 'Activa'),
    (17, 2, CURRENT_DATE, '100-000017-7', 0.00, 'Bloqueada'),
    (18, 1, CURRENT_DATE, '100-000018-8', 476.17, 'Activa'),
    (19, 2, CURRENT_DATE, '100-000019-9', 79513.57, 'Inactiva'),
    (20, 1, CURRENT_DATE, '100-000020-0', 8723484.27, 'Activa'),
    (21, 2, CURRENT_DATE, '100-000021-1', 4720485.45, 'Activa'),
    (22, 2, CURRENT_DATE, '100-000022-2', 43547.52, 'Bloqueada'),
    (23, 2, CURRENT_DATE, '100-000023-3', 54812387.45, 'Activa'),
    (24, 2, CURRENT_DATE, '100-000024-4', 48720.14, 'Inactiva'),
    (25, 1, CURRENT_DATE, '100-000025-5', 2157972.78, 'Activa');



INSERT INTO transacciones (id_tipo_transaccion, id_cuenta_origen, id_cuenta_destino, monto, fecha_transaccion, referencia)
VALUES 
    -- TRANSFERENCIA: Salida de dinero hacia otra cuenta
    (3, 1, 2, 4500.00, CURRENT_TIMESTAMP, 'Transferencia de Alerson Martínez - Pago de pasajes y cena'),
    
    -- TRANSFERENCIA: Ingreso de dinero desde otra cuenta
    (3, 20, 1, 28500.75, CURRENT_TIMESTAMP, 'Pago a Alerson Martínez por diseño del esquema de la base de datos'),
    
    -- DEPÓSITO: Dinero de la calle (origen NULL) hacia una cuenta
    (1, NULL, 1, 8000.00, CURRENT_TIMESTAMP, 'Depósito en efectivo en ventanilla - Cliente Alerson Martínez'),
    
    -- PAGO DE PRÉSTAMO: Dinero de la cuenta hacia el banco (destino NULL)
    (4, 1, NULL, 3500.50, CURRENT_TIMESTAMP, 'Cuota mensual de préstamo de vehículo - Alerson Martínez');
