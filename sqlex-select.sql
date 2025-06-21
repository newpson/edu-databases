-- 001.sql
select model, speed, hd
from pc
where price < 500;

-- 002.sql
select distinct maker
from product
where type = 'Printer';

-- 003.sql
select model, ram, screen
from laptop
where price > 1000;

-- 004.sql
select *
from printer
where color = 'y';

-- 005.sql
select model, speed, hd
from pc
where ( cd = '12x' or cd = '24x' ) and price < 600;

-- 006.sql
select distinct maker, speed
from laptop
join product on product.model = laptop.model
where hd >= 10;

-- 007.sql
select distinct laptop.model, price
from laptop
join product
  on product.maker = 'B'
  and product.model = laptop.model
union
select distinct pc.model, price
from pc
join product
  on product.maker = 'B'
  and product.model = pc.model
union
select distinct printer.model, price
from printer
join product
  on product.maker = 'B'
  and product.model = printer.model;

-- 008.sql
select distinct maker
from product
where type = 'PC'
except
select distinct maker
from product
where type = 'Laptop';

-- 009.sql
select distinct maker
from pc
join product on product.model = pc.model
where speed >= 450;

-- 010.sql
select model, price
from printer
where price = (
  select max(price)
  from printer
);

-- 011.sql
select avg(speed)
from pc;

-- 012.sql
select avg(speed)
from laptop
where price > 1000;

-- 013.sql
select avg(pc.speed)
from pc join product
on (product.maker = 'A' and product.model = pc.model);

-- 014.sql
select ships.class, ships.name, classes.country
from ships join classes
on ships.class = classes.class
where classes.numguns >= 10;

-- 015.sql
select pc.hd
from pc
group by pc.hd
having count(pc.hd) >= 2;

-- 016.sql
select distinct pc1.model, pc2.model, pc1.speed, pc1.ram
from pc as pc1, pc as pc2
where pc1.model > pc2.model
  and pc1.speed = pc2.speed
  and pc1.ram = pc2.ram;

-- 017.sql
select distinct 'Laptop', laptop.model, speed
from laptop, product
where speed < all (
  select speed
  from pc
);

-- 018.sql
select distinct maker, price
from printer
join product on printer.model = product.model
where printer.color = 'y' and price = (
  select min(price)
  from printer
  where printer.color = 'y'
);

-- 019.sql
select maker, avg(screen)
from laptop
join product on product.model = laptop.model
group by maker;

-- 020.sql
select maker, count(distinct model)
from product
where type = 'PC'
group by maker
having count(distinct model) >= 3;

-- 021.sql
select maker, max(price)
from pc
join product on pc.model = product.model
group by maker;

-- 022.sql
select speed, avg(price)
from pc
where speed > 600
group by speed;

-- 023.sql
select distinct maker
from pc
join product on pc.model = product.model
where speed >= 750
intersect
select distinct maker
from laptop
join product on laptop.model = product.model
where speed >= 750;

-- 024.sql
with q as (
  select model, price
  from pc
  where price = ( select max(price) from pc )
  union
  select model, price
  from laptop
  where price = ( select max(price) from laptop )
  union
  select model, price
  from printer
  where price = ( select max(price) from printer )
)
select q.model
from q
where q.price = ( select max(q.price) from q );

-- 025.sql
select distinct maker
from product
where type='Printer'
intersect
select distinct maker
from product
join pc on pc.model = product.model  
where product.type = 'PC' and pc.ram = (select min(ram) from pc)
  and pc.speed = (
    select max(speed)
    from (
      select distinct speed
      from pc
      where pc.ram = (select min(ram) from pc)
    ) as t
  );

-- 026.sql
select sum(q.price)/sum(q.cnt)
from (
  select count(price) as cnt, sum(price) as price
  from pc
  join  product on pc.model = product.model and maker = 'A'
  union
  select count(price) as cnt, sum(price) as price
  from laptop
  join product on laptop.model = product.model and maker = 'A'
) as q;

-- 027.sql
select product.maker, avg(pc.hd)
from pc
join product on pc.model = product.model
  and product.maker in (
    select maker
    from product
    where type = 'Printer'
  )
group by product.maker;

-- 028.sql
select count(qty)
from (
  select count(model) as qty
  from product
  group by maker
  having count(model) = 1
) as q;

-- 029.sql
select i.point, i.date, inc, out
from income_o as i
left outer join outcome_o as o
  on i.date = o.date
  and i.point = o.point
union
select o.point, o.date, inc, out
from outcome_o as o
left outer join income_o as i
  on i.date = o.date
  and i.point = o.point;

-- 030.sql
with
  income_oo as (
    select point, date, sum(inc) as inc
    from income
    group by point, date
  ),
  outcome_oo as (
    select point, date, sum(out) as out
    from outcome
    group by point, date
  )
select i.point, i.date, out, inc
from income_oo as i
left outer join outcome_oo as o
  on i.date = o.date
  and i.point = o.point
union
select o.point, o.date, out, inc
from outcome_oo as o
left outer join income_oo as i
  on i.date = o.date
  and i.point = o.point;

-- 031.sql
select class, country
from classes
where bore >= 16;

-- 032.sql
with bores as (
  select country, classes.class, bore, name
  from classes
  join ships on classes.class = ships.class
  union
  select country, class, bore, ship 
  from classes
  join outcomes on classes.class = outcomes.ship
)
select country, round(cast(avg(bore*bore*bore/2) as numeric), 2)
from bores
group by country;

-- 033.sql
select ship
from outcomes
where result = 'sunk' and battle = 'North Atlantic';

-- 034.sql
select name
from ships join classes on classes.class = ships.class
where ships.launched >= 1922
  and classes.displacement > 35000
  and classes.type = 'bb';

-- 035.sql
select model, type
from product
where model ~ '^[0-9]+$' or lower(model) ~ '^[a-z]+$';

-- 036.sql
select ships.name
from ships
where class = name
union
select ship as name
from classes
join outcomes on classes.class = outcomes.ship;

-- 037.sql
with alls as (
  select class, name
  from ships
  union
  select ship, ship
  from outcomes
)
select classes.class
from classes
left join alls on alls.class = classes.class
group by classes.class
having count(alls.name) = 1;

-- 038.sql
select country
from classes
where type = 'bb'
intersect
select country
from classes
where type = 'bc';

-- 039.sql
with stats as (
  select outcomes.ship, battles.name, battles.date, outcomes.result
  from outcomes
  join battles on outcomes.battle = battles.name
)
select distinct s1.ship
from stats as s1
where s1.result = 'damaged' and s1.ship in (
  select ship
  from stats as s2
  where s1.date < s2.date
);

-- 040.sql
select maker, min(type)
from product
group by maker
having count(distinct type) = 1 and count(model) > 1;

-- 041.sql
select
  maker,
  case when max(case when price is null then 1 else 0 end) = 1
    then null
    else max(price)
  end as max_price
from (
  select product.maker, pc.price
  from product
  join pc on product.model = pc.model
  union all
  select product.maker, laptop.price
  from product
  join laptop on product.model = laptop.model
  union all
  select product.maker, printer.price
  from product
  join printer on product.model = printer.model
) as q
group by maker;

-- 042.sql
select ship, battle
from outcomes
where result = 'sunk';

-- 043.sql
select distinct name
from battles
where date_part('year', date) not in (
  select launched
  from ships
  where launched is not null
);

-- 044.sql
select distinct name
from (
  select name from ships
  union
  select ship as name from outcomes
) as alls
where name ~ '^R.*';

-- 045.sql
select distinct name
from ships
where name like '% % %'
union
select distinct ship as name
from outcomes
where ship like '% % %'
  and ship not in (select name from ships);

-- 046.sql
select ship, displacement, numguns
from outcomes
left join ships on outcomes.ship = ships.name
left join classes on ships.class = classes.class
  or outcomes.ship = classes.class
where outcomes.battle = 'Guadalcanal';

-- 047.sql
with alls as (
  select classes.country, ships.name
  from classes
  join ships on classes.class = ships.class
  union
  select classes.country, outcomes.ship as name
  from outcomes
  join classes on outcomes.ship = classes.class
), sunks as (
  select classes.country, outcomes.ship as name
  from outcomes
  join ships on outcomes.ship = ships.name
  join classes on ships.class = classes.class
  where outcomes.result = 'sunk'
  union
  select classes.country, outcomes.ship
  from outcomes
  join classes on outcomes.ship = classes.class
  where outcomes.result = 'sunk'
)
select alls.country
from alls
group by alls.country
having count(*) = (
  select count(*) 
  from sunks
  where sunks.country = alls.country
);

-- 048.sql
select distinct class
from classes
where exists (
  select 1
  from outcomes
  left join ships on ship = name
  where result = 'sunk'
    and (ships.class = classes.class or outcomes.ship = classes.class)
);

-- 049.sql
with alls as (
  select ships.name, classes.bore
  from classes
  join ships on classes.class = ships.class
  union
  select outcomes.ship as name, classes.bore
  from outcomes
  join classes on outcomes.ship = classes.class
)
select name
from alls
where bore = 16;

-- 050.sql
select distinct battles.name
from battles
join outcomes on battles.name = outcomes.battle
join ships on outcomes.ship = ships.name
where ships.class = 'Kongo';

-- 051.sql
with info as (
  with allships as (
    select name, class
    from ships
    union
    select ship, ship as class
    from outcomes
  )
  select name, numguns, displacement
  from allships
  join classes on allships.class = classes.class
), maxguns as (
  select displacement, max(numguns)
  from info
  group by displacement
)
select name
from info
join maxguns
  on info.displacement = maxguns.displacement
  and info.numguns = maxguns.max;

-- 052.sql
select distinct name
from ships
join classes on ships.class = classes.class
where ( numguns >= 9 or numguns is null )
  and ( bore < 19 or bore is null )
  and ( displacement <= 65000 or displacement is null )
  and classes.type = 'bb' and classes.country = 'Japan';

-- 053.sql
select round(
  cast(sum(numguns) as numeric) /
  cast(count(numguns) as numeric), 2)
from classes
where type = 'bb';

-- 054.sql
select cast(avg(cast(numguns as numeric)) as numeric (4, 2))
from (
  select ship, type, numguns
  from outcomes
  left join classes on outcomes.ship = classes.class
  union
  select name, type, numguns
  from ships
  join classes on classes.class = ships.class
) as q
where type = 'bb';

-- 055.sql
select q.class, min(launched)
from (
  select class
  from ships
  union
  select class
  from classes
) as q
left join ships on ships.class = q.class
group by q.class;

-- 056.sql
select distinct classes.class, count(q.class)
from classes
left join (
  select classes.class
  from outcomes
  left join ships on ships.name = outcomes.ship
  left join classes on classes.class = ships.class or classes.class = outcomes.ship
  where result = 'sunk'
) as q on q.class = classes.class
group by classes.class;

-- 060.sql
select
  q1.point,
  case when o is null
    then i
    else i - o
    end
from (
  select point, sum(inc) as i
  from income_o
  where date < '2001-04-15'
  group by point
) as q1
left join (
  select point, sum(out) as o
  from outcome_o
  where date < '2001-04-15'
  group by point
) as q2 on q1.point = q2.point;

-- 061.sql
select sum(ssum)
from (
  select point, sum(inc) as ssum
  from income_o
  group by point
   union
  select point, -sum(out) ssum
  from outcome_o
  group by point
) as q;

-- 062.sql
select sum(ssum)
from (
  select sum(inc) as ssum
  from income_o
  where date < '2001-04-15'
  union
  select -sum(out) as ssum
  from outcome_o
  where date < '2001-04-15'
) as q;

-- 063.sql
select name
from passenger
where id_psg in (
  select id_psg 
  from pass_in_trip
  group by id_psg, place
  having count(*) > 1
);

-- 064.sql
select income.point, income.date, 'inc', sum(income.inc)
from income
left join outcome on income.point = outcome.point
  and income.date = outcome.date
where outcome.date is null
group by income.point, income.date
union
select outcome.point, outcome.date, 'out', sum(outcome.out)
from income
right join outcome on income.point = outcome.point
  and income.date = outcome.date
where income.date is null
group by outcome.point, outcome.date

-- 065.sql
with listing as (
  select maker, type,
    case
      when type = 'PC' then 0
      when type = 'Laptop' then 1
      else 2
    end as type_inner,
    case
      when type = 'Laptop' and maker in (
        select maker
        from product
        where type = 'PC'
      ) then ''
      when type = 'Printer' and maker in (
        select maker
        from product
        where type = 'PC' or type = 'Laptop'
      ) then ''
      else maker
    end as maker_inner
  from product
  group by maker, type
)
select row_number() over (order by maker, type_inner), maker_inner, type
from listing;

-- 082.sql
with pcs as (
  select row_number() over (order by code) as i, code, price
  from pc
)
select pcs.code, avg(pcs_cur.price) as avg_price
from pcs
join pcs as pcs_cur
  on pcs_cur.i - pcs.i < 6
  and pcs_cur.i - pcs.i >= 0
group by pcs.i, pcs.code
having count(*) = 6;

-- 084.sql
select
  name,
  sum(case when date >= '2003-04-01' and date <= '2003-04-10' then 1 else 0 end),
  sum(case when date >= '2003-04-11' and date <= '2003-04-20' then 1 else 0 end),
  sum(case when date >= '2003-04-21' and date <= '2003-04-30' then 1 else 0 end)
from pass_in_trip
join trip on pass_in_trip.trip_no = trip.trip_no
join company on trip.id_comp = company.id_comp
where date >= '2003-04-01' and date <= '2003-04-30'
group by name

-- 085.sql
select maker
from product
group by maker
having
  count(distinct type) = 1
  and (
    min(type) = 'Printer'
    or min(type) = 'PC'
    and count(model) >= 3
  )

-- 087.sql
select distinct name, count(town_to) qty
from trip tr join pass_in_trip pit on tr.trip_no = pit.trip_no join
  passenger psg on pit.id_psg = psg.id_psg
where town_to = 'Moscow' and pit.id_psg not in(select distinct id_psg
  from trip tr join pass_in_trip pit on tr.trip_no = pit.trip_no
  where date+(time_out-'1900-01-01') = (select min (date+(time_out-'1900-01-01'))
    from trip tr1 join pass_in_trip pit1 on tr1.trip_no = pit1.trip_no
    where pit.id_psg = pit1.id_psg)
  and town_from = 'Moscow')
group by pit.id_psg, name
having count(town_to) > 1

-- 088.sql
select
  (select name from passenger where id_psg = r.id_psg)),
  r.trip_qty,
  (select name from company where id_comp = r.id_comp)
from (
  select
    pass_in_trip.id_psg,
    min(trip.id_comp) as id_comp,
    count(*) as trip_qty,
    max(count(*)) over() as max_qty
  from pass_in_trip
  inner join trip on pass_in_trip.trip_no = trip.trip_no
  group by pass_in_trip.id_psg
  having min(trip.id_comp) = max(trip.id_comp)
) as r
where r.trip_qty = r.max_qty

-- 089.sql
select maker, count(model)
from product
group by maker
having count(model) = (
  select max(qtys.qty)
  from (
    select maker, count(model) as qty
    from product
    group by maker
  ) qtys
)
union
select maker, count(model)
from product
group by maker
having count(model) = (
  select min(qtys.qty)
  from (
    select maker, count(model) as qty
    from product
    group by maker
  ) qtys
)

-- 102.sql
select passenger.name
from passenger
where passenger.id_psg in (
  select pass_in_trip.id_psg
  from pass_in_trip
  join trip on pass_in_trip.trip_no = trip.trip_no
  group by pass_in_trip.id_psg
  having count(
    distinct case
    when trip.town_from <= trip.town_to
    then trip.town_from || trip.town_to
    else trip.town_to || trip.town_from
    end
  ) = 1
);

-- 103.sql
select
  min(t1.trip_no) as min1,
  min(t2.trip_no) as min2,
  min(t3.trip_no) as min3,
  max(t1.trip_no) as max3,
  max(t2.trip_no) as max2,
  max(t3.trip_no) as max3
from trip as t1
cross join trip as t2
cross join trip as t3
where t3.trip_no > t2.trip_no and t2.trip_no > t1.trip_no;

-- 108.sql
select distinct b1.b_vol, b2.b_vol, b3.b_vol
from utb b1
join utb b2 on b2.b_vol > b1.b_vol
join utb b3 on b3.b_vol > b2.b_vol
where b3.b_vol <= sqrt(power(b2.b_vol, 2) + power(b1.b_vol, 2));

-- 110.sql
select name
from passenger
where id_psg in (
  select pass_in_trip.id_psg
  from trip
  join pass_in_trip on trip.trip_no = pass_in_trip.trip_no
  where extract(isodow from pass_in_trip.date) = 6 and trip.time_out > trip.time_in
);

-- 111.sql
select q_name, red
from (
  select
    q_id,
    sum(case when v_color = 'R' then b_vol else 0 end) as red,
    sum(case when v_color = 'G' then b_vol else 0 end) as green,
    sum(case when v_color = 'B' then b_vol else 0 end) as blue
  from utb
  join utv on b_v_id = v_id
  join utq on b_q_id = q_id
  group by q_id
) as colors
join utq on colors.q_id = utq.q_id
where red > 0 and red < 255 and red = green and red = blue;
