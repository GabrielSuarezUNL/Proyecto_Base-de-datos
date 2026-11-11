<div align="center">

<img src="https://unl.edu.ec/sites/default/files/logogris%20copia.png" alt="Universidad Nacional de Loja" width="180">

# Portafolio de Base de Datos

**Universidad Nacional de Loja · Carrera de Computación**<br>
Gabriel Suárez · Unidad 1

</div>

[Carátula](README.md) · [Modelos](#modelos-de-la-base-de-datos) · [Implementación en SQL](#implementación-en-sql) · [Álgebra relacional](#consultas-de-álgebra-relacional) · [Conclusiones](#conclusiones)

## Objetivo

Diseñar una base de datos relacional para controlar el inventario, las compras, las ventas, los pagos y los pedidos a domicilio de la cafetería **La Huequita del Sabor**.

## Unidad 1

El proyecto comprende los modelos de la base de datos, la implementación en MySQL y cinco consultas de álgebra relacional con su equivalente en SQL. [Ver la documentación completa de la Unidad 1](La_Huequita_del_Sabor/huequita-del-sabor-bd/README.md).

## Modelos de la base de datos

### Modelo entidad-relación

El diagrama muestra las entidades de la cafetería, sus atributos y las cardinalidades de sus relaciones.

[![Modelo entidad-relación de La Huequita del Sabor](La_Huequita_del_Sabor/huequita-del-sabor-bd/diagrams/huequita_er.png)](La_Huequita_del_Sabor/huequita-del-sabor-bd/diagrams/huequita_er.png)

[Archivo editable del modelo entidad-relación](La_Huequita_del_Sabor/huequita-del-sabor-bd/diagrams/huequita_er.drawio)

### Modelo relacional

El esquema presenta las 13 tablas, con las claves primarias subrayadas y flechas desde las claves foráneas hacia las claves que referencian.

[![Modelo relacional de La Huequita del Sabor](La_Huequita_del_Sabor/huequita-del-sabor-bd/diagrams/huequita_relacional.png)](La_Huequita_del_Sabor/huequita-del-sabor-bd/diagrams/huequita_relacional.png)

[Archivo editable del modelo relacional](La_Huequita_del_Sabor/huequita-del-sabor-bd/diagrams/huequita_relacional.drawio) · [Esquema en texto](La_Huequita_del_Sabor/huequita-del-sabor-bd/docs/modelo_relacional.txt)

## Implementación en SQL

### Definición de las 13 tablas

Crea el esquema, las llaves primarias y foráneas, y las restricciones de integridad. [Abrir el archivo 01_ddl.sql](La_Huequita_del_Sabor/huequita-del-sabor-bd/sql/01_ddl.sql).

<details open>
<summary>Ver código completo de 01_ddl.sql</summary>

```sql
-- =====================================================
--  01 - DDL: creación de la base de datos y las 13 tablas (MySQL 8.0)
-- =====================================================
CREATE DATABASE IF NOT EXISTS huequita_del_sabor CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE huequita_del_sabor;

-- ============ DDL: TABLAS ============
CREATE TABLE categoria (
    id_categoria INT          NOT NULL AUTO_INCREMENT,
    nombre       VARCHAR(60)  NOT NULL,
    descripcion  VARCHAR(255),
    PRIMARY KEY (id_categoria),
    UNIQUE (nombre)
);

CREATE TABLE producto (
    id_producto  INT           NOT NULL AUTO_INCREMENT,
    nombre       VARCHAR(100)  NOT NULL,
    precio_venta DECIMAL(8,2)  NOT NULL CHECK (precio_venta > 0),
    stock_actual INT           NOT NULL DEFAULT 0 CHECK (stock_actual >= 0),
    stock_minimo INT           NOT NULL DEFAULT 5 CHECK (stock_minimo >= 0),
    id_categoria INT           NOT NULL,
    PRIMARY KEY (id_producto),
    UNIQUE (nombre),
    CONSTRAINT fk_producto_categoria FOREIGN KEY (id_categoria)
        REFERENCES categoria(id_categoria) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE proveedor (
    id_proveedor INT          NOT NULL AUTO_INCREMENT,
    nombre       VARCHAR(100) NOT NULL,
    telefono     VARCHAR(15),
    direccion    VARCHAR(150),
    PRIMARY KEY (id_proveedor)
);

CREATE TABLE compra (
    id_compra    INT  NOT NULL AUTO_INCREMENT,
    fecha        DATE NOT NULL,
    id_proveedor INT  NOT NULL,
    PRIMARY KEY (id_compra),
    CONSTRAINT fk_compra_proveedor FOREIGN KEY (id_proveedor)
        REFERENCES proveedor(id_proveedor) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE detalle_compra (
    id_compra      INT          NOT NULL,
    id_producto    INT          NOT NULL,
    cantidad       INT          NOT NULL CHECK (cantidad > 0),
    costo_unitario DECIMAL(8,2) NOT NULL CHECK (costo_unitario >= 0),
    PRIMARY KEY (id_compra, id_producto),
    CONSTRAINT fk_dcompra_compra FOREIGN KEY (id_compra)
        REFERENCES compra(id_compra) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_dcompra_producto FOREIGN KEY (id_producto)
        REFERENCES producto(id_producto) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE empleado (
    id_empleado INT         NOT NULL AUTO_INCREMENT,
    nombres     VARCHAR(80) NOT NULL,
    apellidos   VARCHAR(80) NOT NULL,
    cargo       VARCHAR(40) NOT NULL,
    telefono    VARCHAR(15),
    PRIMARY KEY (id_empleado)
);

CREATE TABLE cliente (
    id_cliente INT          NOT NULL AUTO_INCREMENT,
    nombres    VARCHAR(80)  NOT NULL,
    apellidos  VARCHAR(80)  NOT NULL,
    telefono   VARCHAR(15),
    direccion  VARCHAR(150),
    PRIMARY KEY (id_cliente)
);

CREATE TABLE venta (
    id_venta    INT      NOT NULL AUTO_INCREMENT,
    fecha_hora  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_empleado INT      NOT NULL,
    id_cliente  INT,
    PRIMARY KEY (id_venta),
    CONSTRAINT fk_venta_empleado FOREIGN KEY (id_empleado)
        REFERENCES empleado(id_empleado) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_venta_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE detalle_venta (
    id_venta        INT          NOT NULL,
    id_producto     INT          NOT NULL,
    cantidad        INT          NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(8,2) NOT NULL CHECK (precio_unitario > 0),
    PRIMARY KEY (id_venta, id_producto),
    CONSTRAINT fk_dventa_venta FOREIGN KEY (id_venta)
        REFERENCES venta(id_venta) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_dventa_producto FOREIGN KEY (id_producto)
        REFERENCES producto(id_producto) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE metodo_pago (
    id_metodo INT         NOT NULL AUTO_INCREMENT,
    nombre    VARCHAR(40) NOT NULL,
    PRIMARY KEY (id_metodo),
    UNIQUE (nombre)
);

CREATE TABLE pago (
    id_pago    INT          NOT NULL AUTO_INCREMENT,
    fecha_hora DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    monto      DECIMAL(8,2) NOT NULL CHECK (monto > 0),
    id_venta   INT          NOT NULL,
    id_metodo  INT          NOT NULL,
    PRIMARY KEY (id_pago),
    CONSTRAINT fk_pago_venta FOREIGN KEY (id_venta)
        REFERENCES venta(id_venta) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_pago_metodo FOREIGN KEY (id_metodo)
        REFERENCES metodo_pago(id_metodo) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE repartidor (
    id_repartidor INT         NOT NULL AUTO_INCREMENT,
    nombres       VARCHAR(80) NOT NULL,
    apellidos     VARCHAR(80) NOT NULL,
    telefono      VARCHAR(15),
    PRIMARY KEY (id_repartidor)
);

CREATE TABLE domicilio (
    id_domicilio      INT          NOT NULL AUTO_INCREMENT,
    direccion_entrega VARCHAR(150) NOT NULL,
    referencia        VARCHAR(150),
    costo_envio       DECIMAL(6,2) NOT NULL DEFAULT 0 CHECK (costo_envio >= 0),
    estado            VARCHAR(15)  NOT NULL DEFAULT 'Pendiente'
                      CHECK (estado IN ('Pendiente','En camino','Entregado','Cancelado')),
    id_venta          INT          NOT NULL,
    id_repartidor     INT,
    PRIMARY KEY (id_domicilio),
    UNIQUE (id_venta),
    CONSTRAINT fk_domicilio_venta FOREIGN KEY (id_venta)
        REFERENCES venta(id_venta) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_domicilio_repartidor FOREIGN KEY (id_repartidor)
        REFERENCES repartidor(id_repartidor) ON UPDATE CASCADE ON DELETE SET NULL
);
```

</details>

### Carga de los datos de prueba

Inserta los datos de ejemplo en las 13 tablas. Ejecuta este código después del DDL. [Abrir el archivo 02_dml.sql](La_Huequita_del_Sabor/huequita-del-sabor-bd/sql/02_dml.sql).

<details open>
<summary>Ver código completo de 02_dml.sql</summary>

```sql
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
```

</details>

### Verificación de las 13 tablas

Lista las tablas y consulta sus registros en MySQL. [Abrir el archivo 04_verificacion.sql](La_Huequita_del_Sabor/huequita-del-sabor-bd/sql/04_verificacion.sql).

<details open>
<summary>Ver código completo de 04_verificacion.sql</summary>

```sql
-- Ejecutar para tomar las capturas de pantalla del informe
USE huequita_del_sabor;
SHOW TABLES;

SELECT * FROM categoria;
SELECT * FROM producto;
SELECT * FROM proveedor;
SELECT * FROM compra;
SELECT * FROM detalle_compra;
SELECT * FROM empleado;
SELECT * FROM cliente;
SELECT * FROM venta;
SELECT * FROM detalle_venta;
SELECT * FROM metodo_pago;
SELECT * FROM pago;
SELECT * FROM repartidor;
SELECT * FROM domicilio;
```

</details>

## Consultas de álgebra relacional

Las consultas 1, 2, 3 y 5 se verificaron en Relational. Para las consultas 2 y 5, carga [venta_ra.json](La_Huequita_del_Sabor/huequita-del-sabor-bd/docs/algebra/venta_ra.json) y [domicilio_ra.json](La_Huequita_del_Sabor/huequita-del-sabor-bd/docs/algebra/domicilio_ra.json) según corresponda. Activa el editor multilínea con **Ctrl+L** para las consultas 2 y 5. Para la consulta 4, importa el [grupo de datos en RelaX](La_Huequita_del_Sabor/huequita-del-sabor-bd/docs/algebra/ingresos_relax.txt).

### 1. Productos con stock bajo

La selección filtra por el mínimo de stock y la proyección muestra los campos necesarios.

**Álgebra relacional**

```text
π nombre,stock_actual,stock_minimo (σ stock_actual <= stock_minimo (producto))
```

**SQL equivalente**

```sql
SELECT nombre, stock_actual, stock_minimo
FROM   producto
WHERE  stock_actual <= stock_minimo;
```

**Resultado con los datos de prueba**

| Producto | Stock actual | Stock mínimo |
|---|---:|---:|
| Galletas de chocolate | 8 | 10 |
| Brownie | 6 | 6 |
| Torta de chocolate | 4 | 5 |

### 2. Pedidos a domicilio pendientes o en camino

La unión externa izquierda conserva los pedidos que todavía no tienen repartidor.

**Álgebra relacional**

```text
pedidos_abiertos = σ estado == 'Pendiente' or estado == 'En camino' (domicilio_ra)
datos_venta = π id_venta,id_cliente,fecha_hora (venta_ra)
datos_cliente = π id_cliente,nombres,apellidos (cliente)
nombres_reparto = ρ nombres➡nombre_repartidor (π id_repartidor,nombres (repartidor))
pedidos_completos = ((pedidos_abiertos ⋈ datos_venta) ⋈ datos_cliente) ⧑ nombres_reparto
π id_domicilio,fecha_hora,nombres,apellidos,direccion_entrega,estado,nombre_repartidor (pedidos_completos)
```

**SQL equivalente**

```sql
SELECT d.id_domicilio, v.fecha_hora,
       CONCAT(c.nombres, ' ', c.apellidos) AS cliente,
       d.direccion_entrega, d.estado, r.nombres AS repartidor
FROM   domicilio d
JOIN   venta v ON v.id_venta = d.id_venta
JOIN   cliente c ON c.id_cliente = v.id_cliente
LEFT JOIN repartidor r ON r.id_repartidor = d.id_repartidor
WHERE  d.estado IN ('Pendiente', 'En camino');
```

**Resultado con los datos de prueba**

| ID | Fecha y hora | Cliente | Dirección | Estado | Repartidor |
|---:|---|---|---|---|---|
| 4 | 2026-11-05 19:00:00 | Sofía Castillo | Barrio El Valle, Loja | En camino | Marco |
| 5 | 2026-11-07 17:30:00 | Diego Mora | Ciudadela Daniel Álvarez, Loja | Pendiente | Sin asignar |

### 3. Productos que nunca se han vendido

La diferencia obtiene los IDs 5 y 10. El SQL del proyecto devuelve los nombres de esos productos.

**Álgebra relacional**

```text
π id_producto (producto) - π id_producto (detalle_venta)
```

**SQL equivalente**

```sql
SELECT p.nombre
FROM   producto p
WHERE  p.id_producto NOT IN (SELECT dv.id_producto FROM detalle_venta dv);
```

**Resultado con los datos de prueba**

**5** · Galletas de chocolate y **10** · Torta de chocolate.

### 4. Ingresos por categoría

El agrupamiento suma las unidades y los ingresos por categoría. Esta expresión se ejecuta en RelaX.

**Álgebra relacional**

```text
τ total_ingresos desc (
  σ total_ingresos > 3 (
    γ categoria; sum(cantidad)->unidades, sum(subtotal)->total_ingresos (
      π id_venta,id_producto,categoria,cantidad,cantidad * precio_unitario->subtotal (
        detalle_venta ⋈ producto ⋈ (ρ nombre->categoria (π id_categoria,nombre (categoria)))
      )
    )
  )
)
```

**SQL equivalente**

```sql
SELECT   c.nombre AS categoria,
         SUM(dv.cantidad) AS unidades,
         SUM(dv.cantidad * dv.precio_unitario) AS total_ingresos
FROM     detalle_venta dv
JOIN     producto p  ON p.id_producto  = dv.id_producto
JOIN     categoria c ON c.id_categoria = p.id_categoria
GROUP BY c.nombre
HAVING   SUM(dv.cantidad * dv.precio_unitario) > 3
ORDER BY total_ingresos DESC;
```

**Resultado con los datos de prueba**

| Categoría | Unidades | Ingresos |
|---|---:|---:|
| Bebidas | 18 | $12,60 |
| Panadería | 12 | $9,00 |
| Helados | 4 | $5,00 |
| Postres | 3 | $4,50 |

### 5. Clientes que compraron todas las bebidas

La división identifica a los clientes que compraron cada uno de los productos de la categoría Bebidas.

**Álgebra relacional**

```text
compras_cliente = π id_cliente,id_producto (σ id_cliente is not None (venta_ra ⋈ detalle_venta))
categorias_bebidas = π id_categoria (σ nombre == 'Bebidas' (categoria))
productos_bebidas = π id_producto (producto ⋈ categorias_bebidas)
clientes_bebidas = compras_cliente ÷ productos_bebidas
π nombres,apellidos (cliente ⋈ clientes_bebidas)
```

**SQL equivalente**

```sql
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
```

**Resultado con los datos de prueba**

**Ana Torres** y **Luis Pérez**.

[Ver las cinco consultas en el archivo SQL](La_Huequita_del_Sabor/huequita-del-sabor-bd/sql/03_consultas.sql).

## Conclusiones

El diseño usa tablas de detalle para representar los productos de cada compra y venta. Las claves foráneas conectan esos movimientos con el inventario y vinculan las ventas con sus pagos y domicilios. Las consultas permiten detectar faltantes de stock, seguir pedidos abiertos y calcular ingresos por categoría.

## Referencias

- [Manual de referencia de MySQL 8.0](https://dev.mysql.com/doc/refman/8.0/en/)
- [Calculadora de álgebra relacional RelaX](https://dbis-uibk.github.io/relax/)

[Volver a la carátula](README.md)
