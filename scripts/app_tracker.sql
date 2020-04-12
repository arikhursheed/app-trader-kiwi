
-- Organized the table to display commmon apps in both stores (2.e)

/*select  distinct name, price, review_count, rating, content_rating, primary_genre 
from app_store_apps as A

select name, price::money::numeric, review_count, rating, content_rating, category 
from play_store_apps as P */

/*
select distinct p.name, p.price::money::numeric(5,2) as play_price, a.price as app_price
 		, p.rating as play_rating, a.rating as app_rating
		, p.review_count as play_rev_count, a.review_count::integer as app_rev_count
		, a.content_rating as app_content_rating --only using from app store bc description should be similar 
		, a.primary_genre as genres --only using from app store bc description should be similar
 from play_store_apps as P 
 inner join app_store_apps as A 
 using(name)
*/

-- Rating lifespan in year, by building a logic to approach (1 + rating/0.5) (2.d)
Select distinct name, genres, content_rating,  play_rating, round((1+play_rating/0.5), 0) as play_lifespan, app_rating, round((1+app_rating/0.5), 0) as app_lifespan
 
 -- to get maximum lifespan of play and app stores, we need to use case clause (2.c)
 , case when round((1+play_rating/0.5), 0) > round((1+app_rating/0.5), 0) then round((1+play_rating/0.5), 0) else round((1+app_rating/0.5), 0) end as max_lifespan

-- now multiply by 12,000 becuase we pay 12,000 per year (2.c)
 , (case when round((1+play_rating/0.5), 0) > round((1+app_rating/0.5), 0) then round((1+play_rating/0.5), 0) else round((1+app_rating/0.5), 0) end) * 12000 as cost_lifespan

-- calculate total revenue (2.b)
 , round((1+play_rating/0.5), 0) * 12 * 5000 as play_revenue --play_lifespan (year) x 12 months x 5000
 , round((1+app_rating/0.5), 0) * 12 * 5000 as app_revenue --app_lifespan (year) x 12 months x 5000
 , (round((1+play_rating/0.5), 0) * 12 * 5000) + (round((1+app_rating/0.5), 0) * 12 * 5000) as total_revenue -- play_revenue + app_revenue

-- calculate purchase cost (2.a)
  ,case when play_price >= 0 and play_price <=1 then 10000 else play_price * 10000 end as play_purchase 
  ,case when app_price >= 0 and app_price <=1 then 10000 else app_price * 10000 end as app_purchase
  ,(case when play_price >= 0 and play_price <=1 then 10000 else play_price * 10000 end) + (case when app_price >= 0 and app_price <=1 then 10000 else app_price * 10000 end) as total_purchase

-- calculate profit = total_revenue - cost_lifespan - total_purchase 
 , round((round((1+play_rating/0.5), 0) * 12 * 5000) + (round((1+app_rating/0.5), 0) * 12 * 5000) 
    - (case when round((1+play_rating/0.5), 0) > round((1+app_rating/0.5), 0) then round((1+play_rating/0.5), 0) else round((1+app_rating/0.5), 0) end) * 12000 
	- (case when play_price >= 0 and play_price <=1 then 10000 else play_price * 10000 end) + (case when app_price >= 0 and app_price <=1 then 10000 else app_price * 10000 end), 0)  as profit 
	
--, play_price, app_price, play_rating, app_rating, play_rev_count, app_rev_count, app_content_rating, genres --new column names
 
 from (
-- to get unique apps we need to use distinct in our subquery
 Select distinct p.name, p.price::money::numeric(5,2) as play_price, a.price as app_price
 		, round(p.rating/ 0.5, 0) * 0.5 as play_rating, round(a.rating/ 0.5, 0) * 0.5 as app_rating -- rounded rating by 0.5
		, p.review_count as play_rev_count, a.review_count::integer as app_rev_count
		, a.content_rating as content_rating --only using from app store bc description should be similar 
		, a.primary_genre as genres --only using from app store bc description should be similar
 from play_store_apps as P 
 inner join app_store_apps as A 
 using(name) 
) as sub_apps --use allias for subquery

-- order by profit to get the most profitable apps 
order by profit desc
limit 10;
			



 