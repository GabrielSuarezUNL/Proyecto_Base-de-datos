-- =====================================================
--  03 - CONSULTAS: álgebra relacional y su traducción a SQL
-- =====================================================
USE huequita_del_sabor;

-- Consulta 1: Selección + Proyección (productos con stock bajo)
-- Álgebra: π nombre, stock_actual, stock_minimo (σ stock_actual ≤ stock_minimo (PRODUCTO))
SELECT nombre, stock_actual, stock_minimo
FROM   producto
WHERE  stock_actual <= stock_minimo;

-- Consulta 2: Reunión natural (pedidos a domicilio pendientes o en camino)
-- Álgebra: π id_domicilio, fecha_hora, nombres, apellidos, direccion_entrega, estado, repartidor.nombres
--            (σ estado = 'Pendiente' ∨ estado = 'En camino'
--               (DOMICILIO ⋈ VENTA ⋈ CLIENTE ⋈ (izq.) REPARTIDOR))
SELECT d.id_domicilio, v.fecha_hora,
       CONCAT(c.nombres, ' ', c.apellidos) AS cliente,
       d.direccion_entrega, d.estado, r.nombres AS repartidor
FROM   domicilio d
JOIN   venta v ON v.id_venta = d.id_venta
JOIN   cliente c ON c.id_cliente = v.id_cliente
LEFT JOIN repartidor r ON r.id_repartidor = d.id_repartidor
WHERE  d.estado IN ('Pendiente', 'En camino');

-- Consulta 3: Diferencia (productos que nunca se han vendido)
-- Álgebra: π nombre (PRODUCTO ⋈ (π id_producto (PRODUCTO) − π id_producto (DETALLE_VENTA)))
SELECT p.nombre
FROM   producto p
WHERE  p.id_producto NOT IN (SELECT dv.id_producto FROM detalle_venta dv);

-- Consulta 4: Agrupamiento y agregación (ingresos por categoría > $3.00)
-- Álgebra: σ total_ingresos > 3 (γ categoria.nombre; SUM(cantidad) → unidades,
--            SUM(cantidad × precio_unitario) → total_ingresos (DETALLE_VENTA ⋈ PRODUCTO ⋈ CATEGORIA))
SELECT   c.nombre AS categoria,
         SUM(dv.cantidad) AS unidades,
         SUM(dv.cantidad * dv.precio_unitario) AS total_ingresos
FROM     detalle_venta dv
JOIN     producto p  ON p.id_producto  = dv.id_producto
JOIN     categoria c ON c.id_categoria = p.id_categoria
GROUP BY c.nombre
HAVING   SUM(dv.cantidad * dv.precio_unitario) > 3
ORDER BY total_ingresos DESC;

-- Consulta 5: División (clientes que han comprado todas las bebidas)
-- Álgebra: COMPRAS ← π id_cliente, id_producto (σ id_cliente ≠ NULL (VENTA ⋈ DETALLE_VENTA))
--          BEBIDAS ← π id_producto (σ CATEGORIA.nombre = 'Bebidas' (PRODUCTO ⋈ CATEGORIA))
--          RESULTADO ← π nombres, apellidos (CLIENTE ⋈ (COMPRAS ÷ BEBIDAS))
SELECT cl.nombres, cl.apellidos
FROM   cliente cl
WHERE  NOT EXISTS (
         SELECT p.id_producto
         FROM   producto p
         JOIN   categoria c ON c.id_categoria = p.id_categoria
         WHERE  c.nombre = 'Bebidas'
           AND  NOT EXISTS (
                  SELECT 1
                  FROM   venta v
                  JOIN   detalle_venta dv ON dv.id_venta = v.id_venta
                  WHERE  v.id_cliente   = cl.id_cliente
                    AND  dv.id_producto = p.id_producto));
