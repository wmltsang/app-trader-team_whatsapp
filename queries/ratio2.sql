SELECT sum(to_number(left(install_count, -1),'99999999999999999'))/sum(review_count)
FROM play_store_apps
Where install_count <> '0' and install_count <> '0+';