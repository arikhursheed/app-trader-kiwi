SELECT  *,
--one time cost from buying the app. this depends on NULL values when app is only on one store
	(CASE 
		WHEN app_price IS NULL THEN 0
		WHEN app_price < 1 THEN 10000
		ELSE app_price*10000 end)
	+
	(CASE
		WHEN play_price IS NULL THEN 0
		WHEN play_price<1 then 10000
		ELSE play_price*10000 end)
	AS buy_cost

FROM(
	--Full Join both tables as subquery
	SELECT name 
		,app_store_apps.price as app_price, play_store_apps.price::money::numeric as play_price 
		--Prices as money. for play_price, need to cast text to money then to numeric.  
		,ROUND((COALESCE(app_store_apps.rating,0)/.5),0)*.5 as app_rating, ROUND(COALESCE(play_store_apps.rating,0)/.5,0)*.5 as play_rating 
		--ratings, removing nulls and rounding to nearest .5
	FROM app_store_apps FULL JOIN play_store_apps
	Using (name)
	order by play_rating desc) as sub_query
	WHERE app_price IS NOT NULL AND play_price IS NOT NULL


	
