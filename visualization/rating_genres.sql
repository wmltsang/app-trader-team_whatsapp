 --temp table is easier to use than common table
 select x.* into temp table data from(
	       SELECT p.name,
				  p.genres,
             cast(a.review_count as numeric(10,0)) + p.review_count as total_reviews,
            (cast(a.review_count as numeric(10,0)) * 25.5) +
             cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)) as total_installs,
		  
        TRUNC((ROUND(((a.rating * (cast(a.review_count as numeric(10,0)) * 25.5)) +
            (cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)) * p.rating))/
            ((cast(a.review_count as numeric(10,0)) * 25.5) +
            cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)))*2,0)/2),1) as user_stars,
		  
        TRUNC(((a.rating * (cast(a.review_count as numeric(10,0)) * 25.5)) +
            (cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)) * p.rating))/
            ((cast(a.review_count as numeric(10,0)) * 25.5) +
            cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0))) *
            (cast(a.review_count as numeric(10,0)) * 25.5) +
            cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)),0) as star_years,
		  
            ROW_NUMBER() OVER (Partition by p.name) as rn,
		  
        (TRUNC((ROUND(((a.rating * (cast(a.review_count as numeric(10,0)) * 25.5)) +
            (cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)) * p.rating))/
            ((cast(a.review_count as numeric(10,0)) * 25.5) +
            cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)))*2,0)/2),1) * 2) + 1 as longevity,
	 
	      CASE WHEN CAST(a.price as numeric(10,2)) > CAST(p.price as numeric(10,2)) THEN CAST(a.price as numeric(10,2))
		       WHEN CAST(p.price as numeric(10,2)) > CAST(a.price as numeric(10,2)) THEN CAST(p.price as numeric(10,2))
			   WHEN CAST(a.price as numeric(10,2)) = CAST(p.price as numeric(10,2)) THEN CAST(a.price as numeric(10,2))
	          ELSE 0.00
	      END as total_purchase_price,
	
	      CAST(((((TRUNC((ROUND(((a.rating * (cast(a.review_count as numeric(10,0)) * 25.5)) +
            (cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)) * p.rating))/
            ((cast(a.review_count as numeric(10,0)) * 25.5) +
            cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)))*2,0)/2),1) * 2) + 1) * 12) * 5000/2) as numeric(12,2)) as total_gross_profit,
	
	      CAST(1000 as numeric(10,2)) as total_marketing_cost,
	
	      CAST((((((TRUNC((ROUND(((a.rating * (cast(a.review_count as numeric(10,0)) * 25.5)) +
            (cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)) * p.rating))/
            ((cast(a.review_count as numeric(10,0)) * 25.5) +
            cast(replace(replace(p.install_count,'+',''),',','') as numeric (10,0)))*2,0)/2),1) * 2) + 1) * 12) * 5000/2) - 1000) as numeric(12,2)) as total_Net
	
FROM play_store_apps as p
INNER JOIN app_store_apps as a
ON p.name = a.name
WHERE   a.price <= 1 and
         cast(replace(replace(p.price,'$',''),'.','') as numeric(10,2)) <= 1
 ) x


--graph for common genres to both stores
/*select genres, count(genres) as counts_genres
from x
group by genres
order by counts_genres desc*/

--common genres to both stores by install counts
/*select sum(total_installs) as genres_installs, genres
from x
group by genres
order by genres_installs desc*/

--common genres to both stores by ratings and create a table in excel for visualization
select distinct genres, count(genres) as cnt, user_stars
from data
group by genres, user_stars
order by user_stars desc, cnt desc

--nonaggregate fields need to be in groupby
      
   
/*SELECT genres, user_stars, cnt
FROM (
select  distinct genres,
        user_stars,
       COUNT(genres) as cnt,
       ROW_NUMBER() OVER(PARTITION BY  genres
                                 ORDER BY count(genres) DESC) AS rn
from data
WHERE rn = 1
group by genres, user_stars
) xx
WHERE xx.rn = 1*/




/*SELECT
    genres, user_stars, count(genres) 
FROM
    (
    SELECT
        DISTINCT(genres), user_stars, MIN(Inserted) AS First
    FROM
        x
    GROUP BY
        user_stars
    ) foo
    JOIN
    x ON foo.user_stars = x.user_stars AND foo.First = x.Inserted*/



/*SELECT name, 
	   genres,
	  total_reviews, 
	  total_installs, 
	  user_stars, 
	  star_years, 
	  longevity, 
	  star_years * longevity as user_years,
	  total_purchase_price,
	  total_gross_profit,
	  total_marketing_cost,
	  total_Net
	  
FROM x
WHERE rn = 1
ORDER BY user_years desc;*/

/*select distinct(name), 
	   genres,
	  total_reviews, 
	  total_installs, 
	  user_stars, 
	  star_years, 
	  longevity, 
	  star_years * longevity as user_years,
	  total_purchase_price,
	  total_gross_profit,
	  total_marketing_cost,
	  total_Net,
RANK() OVER (ORDER BY total_Net desc, (star_years * longevity) desc) AS xRank
 from x
where rn = 1
order by xRank asc*/

/*SELECT name,
	   genres,
	  total_reviews, 
	  total_installs, 
	  user_stars, 
	  star_years, 
	  longevity, 
	  star_years * longevity as user_years,
	  total_purchase_price,
	  total_gross_profit,
	  total_marketing_cost,
	  total_Net,
FROM x
where rn = 1
group by name, genre
order by genre desc*/


