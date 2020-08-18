SELECT SUM(to_number(LEFT(install_count, -1),'9999999999999999999'))/SUM(review_count)
FROM play_store_apps
Where install_count <> '0';