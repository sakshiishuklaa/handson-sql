# Write your MySQL query statement below
select a.employee_id,a.name,count(m.reports_to)as reports_count ,round(avg(m.age),0) as average_age
from Employees a
join Employees m
on a.employee_id=m.reports_to
group by a.employee_id
order by a.employee_id;
