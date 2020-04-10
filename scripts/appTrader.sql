--adding a column to the table app_store_apps called coulmn
alter table app_store_apps add column coulmn varchar;


--puts all apps in one table (overlap only counted once)

SELECT name, app_store_apps.price as app_price, play_store_apps.price as play_price
FROM app_store_apps FULL JOIN play_store_apps
Using (name)
order by name;


--finds only the overlap
SELECT app_store_apps.primary_genre as app_genre, play_store_apps.genres as play_genre
FROM app_store_apps FULL JOIN play_store_apps
Using (name)
WHERE app_store_apps.primary_genre IS NOT NULL AND play_store_apps.genres IS NOT NULL
order by name;

--select only apps appear in both stores with prices and add the two prices in a new column called purchase
SELECT DISTINCT(name),app_price,play_price,
                     (SELECT (app_play_prices.app_price)+cast(app_play_prices.play_price as numeric) as purchase)              
FROM (SELECT name, cast(app_store_apps.price as numeric) as app_price,
	              cast(play_store_apps.price as numeric) as play_price,
	              cast(app_store_apps.coulmn as numeric) as purchase
      FROM app_store_apps FULL JOIN play_store_apps
      Using (name)
      order by name) AS app_play_prices 
WHERE app_price IS NOT NULL AND play_price IS NOT NULL;
