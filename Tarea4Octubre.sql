-- Tarea 5 de Octubre
create table emails (
	nombre varchar(30) constraint pk_emails primary key,
	email varchar(100) not null
);

CREATE SEQUENCE emails_nombre_seq START 1 INCREMENT 1;
ALTER TABLE emails ALTER COLUMN nombre 
SET DEFAULT nextval('emails_nombre_seq');

INSERT INTO emails
(nombre, email)
values
('Wanda Maximoff', 'wanda.maximoff@avengers.org'),
('Pietro Maximoff', 'pietro@mail.sokovia.ru'),
('Erik Lensherr	', 'fuck_you_charles@brotherhood.of.evil.mutants.space'),
('Charles Xavier', 'i.am.secretely.filled.with.hubris@xavier-school-4-gifted-youngste.'),
('Anthony Edward Stark', 'iamironman@avengers.gov'),
('Steve Rogers', 'americas_ass@anti_avengers'),
('The Vision', 'vis@westview.sword.gov'),
('Clint Barton', 'bul@lse.ye'),
('Natasja Romanov', 'blackwidow@kgb.ru'),
('Thor', 'god_of_thunder-^_^@royalty.asgard.gov'),
('Logan', 'wolverine@cyclops_is_a_jerk.com'),
('Ororo Monroe', 'ororo@weather.co'),
('Scott Summers', 'o@x'),
('Nathan Summers', 'cable@xfact.or'),
('Groot', 'iamgroot@asgardiansofthegalaxyledbythor.quillsux'),
('Nebula', 'idonthaveelektras@complex.thanos'),
('Gamora', 'thefiercestwomaninthegalaxy@thanos.'),
('Rocket', 'shhhhhhhh@darknet.ru');

select *  from emails

-- Construyan un query que regrese emails inválidos.
select e.email 
from emails e 
where e.email not like '%@%._%' or e.email like '%god%';

-- Cuales pagos tienen el monto 1.98, 7.98 o 9.98?
select *
from payment p
where p.amount = 1.98 or p.amount = 7.98 or p.amount = 9.98;

--Cuales la suma total pagada por los clientes que tienen una letra A en la segunda posición de su apellido y una W en cualquier lugar después de la A?
select sum(p.amount), c.last_name 
from payment p join customer c on (p.customer_id = c.customer_id)
where c.last_name like '_A%W%' and c.last_name not like 'WA%'
group by c.customer_id;

