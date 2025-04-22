-- Otázka 5: Má výška HDP vliv na změny ve mzdách a cenách potravin? 
-- Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to 
-- na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

-- Průměrné mzdy, ceny potravin a hdp (eng ~ gdp) za rok - meziroční období
WITH wage_avg AS (
    SELECT 
        year,
        ROUND(AVG(wage)) AS avg_wage
    FROM t_jiri_mach_project_sql_primary_final
    GROUP BY
    	year
),
wage_growth AS (
    SELECT 
        year,
        avg_wage,
        LAG(avg_wage) OVER (ORDER BY year) AS previous_wage,
        ROUND(
            100.0 * (avg_wage - LAG(avg_wage) OVER (ORDER BY year)) 
            / NULLIF(LAG(avg_wage) OVER (ORDER BY year), 0), 2
        ) AS wage_growth_percent
    FROM wage_avg
),
food_avg AS (
    SELECT 
        year,
        ROUND(AVG(avg_food_price_kc), 2) AS avg_food_price
    FROM t_jiri_mach_project_sql_primary_final
    GROUP BY 
    	year
),
food_growth AS (
    SELECT 
        year,
        avg_food_price,
        LAG(avg_food_price) OVER (ORDER BY year) AS previous_food_price,
        ROUND(
            100.0 * (avg_food_price - LAG(avg_food_price) OVER (ORDER BY year)) 
            / NULLIF(LAG(avg_food_price) OVER (ORDER BY year), 0), 2
        ) AS food_price_growth_percent
    FROM food_avg
),
gdp_growth AS (
	SELECT
		year,
		gdp,
		LAG(gdp) OVER (ORDER BY year) AS previous_gdp,
        ROUND(
            100.0 * (gdp::NUMERIC - LAG(gdp) OVER (ORDER BY year)::NUMERIC) 
            / NULLIF(LAG(gdp) OVER (ORDER BY year)::NUMERIC, 0), 2
        ) AS gdp_growth_percent
	FROM t_jiri_mach_project_sql_secondary_final
)
-- Výsledné porovnání procentuálních nárůstů mezd a cen potravin v jednotlivých letech (2006-2018)
SELECT 
    f.year,
    f.food_price_growth_percent,
    w.wage_growth_percent,
	h.gdp_growth_percent
FROM food_growth f
JOIN wage_growth w 
	ON f.year = w.year
JOIN gdp_growth h 
	ON f.year = h.year
ORDER BY 
	f.year;