SELECT *
FROM app_store_apps;


--FR0M DIEGO
--puts all apps in one table (overlap only counted once)
--SELECT name, app_store_apps.price as app_price, play_store_apps.price as play_price
SELECT *
FROM app_store_apps FULL JOIN play_store_apps
USING (name)
ORDER BY name;

--FR0M DIEGO
--finds only the overlap
SELECT app_store_apps.primary_genre as app_genre, play_store_apps.genres as play_genre
FROM app_store_apps FULL JOIN play_store_apps
Using (name)
WHERE app_store_apps.primary_genre IS NOT NULL AND play_store_apps.genres IS NOT NULL
order by name;

----NEXT: Build naming protocols, determine what fields to group/filter by for tallying top 10
----Determine which things to look at for things they should keep an eye on (e.g., highest rated category groups)
---- Try RANK to rank those wtih AVERAGE RATING(?) and RANK as High/Medium/Low?