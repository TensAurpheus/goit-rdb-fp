use pandemic;

create table entities(
entity_id int auto_increment primary key,
entity varchar(50),
code varchar(50)
);

create table infect_n as select * from infectious_cases;

alter table infect_n
add column entity_id int,
add column id int primary key auto_increment,
ADD CONSTRAINT fk_infect_n_entity_id
FOREIGN KEY (entity_id) REFERENCES entities(entity_id);

insert into entities (entity, code) 
select distinct entity, code
FROM infect_n;

UPDATE infect_n
JOIN entities ON infect_n.entity = entities.entity
SET infect_n.entity_id = entities.entity_id;

alter table infect_n 
drop column entity,
drop column code;

select * from entities limit 500;
select * from infect_n limit 500;

select entity_id, 
	avg(Number_rabies) as avg_rabies,
	min(Number_rabies) as min_rabies,
	max(Number_rabies) as max_rabies,
	sum(Number_rabies) as sum_rabies
from infect_n
where Number_rabies is not null
group by entity_id 
order by avg_rabies desc 
limit 10;

select year, makedate(year, 1) as date_0, now() as cur_date, (year(now()) - year(makedate(year, 1))) as year_dif 
from infect_n;

drop function if exists year_dif;
delimiter //

create function year_dif(year_0 year)
returns int
deterministic
no sql
begin
	declare result int;
    set result = year(now()) - year(makedate(year_0, 1));
    return result;
end //

delimiter ;

select year_dif('1985');


