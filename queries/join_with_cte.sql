With x as (Select distinct p.name as name, 
	cast(a.review_count as numeric(10,0)) + p.review_count as total_reviews,
	(cast(a.review_count as numeric(10,0)) * 25.5) + 
		 cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)) as total_installs,
	((a.rating * (cast(a.review_count as numeric(10,0)) * 25.5)) + 
		(cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)) * p.rating))/
		((cast(a.review_count as numeric(10,0)) * 25.5) + 
		 cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0))) as user_stars,
	((a.rating * (cast(a.review_count as numeric(10,0)) * 25.5)) + 
		(cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)) * p.rating))/
		((cast(a.review_count as numeric(10,0)) * 25.5) + 
		 cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0))) * 
		   	(cast(a.review_count as numeric(10,0)) * 25.5) + 
		 cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)) as star_years
FROM play_store_apps as p
INNER JOIN app_store_apps as a
ON p.name = a.name)
Select name, total_reviews, total_installs, user_stars, star_years
from x
ORDER BY star_years desc;