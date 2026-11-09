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
