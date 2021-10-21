-- Última tarea.
-- Ejemplo: 
-- select distinct on (payment_year) extract(year from p.payment_date) as payment_year, c.customer_id, sum(p.amount) as sum_amount 
-- from customer c join payment p using (customer_id) 
-- group by c.customer_id, payment_year
-- order by payment_year, sum_amount desc;

-- 1. ¿Cómo obtenemos todos los nombres y correos de nuestros clientes canadienses para una campaña?
-- TABLES: customer, address, city, country
select distinct concat(c.first_name, ' ', c.last_name) as name, c.email
from customer c join address a using (address_id)
join city c2 using (city_id)
join country c3 using (country_id)
where c3.country = 'Canada';

-- 2. ¿Qué cliente ha rentado más de nuestra sección de adultos?
-- R: RESTRICTED. CHILDREN UNDER 17 REQUIRE ACCOMPANYING PARENT OR LEGAL GUARDIAN.
-- NC-17: NO ONE 17 AND UNDER ADMITTED. We want NC-17, estrictly adults. 
select distinct concat(c2.first_name, ' ', c2.last_name) as name, f.title, count(f.title) as rents
from category c join film_category fc using (category_id)
join film f using (film_id)
join inventory i using (film_id)
join rental r using (inventory_id)
join customer c2 using (customer_id)
where f.rating = 'NC-17'
group by f.title, c2.customer_id
order by rents desc;

-- 3. ¿Qué películas son las más rentadas en todas nuestras stores?
-- TABLES: rental, inventory, film
select f.title, count(f.title) as rents
from film f join inventory i using (film_id)
join rental r using (inventory_id)
group by f.title
order by rents desc;

-- 4. ¿Cuál es nuestro revenue por store?
-- TABLES: store, inventory, )
select s.store_id, sum(p.amount) as revenue
from store s join inventory i using (store_id)
join rental r using (inventory_id)
join payment p using (rental_id)
group by s.store_id;
