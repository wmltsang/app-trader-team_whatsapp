with x as (Select p.name, 
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
			cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)))*2,0)/2),1) * 2) + 1 as longevity	 
FROM play_store_apps as p
INNER JOIN app_store_apps as a
ON p.name = a.name
		  where a.price <= 1 and 
		   cast(replace(replace(p.price,'$',''),'.','') as numeric(10,2)) <= 1)
Select name, total_reviews, total_installs, user_stars, star_years, longevity, star_years * longevity as user_years
from x
where rn = 1
ORDER BY user_years desc;