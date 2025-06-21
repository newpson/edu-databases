-- L-0177
/* ... (N) */
with ranked as (
  select
    employee.salary,
    dense_rank() over (order by employee.salary desc) as i
  from employee
)
select max(ranked.salary)
from ranked
where ranked.i = N;
/* ... */

-- L-0178
select
  score,
  dense_rank() over (order by score desc) as rank
from scores;

-- L-0197
with lagged as (
  select id, temperature, recorddate,
    lag(temperature) over (order by recorddate) as last_temperature,
    lag(recorddate) over (order by recorddate) as last_date
  from weather
)
select id
from lagged
where temperature > last_temperature
  and recorddate = last_date + interval '1 day';
