# Guía de ejecución

## Requisitos
- MySQL Server 8.0 o compatible.
- MySQL Workbench o cliente de consola.

## Orden de ejecución
1. `sql/01_ddl.sql`: crea la base de datos y las 13 tablas.
2. `sql/02_dml.sql`: inserta los datos de prueba.
3. `sql/03_consultas.sql`: ejecuta las cinco consultas de análisis.
4. `sql/04_verificacion.sql`: muestra las tablas y sus registros.

## Desde MySQL Workbench
Abre cada archivo con **File → Open SQL Script** y ejecútalo respetando el orden anterior.

## Desde la terminal
Ejecuta los comandos desde la carpeta raíz del repositorio:

```bash
mysql -u root -p < sql/01_ddl.sql
mysql -u root -p < sql/02_dml.sql
mysql -u root -p < sql/03_consultas.sql
mysql -u root -p < sql/04_verificacion.sql
```

El último archivo es de verificación y puede producir una salida extensa porque consulta todas las tablas.
