SELECT name, 
	to_number(review_count, '9999999999') as reviews, 
	to_number(review_count, '999999999') * 25.5 as install_count
FROM app_store_apps
UNION
SELECT name,
	review_count as reviews,
	to_number(left(install_count, -1), '9999999999') as install_count
FROM play_store_apps
	Where install_count <> '0'
ORDER by name;