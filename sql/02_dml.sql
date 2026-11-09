-- =====================================================
--  02 - DML: datos de prueba (ejecutar después de 01_ddl.sql)
-- =====================================================
USE huequita_del_sabor;

INSERT INTO categoria (nombre, descripcion) VALUES
('Bebidas',   'Gaseosas, jugos y agua embotellada'),
('Snacks',    'Papas fritas, galletas y golosinas'),
('Panadería', 'Pan, empanadas y masas saladas'),
('Postres',   'Brownies, tortas y gelatinas'),
('Helados',   'Helados y paletas');

INSERT INTO producto (nombre, precio_venta, stock_actual, stock_minimo, id_categoria) VALUES
('Gaseosa 500 ml',          0.75, 40, 10, 1),
('Jugo de naranja 330 ml',  0.90, 25, 10, 1),
('Agua 600 ml',             0.50, 50, 15, 1),
('Papas fritas',            0.60, 30, 10, 2),
('Galletas de chocolate',   0.40,  8, 10, 2),
('Empanada de queso',       1.00, 20,  8, 3),
('Pan de yuca',             0.50, 35, 10, 3),
('Brownie',                 1.50,  6,  6, 4),
('Helado de paila',         1.25, 12,  5, 5),
('Torta de chocolate',      2.00,  4,  5, 4);

INSERT INTO proveedor (nombre, telefono, direccion) VALUES
('Distribuidora Loja Bebidas', '0987000111', 'Av. Universitaria, Loja'),
('Panadería La Espiga',        '0987000222', 'Calle Bolívar, Loja'),
('Snacks del Sur',             '0987000333', 'Av. Pío Jaramillo, Loja'),
('Helados Andina',             '0987000444', 'Calle Mercadillo, Loja'),
('Dulces Caseros',             '0987000555', 'Barrio San Sebastián, Loja');

INSERT INTO compra (fecha, id_proveedor) VALUES
('2026-10-28', 1), ('2026-10-29', 2), ('2026-10-30', 3), ('2026-10-31', 4), ('2026-11-01', 5);

INSERT INTO detalle_compra (id_compra, id_producto, cantidad, costo_unitario) VALUES
(1, 1, 48, 0.50), (1, 2, 30, 0.60), (1, 3, 60, 0.30),
(2, 6, 30, 0.60), (2, 7, 40, 0.30),
(3, 4, 40, 0.40), (3, 5, 20, 0.25),
(4, 9, 20, 0.80),
(5, 8, 12, 1.00), (5, 10, 8, 1.40);

INSERT INTO empleado (nombres, apellidos, cargo, telefono) VALUES
('María',  'López',    'Cajera',        '0991110001'),
('José',   'Ramírez',  'Cocinero',      '0991110002'),
('Lucía',  'Paredes',  'Cajera',        '0991110003'),
('Andrés', 'Vega',     'Mesero',        '0991110004'),
('Rosa',   'Cueva',    'Administradora','0991110005');

INSERT INTO cliente (nombres, apellidos, telefono, direccion) VALUES
('Ana',   'Torres',   '0992220001', 'Barrio La Tebaida, Loja'),
('Luis',  'Pérez',    '0992220002', 'Ciudadela Zamora, Loja'),
('María', 'Gómez',    '0992220003', 'Av. Orillas del Zamora, Loja'),
('Sofía', 'Castillo', '0992220004', 'Barrio El Valle, Loja'),
('Diego', 'Mora',     '0992220005', 'Ciudadela Daniel Álvarez, Loja');

INSERT INTO metodo_pago (nombre) VALUES
('Efectivo'), ('Transferencia'), ('Tarjeta de débito'), ('Tarjeta de crédito'), ('Pago móvil');

INSERT INTO repartidor (nombres, apellidos, telefono) VALUES
('Carlos', 'Ruiz',    '0993330001'),
('Pedro',  'Salinas', '0993330002'),
('Jorge',  'Armijos', '0993330003'),
('Marco',  'Cueva',   '0993330004'),
('Víctor', 'Ochoa',   '0993330005');

INSERT INTO venta (fecha_hora, id_empleado, id_cliente) VALUES
('2026-11-02 09:10:00', 1, NULL),
('2026-11-02 12:30:00', 1, 1),
('2026-11-03 10:05:00', 3, NULL),
('2026-11-03 18:20:00', 3, 2),
('2026-11-04 11:45:00', 1, 1),
('2026-11-04 15:10:00', 4, 3),
('2026-11-05 09:40:00', 3, NULL),
('2026-11-05 19:00:00', 1, 4),
('2026-11-06 13:15:00', 4, 2),
('2026-11-07 17:30:00', 1, 5);

INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES
(1, 1, 2, 0.75), (1, 6, 1, 1.00),
(2, 6, 3, 1.00), (2, 2, 2, 0.90),
(3, 4, 2, 0.60), (3, 3, 1, 0.50),
(4, 9, 2, 1.25), (4, 1, 1, 0.75),
(5, 1, 2, 0.75), (5, 3, 2, 0.50), (5, 7, 2, 0.50),
(6, 8, 1, 1.50), (6, 2, 1, 0.90),
(7, 7, 4, 0.50), (7, 3, 2, 0.50),
(8, 6, 2, 1.00), (8, 1, 2, 0.75), (8, 9, 1, 1.25),
(9, 1, 1, 0.75), (9, 2, 1, 0.90), (9, 3, 1, 0.50),
(10, 8, 2, 1.50), (10, 9, 1, 1.25);

INSERT INTO pago (fecha_hora, monto, id_venta, id_metodo) VALUES
('2026-11-02 09:11:00', 2.50, 1, 1),
('2026-11-02 12:31:00', 5.30, 2, 2),
('2026-11-03 10:06:00', 1.70, 3, 1),
('2026-11-03 18:21:00', 4.25, 4, 3),
('2026-11-04 11:46:00', 3.50, 5, 1),
('2026-11-05 09:41:00', 3.00, 7, 5),
('2026-11-05 19:01:00', 3.00, 8, 1),
('2026-11-05 19:02:00', 2.75, 8, 2),
('2026-11-06 13:16:00', 2.15, 9, 4),
('2026-11-07 17:31:00', 4.75, 10, 2);

INSERT INTO domicilio (direccion_entrega, referencia, costo_envio, estado, id_venta, id_repartidor) VALUES
('Barrio La Tebaida, Loja',            'Casa blanca junto al parque', 0.50, 'Entregado', 2, 1),
('Ciudadela Zamora, Loja',             'Frente a la tienda',          1.00, 'Entregado', 4, 2),
('Av. Orillas del Zamora, Loja',       'Edificio azul, segundo piso', 0.75, 'Cancelado', 6, 3),
('Barrio El Valle, Loja',              'Junto a la capilla',          1.00, 'En camino', 8, 4),
('Ciudadela Daniel Álvarez, Loja',     'Portón negro',                0.50, 'Pendiente', 10, NULL);
