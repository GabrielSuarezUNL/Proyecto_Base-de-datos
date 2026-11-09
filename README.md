# La Huequita del Sabor — Base de datos

Proyecto de la asignatura **Base de datos** (Carrera de Computación, Universidad Nacional de Loja).

Base de datos relacional en **MySQL 8.0** para gestionar una cafetería familiar que vende productos
terminados: catálogo y stock, compras a proveedores, ventas diarias, pagos y pedidos a domicilio.

**Autor:** _escribe aquí tus nombres y apellidos_

## Estructura del repositorio

| Carpeta / archivo | Contenido |
|---|---|
| `sql/01_ddl.sql` | Creación de la base de datos y de las 13 tablas |
| `sql/02_dml.sql` | Datos de prueba (coherentes entre sí) |
| `sql/03_consultas.sql` | 5 consultas: álgebra relacional (en comentarios) y SQL |
| `sql/04_verificacion.sql` | `SHOW TABLES` y `SELECT *` de cada tabla (para las capturas del informe) |
| `diagrams/` | Diagrama entidad-relación y modelo relacional (`.drawio` y `.png`) |
| `docs/` | Informe de fin de unidad y modelo relacional en texto |

## Cómo ejecutarlo

Desde la terminal de MySQL:

```bash
mysql -u root -p < sql/01_ddl.sql
mysql -u root -p < sql/02_dml.sql
mysql -u root -p < sql/03_consultas.sql
```

O en MySQL Workbench: *File → Open SQL Script* y ejecutar cada archivo en ese orden.

## Modelo

13 tablas: `categoria`, `producto`, `proveedor`, `compra`, `detalle_compra`, `empleado`, `cliente`,
`venta`, `detalle_venta`, `metodo_pago`, `pago`, `repartidor`, `domicilio`.

- Relaciones N:M resueltas con `detalle_venta` y `detalle_compra` (llave primaria compuesta).
- Un pedido a domicilio por venta como máximo (`domicilio.id_venta` es `UNIQUE`).
- El total de una venta no se guarda: se calcula con `SUM(cantidad * precio_unitario)` más el costo de envío.

Los diagramas se pueden abrir y editar en [diagrams.net](https://app.diagrams.net) (*Archivo → Abrir desde → Dispositivo*).
