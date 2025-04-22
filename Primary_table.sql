CREATE TABLE IF NOT EXISTS t_jiri_mach_project_sql_primary_final AS
WITH wages_per_quarter AS (
	SELECT 
		cp.industry_branch_code,
		cpib.name AS industry_name,
		cp.payroll_year AS w_year,
		cp.payroll_quarter,
		cp.value AS wage
	FROM czechia_payroll cp
	LEFT JOIN czechia_payroll_industry_branch cpib
		ON cp.industry_branch_code = cpib.code
	LEFT JOIN czechia_payroll_value_type cpvt 
		ON cp.value_type_code = cpvt.code
	WHERE 	
		cp.value_type_code = 5958 -- 5958 ~ mzda;
		AND cp.calculation_code = 100 -- 100 ~ fyzická mzda
		AND cp.industry_branch_code IS NOT NULL
		AND cp.payroll_year BETWEEN 2006 AND 2018
)

SELECT 
  	EXTRACT(YEAR FROM cp.date_from)::INT AS year,
  	CEIL(EXTRACT(MONTH FROM cp.date_from)::INT / 3.0)::INT AS quarter,
  	ROUND(AVG(cp.value)::NUMERIC, 1) AS avg_food_price_Kc,
  	cpc.name AS food_name,
  	cpc.price_value AS food_amount,
  	cpc.price_unit AS food_unit,
	wpq.industry_branch_code,
	wpq.industry_name,
	wpq.w_year,
	wpq.payroll_quarter,
	wpq.wage
FROM czechia_price cp
JOIN czechia_price_category AS cpc 
  	ON cpc.code = cp.category_code
JOIN wages_per_quarter AS wpq
	ON wpq.w_year = EXTRACT(YEAR FROM cp.date_from)::INT
	AND wpq.payroll_quarter = CEIL(EXTRACT(MONTH FROM cp.date_from)::INT / 3.0)::INT
GROUP BY 
  	year,
  	quarter,
  	food_name,
  	food_amount,
  	food_unit,
	wpq.industry_branch_code,
	wpq.industry_name,
	wpq.w_year,
	wpq.payroll_quarter,
	wpq.wage
ORDER BY 
  year,
  food_name,
  quarter;
  