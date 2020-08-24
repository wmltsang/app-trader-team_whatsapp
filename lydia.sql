--3.53
--select round(avg(rating),2)
--from app_store_apps

--4.19
--select round(avg(rating),2)
--from play_store_apps

/*select p.name,p.genre,
from play_store_apps p
join app_store_apps a
on p.name = a.name
group by genre*/

--apple store,there are free apps with 5 star rating. Categories are games mainly
/*select name, rating, price, review_count, primary_genre
from app_store_apps
group by name,rating,price,review_count, primary_genre
order by rating desc, price, review_count desc
limit 10;*/

--android store has five star with only 1x review counts so i switch the orders of rating. personalization 
--and other games are mainly. the price is 0.99 for the top ten. 
/*select name, rating, review_count, price, genres
from play_store_apps
where rating is not null
group by name, rating, review_count, price, genres
order by price, review_count desc, rating desc
limit 10;*/


/*select s.name, s.rating, s.price, s.review_count, s.primary_genre
from
(select *
from app_store_apps a
inner join play_store_apps p
on a.name = p.name) as s*/



