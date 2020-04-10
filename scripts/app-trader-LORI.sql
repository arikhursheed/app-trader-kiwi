--To get all play_store records
SELECT *
	FROM play_store_apps;

--To get all app_store records
SELECT *
	FROM play_store_apps;

--To get the count of play_store categories (33) and genres (119).
SELECT  COUNT (DISTINCT category) AS category, COUNT (DISTINCT genres) AS genres
	FROM play_store_apps;

--To get list of distinct currency types from app_store
SELECT currency
	FROM app_store_apps
	WHERE currency IS NOT NULL;

--FR0M DIEGO
--puts all apps in one table (overlap only counted once)
--
SELECT play_store_apps.category
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


/*FULL JOIN of app_ & play_ table (designed by me)
	with naming protocols to create similar names (for readability), 
	and similar columns placed side by side */
SELECT 
	app_store_apps.name AS name_app,   --_app is APPLE IOS
	play_store_apps.name AS name_play, --_play is ANDROID IOS
	app_store_apps.size_bytes AS size_app, 
	play_store_apps.size AS size_play, 
	app_store_apps.price AS price_app, 
	play_store_apps.price AS price_play, 
	--app_store_apps.currency AS currency_app, --Currency only on app_store_apps. All records are USD. Omitting from table.
	play_store_apps.type AS type_play, 
	app_store_apps.review_count AS rev_count_app, 
	play_store_apps.review_count AS rev_count_play, 
	app_store_apps.rating AS rating_app, 
	play_store_apps.rating AS rating_play, 
	app_store_apps.content_rating AS content_rating_app,
	play_store_apps.content_rating AS content_rating_play, 
	app_store_apps.primary_genre AS primary_genre_app,
	play_store_apps.category AS primary_genre_play, 
	play_store_apps.genres AS genres_play,
	play_store_apps.install_count AS install_count_play 
FROM app_store_apps FULL JOIN play_store_apps
USING (name);
--WHERE app_store_apps.name IS NOT NULL AND play_store_apps.name IS NOT NULL;  --Running with this option returns 553 rows, including ONLY names in BOTH datasets.


