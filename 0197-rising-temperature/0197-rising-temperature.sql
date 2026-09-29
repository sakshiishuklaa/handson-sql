select id  
from
(
    select id,recordDate,temperature,
    LAG(recordDate) OVER (order by recordDate) as previous_date,
    LAG(temperature) OVER (order by recordDate) as previous_temp
    from Weather
)
as temp
where temperature>previous_temp
and datediff(recordDate,previous_date)=1;