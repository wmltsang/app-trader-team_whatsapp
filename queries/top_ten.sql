Select p.name, 
	cast(a.review_count as numeric(10,0)) + p.review_count as total_reviews,
	(cast(a.review_count as numeric(10,0)) * 25.5) + 
		 cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)) as total_installs,
	((a.rating * (cast(a.review_count as numeric(10,0)) * 25.5)) + 
		(cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)) * p.rating))/
		((cast(a.review_count as numeric(10,0)) * 25.5) + 
		 cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)))	as user_stars,
	a.review_count as apple_review,
	a.rating as apple_rating,
	p.rating as play_rating,
	cast(a.review_count as numeric(10,0)) * 25.5 as apple_installs,
	p.install_count as play_installs
FROM play_store_apps as p
INNER JOIN app_store_apps as a
ON p.name = a.name;