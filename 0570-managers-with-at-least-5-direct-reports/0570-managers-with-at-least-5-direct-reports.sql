select e.name
from Employee e
join(
select managerId,count(managerId)as co
from Employee
group by managerId
having co>=5 )t
on e.id=t.managerId;
