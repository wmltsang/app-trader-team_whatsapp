With abc as (
	SELECT Distinct p.Name as app_name, count(p.name) as app_count
	FROM play_store_apps as p
	GROUP BY p.name)
Select app_name, app_count
	FROM abc 
WHERE app_count > 1
ORDER BY app_count DESC;