select product_id, year AS first_year, quantity, price
from sales
where (product_id,year) in(
    select product_id,min(year)
    from sales
    group by product_id
);