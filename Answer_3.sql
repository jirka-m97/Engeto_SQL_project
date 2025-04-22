-- Otázka 3: Která kategorie potravin zdražuje nejpomaleji 
-- (je u ní nejnižší percentuální meziroční nárůst)?

WITH avg_food_year_price AS (
	SELECT 
		year,
		food_name,
		food_amount, 
		food_unit,
		avg(avg_food_price_kc) AS avg_food_price_kc
	FROM t_jiri_mach_project_sql_primary_final
	GROUP BY 
		year,
		food_name, 
		food_amount, 
		food_unit
), food_price_growth AS (
	SELECT 
		*,
		LAG(avg_food_price_kc) OVER (
			PARTITION BY food_name
			ORDER BY food_name, year
		) AS previous_food_price,
		ROUND(
			100.0 * (avg_food_price_kc - LAG(avg_food_price_kc) OVER (
	            PARTITION BY food_name
	            ORDER BY food_name, year
	        )) / NULLIF(LAG(avg_food_price_kc) OVER (
	            PARTITION BY food_name
	            ORDER BY food_name, year
	        ), 0), 2) 
		AS food_price_growth_percent 
	FROM avg_food_year_price
	ORDER BY 
		food_name, 
		YEAR
)


-- Základní statistická analýza datových sat - pouze pro představu na jaké potraviny se zaměřit
SELECT 
	food_name,
	round(min(food_price_growth_percent), 1) AS min_food_price, 
	round(max(food_price_growth_percent), 1) AS max_food_price,
	round(avg(food_price_growth_percent), 1) AS avg_food_price,
	round(STDDEV_SAMP(food_price_growth_percent),1) AS stddev_price
FROM food_price_growth
GROUP BY
	food_name
ORDER BY min_food_price
;
	

