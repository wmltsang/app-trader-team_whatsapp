Select sum(cast(replace(replace(p.install_count, '+',''), ',','') as numeric)) / 
	sum(p.review_count) as ratio
FROM play_store_apps as p
INNER JOIN app_store_apps as a
ON p.name = a.name;