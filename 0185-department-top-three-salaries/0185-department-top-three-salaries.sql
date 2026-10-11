select d.name as  Department ,temp.name as Employee,salary as Salary
from(
select *,
dense_rank()over(partition by departmentId order by salary desc )
as rk
from Employee)
as temp
right join Department d
on temp.departmentId=d.id
where rk<=3;