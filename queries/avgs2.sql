SELECT avg(rating) as avg_stars,
		(avg(rating)*2) + 1 as avg_longevity,
		avg(cast(review_count as numeric) * 25.5) as avg_users,
		avg(cast(review_count as numeric) * 25.5) * 8 as avg_user_years
From play_store_apps;
		