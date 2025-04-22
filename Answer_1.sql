-- Otázka 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

-- Analýza mezikvartálových trendů v rámci bilančního období (2006-2018) pro všechna odvětví
SELECT 
	industry_branch_code,
	industry_name,
	w_year,
	payroll_quarter,
	wage,
	LAG(wage) OVER (
		PARTITION BY industry_branch_code
		ORDER BY w_year, payroll_quarter
		) AS previous_quarter_wage,
    ROUND(
        100.0 * (wage - LAG(wage) OVER (
            PARTITION BY industry_branch_code 
            ORDER BY w_year, payroll_quarter
        )) / NULLIF(LAG(wage) OVER (
            PARTITION BY industry_branch_code 
            ORDER BY w_year, payroll_quarter
        ), 0), 2) 
	AS wage_quartile_growth_percent 
FROM t_jiri_mach_project_sql_primary_final
GROUP BY 
	industry_branch_code,
	industry_name,
	w_year,
	payroll_quarter,
	wage
ORDER BY 
	industry_branch_code,
	w_year,
	payroll_quarter;

	
-- Analýza meziročních trendů v rámci bilančního období (2006-2018) pro všechna odvětví
-- pomocná dočasná tabulka (důvod - potřeboval jsem definovat tento sloupec 'ROUND(AVG(wage)) AS avg_yearly_wage')
WITH yearly_avg AS (
    SELECT 
        industry_branch_code,
        industry_name,
        w_year,
        ROUND(AVG(wage)) AS avg_yearly_wage
    FROM t_jiri_mach_project_sql_primary_final
    GROUP BY 
        industry_branch_code,
        industry_name,
        w_year
)

SELECT 
    industry_branch_code,
    industry_name,
    w_year,
    avg_yearly_wage,
    LAG(avg_yearly_wage) OVER (
        PARTITION BY industry_branch_code 
        ORDER BY w_year
    ) AS previous_year_wage,
    ROUND(
        100.0 * (avg_yearly_wage - LAG(avg_yearly_wage) OVER (
            PARTITION BY industry_branch_code 
            ORDER BY w_year
        )) / NULLIF(LAG(avg_yearly_wage) OVER (
            PARTITION BY industry_branch_code 
            ORDER BY w_year
        ), 0), 2
    ) AS wage_year_growth_percent
FROM yearly_avg
ORDER BY 
    industry_branch_code,
    w_year;




























SELECT 
	industry_branch_code,
	industry_name,
	w_year,
	wage,
	LAG(wage) OVER (
		PARTITION BY industry_branch_code
		ORDER BY w_year
		) AS previous_year_wage,
	CASE 
        WHEN LAG(wage) OVER (
		PARTITION BY industry_branch_code
		ORDER BY w_year
        ) < wage THEN 'UP'
        ELSE 'DOWN'
    END AS wages_year_trend
FROM t_jiri_mach_project_SQL_primary_final
GROUP BY 
	industry_branch_code,
	industry_name,
	w_year,
	wage
ORDER BY 
	industry_branch_code,
	w_year;


SELECT 
	*
FROM t_jiri_mach_project_SQL_primary_final
ORDER BY 
	industry_branch_code,
	w_year;