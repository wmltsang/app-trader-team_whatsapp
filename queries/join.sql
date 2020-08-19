SELECT a.name,
	to_number(a.review_count, '9999999999999') + p.review_count as reviews, 
	(to_number(a.review_count, '9999999999999') * 34.8) +
		to_number(left(p.install_count, -1), '9999999999') as installs,
	p.rating as p_rating, a.rating as a_rating,
	p.price as p_cost, a.price as a_cost
FROM app_store_apps as a
INNER JOIN play_store_apps as p
ON a.name = p.name
WHERE a.price <= 1 and to_number(p.price, '999999') <= 1
ORDER BY installs DESC, a.rating desc, name;