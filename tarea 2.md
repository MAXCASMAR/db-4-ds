## Tarea 2.

-- 1. Obtener un reporte de edades de los empleados para checar su elegibilidad para seguro de gastos médicos menores.
-- Tablas: employees

select e.first_name, e.last_name, age(now(), e.birth_date)
from employees e;

-- 2. Cuál es la orden más reciente por cliente?
-- Tablas: orders, customers 
select o.customer_id, max(o.order_date)
from orders o 
group by o.customer_id

-- 3. De nuestros clientes, qué función desempeñan y cuántos son?
select c.contact_title, count(c.contact_title)
from customers c 
group by c.contact_title;

-- 4. Cuántos productos tenemos de cada categoría?
select p.category_id, count(p.category_id)
from products p
group by p.category_id;

select c.category_id, c.category_name
from categories c;

-- 5. Cómo podemos generar el reporte de reorder?



-- 6. A donde va nuestro envío más voluminoso?
select o.ship_country, od.quantity 
from order_details od join orders o using(order_id)
order by quantity desc
limit 1;

-- 7. Cómo creamos una columna en customers que nos diga si un cliente es bueno, regular, o malo?
alter table customers
add column bmr varchar(7);

-- 8. Qué colaboradores chambearon durante las fiestas de navidad?
select concat(e.first_name,' ' , e.last_name) employee , o.order_date 
from employees e join orders o using(employee_id)
where o.order_date in('1997-12-25','1996-12-25');

-- 9. Qué productos mandamos en navidad?
select o.shipped_date, p.product_name
from orders o
inner join order_details od on o.order_id = od.order_id 
inner join products p on p.product_id = od.product_id
where o.shipped_date = '1996-12-24' or o.shipped_date = '1997-12-24' or o.shipped_date = '1998-12-24';

-- 10. Qué país recibe el mayor volumen de producto?
select o.ship_country
from orders o
where o.order_id in (select od.order_id from order_details od where od.quantity = (select max(od2.quantity) from order_details od2));


