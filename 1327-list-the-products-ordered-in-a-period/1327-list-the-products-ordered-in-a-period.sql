select p.product_name,sum(o.unit) as unit
from Products p
right join Orders o
on p.product_id=o.product_id
where o.order_date BETWEEN '2020-02-01' AND '2020-02-29'
group by o.product_id
HAVING SUM(o.unit) >= 100;
