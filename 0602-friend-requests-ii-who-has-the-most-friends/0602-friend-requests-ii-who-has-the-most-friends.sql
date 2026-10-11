select requester_id as id,sum(p) as num
from
(select requester_id,count( requester_id) as p
from RequestAccepted
group by requester_id
union all 
select accepter_id,count( accepter_id)
from RequestAccepted
group by accepter_id)
as num
group by requester_id
order by sum(p) desc limit 1;