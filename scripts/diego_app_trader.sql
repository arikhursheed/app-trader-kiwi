

--Full Join both tables
SELECT name 
	,CAST(app_store_apps.price as money) as app_price, CAST(play_store_apps.price as money)as play_price 
	--Prices as money
	,(COALESCE(app_store_apps.rating,0)/.5 as app_rating, COALESCE(play_store_apps.rating,0) as play_rating 
	--ratings 
FROM app_store_apps FULL JOIN play_store_apps
Using (name)
order by play_rating desc

