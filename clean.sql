
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
            CAST(REPLACE(price,'$','') as NUMERIC(5,2)) as price,
            CASE WHEN CAST(REPLACE(price,'$','') as decimal(5,2)) <= 1.00 THEN 10000
                ELSE 10000 * CAST(REPLACE(price,'$','') as decimal(5,2))
            END as total_price,
            CAST(review_count as INT), 
            COALESCE(rating,0) as rating,
            CASE WHEN rating = '0' THEN  '1'
                 WHEN rating = '0.5' THEN '2' 
                 WHEN rating = '1.0' THEN '3' 
                 WHEN rating = '1.5' THEN '4' 
                 WHEN rating = '2.0' THEN '5' 
                 WHEN rating = '2.5' THEN '6' 
                 WHEN rating = '3.0' THEN '7' 
                 WHEN rating = '3.5' THEN '8' 
                 WHEN rating = '4.0' THEN '9' 
                 WHEN rating = '4.5' THEN '10' 
                 WHEN rating = '5.0' THEN '11' 
                ELSE 0
                END as expected_longevity  ,
            content_rating, 
            CAST(REPLACE(REPLACE(install_count,',',''),'+','') as int) as install_count,
            genres
    FROM public.play_store_apps
UNION
    SELECT name, 
           --CAST(REPLACE(price,'$','') as DECIMAL(10,2)) as price, 
             CAST(price as NUMERIC(5,2)) as price,
            CASE WHEN price <= 1.00 THEN 10000
                ELSE 10000 * CAST(price as Decimal(5,2))
            END as total_price,
            CAST(review_count as INT), 
            COALESCE(rating,0) as rating,
            CASE WHEN rating = '0' THEN  '1'
                 WHEN rating = '0.5' THEN '2' 
                 WHEN rating = '1.0' THEN '3' 
                 WHEN rating = '1.5' THEN '4' 
                 WHEN rating = '2.0' THEN '5' 
                 WHEN rating = '2.5' THEN '6' 
                 WHEN rating = '3.0' THEN '7' 
                 WHEN rating = '3.5' THEN '8' 
                 WHEN rating = '4.0' THEN '9' 
                 WHEN rating = '4.5' THEN '10' 
                 WHEN rating = '5.0' THEN '11' 
                ELSE 0
                END as expected_longevity  ,
            content_rating, 
           CAST(0 as int) as install_count,
           primary_genre as genres
    FROM public.app_store_apps
    )x
    
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
 select distinct name, price, total_price, review_count, expected_longevity, rating, genres, install_count, (((5000/2-1000)*12*expected_longevity)-total_price) as profit
 from data
 where install_count>0 and review_count > 50
 group by name, price, total_price, review_count, expected_longevity, rating, genres, install_count
 order by profit desc, review_count desc, rating desc
 

 
 
