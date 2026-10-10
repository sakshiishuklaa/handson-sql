select country, DATE_FORMAT(trans_date, '%Y-%m') AS month, count(trans_date) as trans_count ,
sum(amount) as trans_total_amount,
ifnull(sum(state='approved'),0) as approved_count,
sum(case when state='approved' then amount else 0 end) as approved_total_amount

from Transactions
group by month,country;