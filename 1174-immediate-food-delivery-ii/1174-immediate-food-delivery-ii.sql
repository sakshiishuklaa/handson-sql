select 
round(ifnull(
avg(case when order_date=customer_pref_delivery_date then 1 else 0 end )*100,0),2 )as immediate_percentage
from Delivery
where (customer_id,order_date) in (
    select customer_id, MIN(order_date)
    from Delivery
    GROUP BY customer_id
);