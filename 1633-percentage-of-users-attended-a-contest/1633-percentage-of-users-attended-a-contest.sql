select t.contest_id,round(t.co*100/(SELECT COUNT(*) FROM Users),2) as percentage
from
(select r.contest_id, count(r.user_id)as co
from Register r
group by r.contest_id)
t
order by percentage desc, t.contest_id asc;
