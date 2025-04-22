-- Otázka 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a 
-- poslední srovnatelné období v dostupných datech cen a mezd?

SELECT 
	year,
	food_name,
	avg(avg_food_price_kc) AS avg_food_price_kc,
	food_amount, 
	food_unit
FROM t_jiri_mach_project_sql_primary_final
GROUP BY 
	year,
	food_name, 
	food_amount, 
	food_unit
ORDER BY 
	food_name,
	year
;