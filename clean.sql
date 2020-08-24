
-- common apps to both tables by name, avg rating
SELECT distinct name 
      ,CAST(AVG(ROUND(Rating,2)) as DECIMAL(5,2)) as avg_rating
FROM play_store_apps
WHERE name IN ( SELECT DISTINCT Name from app_store_apps)
GROUP BY Name
ORDER BY 2 DESC
-- review counts---
SELECT primary_genre
         ,content_rating
         ,CAST(review_count as INT)
FROM app_store_apps
ORDER BY 3 DESC

SELECT   genres
         ,content_rating
         ,CAST(review_count as INT)
FROM public.play_store_apps
ORDER BY 3 DESC;

SELECT DISTINCT content_rating
FROM public.play_store_apps

SELECT DISTINCT content_rating
FROM public.app_store_apps

select max(rating) 
FROM public.play_store_apps
order by price desc

select  max(rating) 
FROM public.app_store_apps
order by price DESC

SELECT x.name, 
       x.price,
       x.content_rating,
       x.genres,
       RANK() OVER(ORDER BY price)
FROM (
    SELECT name, CAST(REPLACE(price,'$','') as DECIMAL(10,2)) as price, CAST(review_count as INT), rating, content_rating, genres
    FROM public.play_store_apps
    UNION
    SELECT name, CAST(price as DECIMAL(10,2)) as price, CAST(review_count as INT), rating, content_rating, primary_genre as genres
    FROM public.app_store_apps
    )x
    ORDER BY x.price DESC
    
    
SELECT name, 
       price,
       content_rating,
       genres,
       RANK() OVER(ORDER BY price DESC)    
    FROM public.play_store_apps
WHERE name IN ( SELECT DISTINCT Name from app_store_apps)
-- Load data table with combined data rows--
SELECT x.*
INTO temp table data 
FROM (
    SELECT name, 
           --CAST(REPLACE(price,'$','') as DECIMAL(10,2)) as price, 
            CAST(REPLACE(price,'$','') as decimal) as price,
            CASE WHEN CAST(REPLACE(price,'$','') as decimal) <= 1.00 THEN 10000
                ELSE 10000 * CAST(REPLACE(price,'$','') as decimal)
            END as total_price,
            CAST(review_count as INT), 
            COALESCE(rating,0) as rating,
            CAST(rating as decimal)*2+1 expected_longevity,  
            content_rating, 
            CAST(REPLACE(REPLACE(install_count,',',''),'+','') as int) as install_count,
            genres
    FROM public.play_store_apps
UNION
    SELECT name, 
           --CAST(REPLACE(price,'$','') as DECIMAL(10,2)) as price, 
             CAST(price as decimal) as price,
            CASE WHEN price <= 1.00 THEN 10000
                ELSE 10000 * CAST(price as Decimal)
            END as total_price,
            CAST(review_count as INT), 
            COALESCE(rating,0) as rating,
            CAST(rating as decimal)*2+1 expected_longevity,
	        content_rating, 
           CAST(0 as int) as install_count,
           primary_genre as genres
    FROM public.app_store_apps
    )x
 
ALTER TABLE data
ADD profit numeric;

INSERT INTO data (profit)
SELECT (5000/2-1000)* 12 * expected_longevity - total_price
FROM data;

select *
from data
where profit is not null;
 
    --DROP TABLE DATA
    --select * from data
    -- CHECK FOR DUPES -- 
    --select name, price, review_count, rating, content_rating, genres, count(*)
    --from data
    --group by name, price, review_count, rating, content_rating, genres
    --HAVING count(*) > 1
    
    -- by avg total price, genre --- 
  SELECT CAST(AVG(total_price) as decimal(10,2)) as avg_total_price,
         genres
  FROM data
  GROUP BY genres
  ORDER BY 1 desc
  
 --average review count is 244602
 select sum(review_count)/count(*)
  from data
        
 select name, price, total_price, review_count, expected_longevity, rating, genres, install_count
 from data
 where install_count>0
 order by rating desc, review_count desc

--revenue for each app for app trader
--revenus is fixed 5000/2 for app trader as developer retains half
--profit for each app: 

 select name, price, total_price, review_count, expected_longevity, rating, genres, install_count, ((5000/2-1000)*12*expected_longevity) as profit, (1000/install_count) as cost_per_user, (5000/2*(expected_longevity)*12/install_count) as revenue_per_user
 from data
 where install_count>0
 order by rating desc, review_count desc, cost_per_user asc
 
  --(revenue_per_user - cost_per_user) as profit_per_user
  --(((5000/2-1000)*12*expected_longevity)-total_price) as profit, (1000/install_count) as cost_per_user, (5000/2*(expected_longevity)*12/install_count) as revenue_per_user, ((5000/2*(expected_longevity)*12/install_count)-(1000/install_count)) as profit_per_user

select distinct name, price, total_price, review_count,rating, genres, install_count, (((5000/2-1000)*12* (rating*2+1))-total_price) as profit
from data
where install_count>0 and review_count > 244602 
group by name, price, total_price, review_count,rating, genres, install_count, profit
	
select distinct name, price, total_price, review_count,rating, genres, expected_longevity, install_count, profit,
 RANK () OVER ( ORDER BY profit desc, review_count desc, rating desc, expected_longevity desc, install_count desc
	) app_rank 
 from data
 where install_count>0 and review_count > 244602 
 group by name, price, total_price, review_count,rating, genres, expected_longevity, install_count, profit

 

 
