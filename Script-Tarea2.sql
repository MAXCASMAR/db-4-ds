-- Tarea 2. Bases de datos. Maximiliano Casas Martínez.
-- 1. ¿Qué contactos de proveedores tiene la posición de sales representative?
select * from suppliers s; -- Ver la tabla

select s.contact_name
from suppliers s
where s.contact_title = 'Sales Representative';

-- 2. ¿Qué contactos de proveedores no son marketing managers?
select * from suppliers s; -- Ver la tabla

select s.contact_name
from suppliers s
where s.contact_title != 'Marketing Manager';

-- 3. ¿Cuáles órdenes no vienen de clientes en Estados Unidos?
select * from orders o; -- Ver la tabla

select o.order_id
from orders o
where o.ship_country != 'USA';

-- 4. ¿Qué productos de los que transportamos son quesos?
select * from categories c; -- Ver la tabla (category_id 4 category_name Dairy Productscheeses)

select p.product_name
from products p
where category_id = 4;

-- 5. ¿Qué órdenes van a Bélgica o Francia?
select * from orders o; -- Ver la tabla

select o.order_id
from orders o
where o.ship_country = 'Belgium' or o.ship_country = 'France';

-- 6. ¿Qué órdenes van a LATAM?
select distinct o.ship_country from orders o;

select o.order_id
from orders o
where o.ship_country = 'Brazil' or o.ship_country = 'Venezuela' or o.ship_country = 'Mexico';

-- 7. ¿Qué órdenes no van a LATAM?
select o.order_id
from orders o
where o.ship_country != 'Brazil' and o.ship_country != 'Venezuela' and o.ship_country != 'Mexico';


-- 8. Necesitamos los nombres completos de los empleados, nombres y apellidos unidos en un mismo registro.
select * from employees e;

select concat(e.first_name, ' ', e.last_name)
from employees e;

-- 9. ¿Cuánta lana tenemos en inventario?
select * from products p;

select sum(p.units_in_stock * p.unit_price)
from products p;

-- 10. ¿Cuántos clientes tenemos de cada país?
select * from customers c;

select c.country, count(c.customer_id)
from customers c
group by c.country;
