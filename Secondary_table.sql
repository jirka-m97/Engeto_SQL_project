-- Tvorba sekundární tabulky, pro zodpovězení 5. otázky je třeba pouze tabulka economies
CREATE TABLE IF NOT EXISTS t_jiri_mach_project_sql_secondary_final AS
	SELECT 
		year,
		round(gdp) AS gdp
	FROM 
		economies e
	WHERE 
		country ILIKE 'cz%'
		AND year BETWEEN 2006 AND 2018
	ORDER BY year
;

