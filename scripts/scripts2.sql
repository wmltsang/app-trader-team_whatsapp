

-- avg price by genre --
SELECT CAST(avg(CAST(price as numeric(10,2))) as numeric(10,2))as avg_price, primary_genre as genres
FROM public.app_store_apps
WHERE price <= 1.00
GROUP BY primary_genre
UNION ALL
SELECT CAST(AVG(CAST(replace(price,'$','') as numeric(10,2))) as numeric(10,2)) as avg_price, genres
FROM  public.play_store_apps
WHERE CAST(replace(price,'$','') as numeric(10,2)) <= '1.00'
GROUP BY genres
ORDER BY 1 ASC


--- counts of app_store apps vs. play_Store_apps <= 1.00 ------
SELECT 'app_store_apps <= 1.00' as type,
	    COUNT(*)
FROM public.app_store_apps
WHERE price <= 1.00 --4784

--- counts of play_store apps <= 1.00 
SELECT 'play_store_apps <= 1.00' as type,
	    COUNT(*)
FROM public.play_store_apps
WHERE CAST(replace(price,'$','') as numeric(10,2)) <= '1.00'-- 10191



--- counts of app_store apps vs. play_Store_apps > 1.00 
SELECT 'app_store_apps > 1.00' as type,
       COUNT(*)
FROM public.app_store_apps
WHERE price > 1.00  -- 2413

--- counts of play_store apps > 1.00 
SELECT 'play_store_apps > 1.00' as type,
       COUNT(*)
FROM public.play_store_apps
WHERE CAST(replace(price,'$','') as numeric(10,2)) >'1.00' -- 649 

----------------------------------------------------------------------------


WITH x AS (
	       SELECT p.name, 
				  p.genres,
             cast(a.review_count as numeric(10,0)) + p.review_count as total_reviews,
            (cast(a.review_count as numeric(10,0)) * 25.5) + 
             cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)) as total_installs,
		   
        TRUNC((ROUND(((a.rating * (cast(a.review_count as numeric(10,0)) * 25.5)) + 
            (cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)) * p.rating))/
            ((cast(a.review_count as numeric(10,0)) * 25.5) + 
            cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)))*2,0)/2),1) as user_stars,
		   
        TRUNC(((a.rating * (cast(a.review_count as numeric(10,0)) * 25.5)) + 
            (cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)) * p.rating))/
            ((cast(a.review_count as numeric(10,0)) * 25.5) + 
            cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0))) * 
            (cast(a.review_count as numeric(10,0)) * 25.5) + 
            cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)),0) as star_years,
		   
            ROW_NUMBER() OVER (Partition by p.name) as rn,
		   
        (TRUNC((ROUND(((a.rating * (cast(a.review_count as numeric(10,0)) * 25.5)) + 
            (cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)) * p.rating))/
            ((cast(a.review_count as numeric(10,0)) * 25.5) + 
            cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)))*2,0)/2),1) * 2) + 1 as longevity,  
	  
	      CASE WHEN CAST(a.price as numeric(10,2)) > CAST(p.price as numeric(10,2)) THEN CAST(a.price as numeric(10,2)) 
		       WHEN CAST(p.price as numeric(10,2)) > CAST(a.price as numeric(10,2)) THEN CAST(p.price as numeric(10,2)) 
			   WHEN CAST(a.price as numeric(10,2)) = CAST(p.price as numeric(10,2)) THEN CAST(a.price as numeric(10,2)) 
	          ELSE 0.00 
	      END as total_purchase_price,
	
       
	      CAST(((((TRUNC((ROUND(((a.rating * (cast(a.review_count as numeric(10,0)) * 25.5)) + 
            (cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)) * p.rating))/
            ((cast(a.review_count as numeric(10,0)) * 25.5) + 
            cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)))*2,0)/2),1) * 2) + 1) * 12) * 5000) as numeric(12,2)) as total_gross_profit,
	
	      CAST(1000 as numeric(10,2)) as total_marketing_cost,
	
	      CAST((((((TRUNC((ROUND(((a.rating * (cast(a.review_count as numeric(10,0)) * 25.5)) + 
            (cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)) * p.rating))/
            ((cast(a.review_count as numeric(10,0)) * 25.5) + 
            cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)))*2,0)/2),1) * 2) + 1) * 12) * 5000) - 1000) as numeric(12,2)) as total_Net
	
FROM play_store_apps as p
INNER JOIN app_store_apps as a
ON p.name = a.name
WHERE   a.price <= 1 and 
         cast(replace(replace(p.price,'$',''),'.','') as numeric(10,2)) <= 1

 )

SELECT name, 
	   genres,
	  total_reviews, 
	  total_installs, 
	  user_stars, 
	  star_years, 
	  longevity, 
	  star_years * longevity as user_years,
	  total_purchase_price,
	  total_gross_profit,
	  total_marketing_cost,
	  total_Net
	  
FROM x
WHERE rn = 1
ORDER BY user_years desc;



