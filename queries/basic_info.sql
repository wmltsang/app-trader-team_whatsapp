WITH x as (Select name, rating, review_count, install_count,
	ROW_NUMBER() OVER(partition by name) as rn
FROM play_store_apps
WHERE name in ('Instagram','Subway Surfers','WhatsApp Messenger','Facebook','Hangouts','Google Street View','Google Play Movies & TV','Candy Crush Saga','Twitter','Temple Run 2'
))
SELECT name, rating, review_count, install_count
FROM x
where rn = 1;