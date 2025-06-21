-- 000-4.sql
delete from product
where
  product.model not in (select pc.model from pc) and
  product.model not in (select laptop.model from laptop) and
  product.model not in (select printer.model from printer);

-- 000-3.sql
/* hacked :) */
update ships
set name = replace(replace(replace(replace(name, '     ', ' '), '    ', ' '), '   ', ' '), '  ', ' ');

-- 000-2.sql
update laptop
set
  screen = screen + 1,
  price = price - 100
where model in (
  select model
  from product
  where type = 'laptop'
  and (maker = 'E' or maker = 'B')
);

-- 000-1.sql
delete from pc
where code not in (
  select max(code)
  from pc
  group by model
);

-- 001.sql
insert into pc (code, model, speed, ram, hd, cd, price)
values (20, 2111, 950, 512, 60, '52x', 1100);

-- 002.sql
insert into product (maker, model, type)
values
  ('Z', 4003, 'Printer'),
  ('Z', 4001, 'PC'),
  ('Z', 4002, 'Laptop');

-- 003.sql
insert into pc (model, code, speed, price)
values (4444, 22, 1200, 1350);

-- 004.sql
insert into pc (code, model, speed, ram, hd, price)
select
  min(code) + 20,
  model + 1000,
  max(speed),
  max(ram) * 2,
  max(hd) * 2,
  max(price) / 1.5
from laptop
group by model;

-- 005.sql
delete from pc
where hd = (select min(hd) from pc) or
  ram = (select min(ram) from pc);

-- 006.sql
delete from laptop
where model in (
  select model
  from product
  where maker not in (
    select distinct maker
    from product
    where type = 'Printer'
  )
);

-- 007.sql
update product
set
  maker = 'Z'
where
  maker = 'A' and type = 'Printer';

-- 008.sql
delete from ships
where name in (
  select ship
  from outcomes
  where result = 'sunk'
);

-- 009.sql
update classes
set
  bore = bore * 2.5,
  displacement = round(displacement / 1.1, 0);

-- 010.sql
with best as (
  select
    max(code) as max_code,
    max(speed) as max_speed,
    cast(max(cast(replace(cd, 'x', '') as integer))
      as varchar(15)) + 'x' as max_cd,
    max(ram) as max_ram,
    max(hd) as max_hd,
    avg(price) as avg_price
  from pc
)
insert into pc (code, model, speed, ram, cd, hd, price)
select
  product.model + max_code,
  product.model,
  max_speed,
  max_ram,
  max_cd,
  max_hd,
  avg_price
from best, product
where product.type = 'PC'
  and product.model not in (
    select model
    from pc
  );

-- 011.sql
insert into pc
select
  min(code) + 20,
  model + 1000,
  max(speed),
  max(ram) * 2,
  max(hd) * 2,
  (select cast(max(cast(replace(cd, 'x', '') as integer))
    as varchar(15)) + 'x' as cd from pc),
  max(price) / 1.5
from laptop
group by model;

-- 012.sql
with missing as (
  select distinct ship, class, country
  from outcomes
  join classes on classes.class = outcomes.ship
  where ship not in (
    select name
    from ships
  )
), avgs as (
  select country, round(avg(cast(launched as numeric)), 0) as launched
  from ships
  join classes on classes.class = ships.class
  group by country
)
insert into ships
select ship, class, launched
from missing
join avgs on missing.country = avgs.country
where avgs.launched is not null;

-- 013.sql
insert into outcomes
values
  ('Rodney', (select name from battles where date = '1944-10-25'), 'sunk'),
  ('Nelson', (select name from battles where date = '1945-01-28'), 'damaged');

-- 014.sql
with alls as (
  select name, class
  from ships
  union
  select ship as name, ship as class
  from outcomes
)
delete from classes
where class in (
  select classes.class
  from alls
  right join classes on classes.class = alls.class
  group by classes.class
  having count(alls.name) < 3
);

-- 015.sql
with datetimes as (
  select id_psg, date + time_out as stamp
  from pass_in_trip
  join trip on pass_in_trip.trip_no = trip.trip_no
), stats as (
  select id_psg, stamp,
    min(stamp) over (partition by id_psg) as first,
    max(stamp) over (partition by id_psg) as last
  from datetimes
), trash as (
  select id_psg, stamp
  from stats
  where stamp != first and stamp != last
)
delete pass_in_trip
from pass_in_trip
join trip on pass_in_trip.trip_no = trip.trip_no
join trash
  on pass_in_trip.id_psg = trash.id_psg
  and pass_in_trip.date + trip.time_out = trash.stamp;

-- 016.sql
delete from players
where player_id not in (
  select distinct player_id
  from lineups
);

-- 017.sql
with stats as (
  select dense_rank() over (order by hd) as i, *
  from pc
)
delete pc
from pc
join stats
  on pc.code = stats.code
  and pc.model = stats.model
  and i <= 3;

-- 018.sql
update battles
set name = replace(name, rtrim(name), '') + rtrim(name);

-- 019.sql
with nbattles as (
  select name, date,
    lead(name) over(order by date) as next
  from battles
), merged as (
  select ship, battle, next,
    count(*) over(partition by ship) as num,
    date, result
  from outcomes
  join nbattles on outcomes.battle = nbattles.name
)
insert into outcomes
select ship, next as battle, 'sunk' as result
from merged
where num = 1
  and result = 'damaged'
  and next is not null;

-- 020.sql
update outcomes_1
set result = (
  select top 1 outcomes_2.result
  from outcomes as outcomes_2
  join battles on outcomes_2.battle = battles.name
  where outcomes_2.ship = outcomes_1.ship
    and outcomes_2.battle != outcomes_1.battle
)
from outcomes as outcomes_1
where exists (
  select 1
  from outcomes outcomes_inner
  where outcomes_inner.ship = outcomes_1.ship
  group by outcomes_inner.ship
  having count(*) = 2
);
