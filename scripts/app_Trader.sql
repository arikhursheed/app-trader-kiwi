SELECT *,profit_before_marketing_cost -  both_marketing_months*1000 AS both_profit
FROM ( SELECT *,
	  (app_lifespan*5000 - app_cost + play_lifespan*5000 - play_cost) AS profit_before_marketing_cost,
        --takes the highest lifespan then use it later to miltiply by 1000  as marketing cost
       (CASE WHEN app_lifespan>play_lifespan THEN app_lifespan
		ELSE play_lifespan END)
	    AS both_marketing_months
--from Diego
      FROM ( SELECT  *,
--one time cost from buying the app. this depends on NULL values when app is only on one store
	       (CASE
		 --WHEN app_price IS NULL THEN 0
		   WHEN app_price<=1 THEN 10000
		   ELSE app_price*10000 END)
	       AS app_cost,
	
	      (CASE
		--WHEN play_price IS NULL THEN 0
		  WHEN play_price<=1 THEN 10000
		  ELSE play_price*10000 end)
	      AS play_cost,
	
--Turn rating to number of months, for 12 represents 1 year and so on.
	     CEIL(1+app_rating*2)*12 as app_lifespan,
	     CEIL(1+play_rating*2)*12 as play_lifespan
	    --CEIL(1+app_rating*2)*12*5000 AS app_revenue,
	    --CEIL(1+play_rating*2)*12*5000 AS play_revenue 
--from Diego	
--INNER JOIN both tables as subquery
        FROM (SELECT name,
		     app_store_apps.price as app_price, play_store_apps.price::money::numeric as play_price,
		     --Prices as money. for play_price, need to cast text to money then to numeric.
		     ROUND((COALESCE(app_store_apps.rating,0)/.5),0)*.5 as app_rating,
	         ROUND(COALESCE(play_store_apps.rating,0)/.5,0)*.5 as play_rating
		     --ratings, removing nulls and rounding to nearest .5
	         FROM app_store_apps INNER JOIN play_store_apps
	         Using (name)
             order by play_rating desc) as sub_query) AS total_profit) final_profit
--WHERE app_price IS NOT NULL AND play_price IS NOT NULL