/*
 * Tarea 1: Una aplicación frecuente de CD aplicada a la industria del microlending es el de calificaciones 
 * crediticias (credit scoring). Puede interpretarse de muchas formas. La intuición nos dice que las variables 
 * más importntes son el saldo o monto del crédito y la puntualidad del pago. Sin embargo, otra variable es el 
 * tiempo entre cada pago. La puntualidad es una pésima variable para anticipar default o inferir capacidad de 
 * pago de micropréstamos, por su naturaleza. 
 * 
 * Deseamos examinar la viabilidad de una producto de crédito para nuestras videorental stores:
 * 1. ¿Cuál es el promedio, en formato human-readable, de tiempo entre cada pago por cliente de la BD Sakila?
 * 2. ¿Sigue una distribución normal?
 * 3. ¿Qué tanto difiere ese promedio del tiempo entre rentas por cliente?
*/



-- 1. ¿Cuál es el promedio, en formato human-readable, de tiempo entre cada pago por cliente de la BD Sakila?
-- Interés en tiempo entre cada pago por cliente
-- TABLAS: payment, rental, customer
select distinct c.customer_id, avg((((extract(day from p.payment_date - r.rental_date) * 24 +
extract(hour from (p.payment_date - r.rental_date)::time)) * 60) + 
extract(minute from (p.payment_date - r.rental_date)::time)) * 60 +
extract(second from (p.payment_date - r.rental_date))) as promedio_tiempo_pago_segundos
from payment p join rental r using (customer_id)
join customer c using (customer_id)
group by c.customer_id;

-- 2. ¿Sigue una distribución normal?
CREATE OR REPLACE FUNCTION histogram(table_name_or_subquery text, column_name text)
RETURNS TABLE(bucket int, "range" numrange, freq bigint, bar text)
AS $func$
BEGIN
RETURN QUERY EXECUTE format('
  WITH
  source AS (
    SELECT * FROM %s
  ),
  min_max AS (
    SELECT min(%s) AS min, max(%s) AS max FROM source
  ),
  histogram AS (
    SELECT
      width_bucket(%s, min_max.min, min_max.max, 20) AS bucket,
      numrange(min(%s)::numeric, max(%s)::numeric, ''[]'') AS "range",
      count(%s) AS freq
    FROM source, min_max
    WHERE %s IS NOT NULL
    GROUP BY bucket
    ORDER BY bucket
  )
  SELECT
    bucket,
    "range",
    freq::bigint,
    repeat(''*'', (freq::float / (max(freq) over() + 1) * 15)::int) AS bar
  FROM histogram',
  table_name_or_subquery,
  column_name,
  column_name,
  column_name,
  column_name,
  column_name,
  column_name,
  column_name
  );
END
$func$ LANGUAGE plpgsql;






select * from histogram('t.customer_id','t.promedio_tiempo_pago_segundos') 
from (select distinct c.customer_id, avg((((extract(day from p.payment_date - r.rental_date) * 24 +
extract(hour from (p.payment_date - r.rental_date)::time)) * 60) + 
extract(minute from (p.payment_date - r.rental_date)::time)) * 60 +
extract(second from (p.payment_date - r.rental_date))) as promedio_tiempo_pago_segundos
from payment p join rental r using (customer_id)
join customer c using (customer_id)
group by c.customer_id) 
as t;




-- 3. ¿Qué tanto difiere ese promedio del tiempo entre rentas por cliente?
-- En segundos
select distinct c.customer_id, abs(avg((((extract(day from p.payment_date - r.rental_date) * 24 +
extract(hour from (p.payment_date - r.rental_date)::time)) * 60) + 
extract(minute from (p.payment_date - r.rental_date)::time)) * 60 +
extract(second from (p.payment_date - r.rental_date)))) as dif_abs_rentas_pagos_tiempo_segundos
from payment p join rental r using (customer_id)
join customer c using (customer_id)
group by c.customer_id;

-- En minutos 
select distinct c.customer_id, abs(avg((((extract(day from p.payment_date - r.rental_date) * 24 +
extract(hour from (p.payment_date - r.rental_date)::time)) * 60) + 
extract(minute from (p.payment_date - r.rental_date)::time)) +
extract(second from (p.payment_date - r.rental_date) / 60))) as dif_abs_rentas_pagos_tiempo_minutos
from payment p join rental r using (customer_id)
join customer c using (customer_id)
group by c.customer_id;


/*
 * Tarea 2: Como parte de la modernización de nuestras video rental stores, vamos a automatizar la entrega y 
 * recepción de discos con robots.
 * 
 * Parte de la infraestructura es diseñar contenedores cilíndricos giratorios para facilitar la colocación 
 * y extracción de discos por brazos automatizados. 
 * 
 * Cada cajita de Blu-Ray mide 20cm x 13.5cm x 1.5cm, y para que el brazo pueda manipular adecuadamente cada 
 * cajita, debe estar contenida dentro de un arnés que cambia las medidas a 30cm x 21cm x 8cm para un espacio 
 * total de 5040 centímetros cúbicos y un peso de 500 gr por película.
 * 
 * Encargo: Formular la medida de dichos cilindros de manera tal que quepan todas las copias de los Blu-Rays 
 * de cada uno de nuestros stores. Las medidas deben ser estándar, es decir, la misma para todas nuestras stores, 
 * y en cada store pueden ser instalados más de 1 de estos cilindros. Cada cilindro aguanta un peso máximo de 50kg 
 * como máximo. El volúmen de un cilindro se calcula de [ésta forma.](volume of a cylinder).
 * 
 * Esto no se resuelve con 1 solo query. El problema se debe partir en varios cachos y deben resolver cada uno con SQL.
 * La información que no esté dada por el enunciado del problema o el contenido de la BD, podrá ser establecida como 
 * supuestos o assumptions, pero deben ser razonables para el problem domain que estamos tratando.

Fecha de entrega: Martes 16 de Noviembre, antes de las 23:59:59 Valor: 2/100 punto sobre el final Medio de entrega: 
su propio repositorio de Github

 * Medidas de caja de Blu-Ray en cm: 20 x 13.5 x 1.5
 * Cambio en las medidas de la caja de Blu-ray en cm^3: 30 x 21 x 8
 * Volumen con el cambio de medidas: 5040 cm^3, que equivale a 
 * Peso por película: 500 gr
 * 
 * Formular medida de cilindros (donde van a estar las cajas de Blu-Ray) para que quepan todas las copias de los Blu-Rays d
 * de todas las stores.
 * 
 * Las medidas para cada store del cilindro deben ser las mismas 
 * 
 * Puede ser instalada más de 1 cilindro
 * 
 * Cada cilindro aguanta un peso máximo de 50kg, donde caben 50000gr/500gr=100 películas. Entonces, en cada cilindro, 
 * máximo se pueden tener 100 blu-ray's
 * 
 * Información necesaria para la resolución del problema:
 * 1. Número de películas en cada una de las rental stores
 */

-- 1. Número de películas en cada una de las rental stores
-- TABLAS: inventory, store
select count(i.inventory_id)
from inventory i join store s using (store_id)
group by s.store_id;

-- Conclusión: En total, en el inventario de nuestras dos tiendas, tenemos:
-- En la tienda:
-- 1. 2311 películas
	-- recordando que solo nos caben máximo 100 películas por cilindro, en tienda 1 necesitamos al menos 24 cilindros
-- 2. 2270 películas
	-- recordando que solo nos caben máximo 100 películas por cilindro, en tienda 2 necesitamos al menos 23 cilindros
-- Sin embargo, no todas las películas están disponibles todo el tiempo, entonces debemos de conocer
-- aproximadamente:
-- TABLAS: rentals, inventory, store
--- A) Cuántas películas son rentadas, en promedio, por mes, por tienda
--- B) Cuántas películas son recibidas, en promedio, por mes, por tienda
with tabla1 as (
	with t as (
	select count(r.inventory_id), extract(month from r.rental_date) as promedio_renta_mes, s.store_id
	from rental r join inventory i using (inventory_id)
	join store s using (store_id)
	group by promedio_renta_mes, s.store_id
	)
	
	select avg(t.count) as promedio_renta, store_id
	from t
	group by t.store_id
),
tabla2 as (
	with t as (
	select count(r.inventory_id), extract(month from r.return_date) as promedio_regreso_mes, s.store_id
	from rental r join inventory i using (inventory_id)
	join store s using (store_id)
	group by promedio_regreso_mes, s.store_id
	)
	
	select avg(t.count) as promedio_regreso, store_id
	from t
	group by t.store_id
)
select abs(tabla1.promedio_renta - tabla2.promedio_regreso), store_id
from tabla1 join tabla2 using (store_id);

/*
 * Tenemos que la variación absoluta del flujo  para la tienda 2 es de aproximadamente 280 películas al mes en promedio y para la 
 * tienda 1 es de aproximadamente 265 películas al mes en promedio. Entonces, en promedio, necesitamos mínimo 3 cilindros para cada una 
 * de las tiendas, no necesariamente los cilindros para todas las películas existentes. 
 * 
 * Asumiendo que solo hay una torre de películas, tenemos que el alto de cada blue-ray es de 8cm, entonces por 100 películas puestas como 
 * una torre, tenemos que el alto del cilindro es de 100x8cm = 800cm = 8m. Esto es demasiado para una tienda. Ahora poniendo dos torres, 
 * una para recibir y otra para entregar dentro del cilindro, tenemos que la altura es de 4m, sigue siendo demasiado. Entonces, lo correcto
 * para una tienda serían 4 torres, dos para recibir y otras 2 para entregar, dependiendo de las circunstancias, por lo que se tiene
 * una altura de 8cm x 25 = 200cm = 2m
 * 
 * Cada blue-ray mide 21x30, por lo que forman un rectángulo de 42 por 60, lo que da una diagonal de aproximadamente raíz de 5364 que es la 
 * suma del cuadrado de ambos lados, da 75.19, el diámetro del círculo, el radio es aproximadamente 38 cm
 * 
 * El volumen es pi x 38^2 x 400
 * 
 */






