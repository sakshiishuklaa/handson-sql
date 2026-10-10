(select u.name as results
from Users u
left join MovieRating m
on u.user_id=m.user_id
group by u.user_id, u.name
order by (count(movie_id)) desc,u.name asc limit 1)
union all
(select v.title as results
from Movies v
left join MovieRating m
on v.movie_id=m.movie_id
where m.created_at >= '2020-02-01'
  and m.created_at < '2020-03-01'
group by v.movie_id,v.title
order by avg(rating) desc,v.title asc limit 1);