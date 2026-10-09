select s.user_id,round(
ifnull(
sum(case when c.action ='confirmed' then 1 else 0 end)/count(c.time_stamp),0.00)
,2)
as confirmation_rate
from Signups s
left join Confirmations c
on s.user_id=c.user_id
group by c.user_id;
