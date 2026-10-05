select a.employee_id
from Employees a
left join Employees m
on a.manager_id=m.employee_id
where a.salary < 30000 and a.manager_id is not null  and m.employee_id is null 
ORDER BY a.employee_id ASC;
