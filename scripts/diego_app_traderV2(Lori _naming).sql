-- Create CTE that includes ALL data joined by name.  If neither price_app or price_play are Null, then app is on both stores. 
With 
all_data AS (	SELECT 	DISTINCT(name),
							app_store_apps.size_bytes AS size_app,
							play_store_apps.size AS size_play,
							app_store_apps.price AS price_app,
							play_store_apps.price::money::numeric as price_play, --price on play store is text with $, change to money and then numeric
							--app_store_apps.currency AS currency_app, --Currency only on app_store_apps. All records are USD. Omitting from table.
							--play_store_apps.type AS type_play -- only in play store, ommitting
							app_store_apps.review_count AS rev_count_app,
							play_store_apps.review_count AS rev_count_play,
							app_store_apps.rating AS rating_app,
							play_store_apps.rating AS rating_play,
							app_store_apps.content_rating AS content_rating_app,
							play_store_apps.content_rating AS content_rating_play,
							app_store_apps.primary_genre AS primary_genre_app,
							play_store_apps.category AS primary_genre_play,
							play_store_apps.genres AS genres_play,
							play_store_apps.install_count AS install_count_play,
				  			-- Calculates lifespan	
							(1+(ROUND(COALESCE(app_store_apps.rating,0)/.5,0)*.5)/.5)*12 as life_app, 
							(1+(ROUND(COALESCE(play_store_apps.rating,0)/.5,0)*.5)/.5)*12  as life_play
					FROM app_store_apps FULL JOIN play_store_apps
					Using (name)),
--Create CTE that calculates profit, using cost_rev subquery for revenue and costs	
financials AS (SELECT *, (revenue - buy_cost - marketing_cost)	as profit
					FROM (
						--This sub-query query calculates revenues and costs 
						SELECT  DISTINCT(name),
						--One time cost from buying the app. 
						--Added together, as price in each store is separate
						--this depends on NULL values when app is only on one store
							(CASE 
								WHEN price_app IS NULL THEN 0
								WHEN price_app < 1 THEN 10000
								ELSE price_app*10000 end)
							+
							(CASE
								WHEN price_play IS NULL THEN 0
								WHEN price_play<1 then 10000
								ELSE price_play*10000 end)
							AS buy_cost,
						--Total marketing cost,
						--1000 per month, only counted once when app is in both stores
						-- depends on NULL value for life of app when not in store
							(CASE 
								WHEN price_app IS NULL OR life_app <= life_play THEN ROUND(life_play*1000,0)
								WHEN price_play IS NULL OR life_app > life_play THEN ROUND(life_app*1000,0) end)
							 as marketing_cost,
						---Revenue
						---$5000 per month per store
							(CASE 
								WHEN life_app IS NULL THEN 0
								ELSE ROUND(life_app*5000,0) end)
							+
							(CASE
								WHEN life_play IS NULL THEN 0
								ELSE ROUND(life_play*5000,0) end)
							AS revenue
						FROM all_data) as cost_rev
					Order by profit desc)
					

,TOP_100 AS 	(SELECT DISTINCT NAME, *
			FROM financials LEFT JOIN all_data
			USING (name)
				ORDER BY profit desc
				LIMIT 100)
				

/*	-- top100 apps grouped into category, with count and profit
SELECT primary_genre_play as genre, count(*), AVG(profit) as avg_profit
FROM top_100
GROUP BY genre
ORDER BY count desc, avg_profit desc
*/

/* --NOT USEFUL
SELECT max(profit) as max_profit, max(ROI) as max_roi, min(profit) as min_profit, min(ROI) as min_roi, stores FROM(
SELECT name, profit, ROUND(100*profit/(buy_cost + marketing_cost),2) as ROI, 
			CASE WHEN price_app IS NOT NULL AND price_play IS NOT NULL THEN 'both stores' ELSE 'one store' END as stores
FROM financials left JOIN all_data
USING (name)
ORDER BY roi desc, profit) as roi_table
GROUP BY stores
*/

/*
--query that shows avg profit and count by app store primary genre
SELECT primary_genre_app, avg(profit) as avg_profit, COUNT(*)
FROM financials LEFT JOIN all_data
USING (name)
GROUP BY primary_genre_app
ORDER BY AVG(profit) desc
*/

/*
-- ALL APPS with profit, genre, reviews, ROI.  USE FOR TOP 10
SELECT name, AVG(rev_count_app::int + rev_count_play) as total_revs, profit, AVG(buy_cost) as buy_cost, AVG(marketing_cost) as mkt_cost, AVG(revenue) as revenue, primary_genre_app, ROUND(100*profit/(buy_cost + marketing_cost),2) as ROI
FROM financials left join all_data
USING(name)
GROUP BY name, profit, primary_genre_app, ROI
ORDER BY profit desc, total_revs desc
*/
/*
-- count and average profit by price_app, only includes ones in both stores. 
SELECT DISTINCT(price_app), COUNT(*), ROUND(AVG(profit),0) as avg_profit
FROM financials LEFT JOIN all_data 
USING (name)
WHERE price_app IS NOT NULL AND price_play IS NOT NULL
GROUP BY price_app
*/
