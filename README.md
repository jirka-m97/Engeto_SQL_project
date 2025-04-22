## 1.	Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
### a.	Stručný popis postupu 
Pro zopovězení této otázky byly zapotření především tabulky: *czechia_payroll*, *czechia_payroll_industry_branch* a *czechia_payroll_value_type*. Všechny tabulky byly součástí jedné souhrnné tabulky *t_jiri_mach_project_sql_primary_final*. Řazení bylo provedeno primárně dle *cp.industry_branch_code*, sekundárně dle *cp.payroll_year* a terciálně dle *cp.payroll_quarter*. Změna hodnoty mezd byla vyhodnocována z hlediska kvartálů daného roku. Ze sloupce *cp.value_type_code* jsem vybral pouze hodnoty 5958, které odpovídaly průměrné hrubé mzdě za zaměstnance. Dále jsem ze sloupce *cp.calculation_code* vybral pouze 100, které odpovídaly fyzické mzdě (stejné trendy nastávaly i v případě přepočítaných mezd (kód - 200), též bylo otestováno). Odstranil jsem řádky, ve kterých *cp.industry_branch_code* byly hodnoty NULL. Přidal jsem dva nové, pomocné sloupce. První jsem vytvořil za použití window funkce LAG() pro sloupec cp.value. Druhý sloupec jsem vytvořil pomocí výrazu CASE, ve kterém jsem porovnával aktuální mzdu a mzdu z minulého kvartálu, abych zjistil trend. Bilanční studované období bylo zkráceno z původního, 2000 do 2021, na období **2006 až 2018** z důvodu sjednocení bilančhího období pro ceny potravin a ostatní ukazatele.
### b.	Odpověď na otázku
Pro jednotlivá průmyslová odvětví byla situace specifická a individuální. Proto byly popsány pouze některé ilustrativní trendy.
#### Popis mezikvartilových trendů v průběhu bilančního období (2006 do 2018) pouze pro ilustrativní odvětví:
Zpracovaná data poukázala na rostoucí mezikvartálové trendy v případě A ( Zemědělství, lesnictví, rybářství) a F (Stavebnictví), přičemž mezi 4. kvartály předešlého roku a 1. kvartály následujícího roku byl zaznamenám pokles. V případě B – Těžba a dobývání byla zaznamen pravidelný trend: mezi 1. a 2. kvartály byl zaznamenán nárůst, mezi 2. a 3. pokles a mezi 3. a 4. opět nárůst. Stejný trend byl pozorován i v případě E - Zásobování vodou; činnosti související s odpady a sanacemi. Vzduchu převažoval spíše klesající trend průměrných hodnot mezd. V případě G (Velkoobchod a maloobchod; opravy a údržba motorových vozidel); I (Ubytování, stravování a pohostinství) či H (Doprava a skladování) převažovaly spíše rostoucí mezikvartálové trendy. 

#### Popis meziročních trendů pouze v některých odvětví:
Byl vytvořen dotaz, který z “mezikvartálové” varianty vytvořil “meziroční” variant. Bylo zapotřebí nejprve vytvořit dočasnou tabulku WITH, která obsahuje sloupec s průměrnými hodnotami mezd v daném roce (průměr z průměrů jednotlivých kvartálů daného roku). 
Na základně výsledných meziročních tredů bylo možné konstatovat, že v případě A ( Zemědělství, lesnictví, rybářství) byl pozorován rostoucí trend v hodnotách mezd (kromě období mezi 2008-2009). Rostoucí trend v  celém bilančním období (2008-2016) byl pozorován v případech: C (Zpracovatelský průmysl), H (Doprava a skladování), Q (Zdravotní a sociální péče), S (Ostatní činnosti). Obecně lze říci, že ve všech odvětvích převažovaly růsty mezd oproti jejich poklesům. 

## 2.	Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

### a.	Stručný popis postupu
Předpokladem pro zodpovězení této otázky bylo použití tabulek czechia_price a czechia_price_category (součást primární tabulky). Z dostupných informací bylo možné stanovit trend ve změně (průměrné) ceny za danou potravinu v rámci kvartálů či let. Cena za potraviny byla vždy vztažena na měrnou jednotku, např. vejce slepičí čerstvá – cena za 10 ks, pomeranče – cena za 1 kg či mléko polotučné pasterované – cena za 1 litr. Bilační období bylo od 2006 do 2018. Počáteční a koncový rok bilančního období byly zjištěny na základě vzestupného a setupného seřazení (ORDER BY date_from ASC/DESC) tabulky v rámci studia datových podkladů určených pro vypracování tohoto projektu. 
### b.	Odpověď na otázku
Dostupné informace **neumožnily** odpovědět na tuto otázku. Bylo by třeba doplnit zdrojové tabulky o další nezbytné údaje.

## 3.	Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

### a.	Stručný popis postupu 
Předpokladem pro zodpovězení této otázky bylo použití tabulek *czechia_price* a *czechia_price_category* (součást primární tabulky). Nejprve bylo třeba zprůměrovat průměrné ceny potravin z jednotlivých kvartálů daného roku. Dále byl pomocí window funkce LAG() vytvořen pomocný sloupec určený k výpočtu nárůstu cen mezi jednotlivými roky pro danou potravinu. Tato část dotazu je součástí dvou dočasných tabulek WITH. Nakonec byla provedena základní statistika jednotlivých datových sad reprezentujících jednotlivé potraviny. Pro každou byly spočítány: minimální nárůst cen (~maximální pokles ceny), maximální nárůst ceny, průměrná hodnota nárůstu ceny a směrodatná odchylka nárůstu ceny. Tato tabulka hodnot byla seřazena dle minimálního nárůstu ceny sestupně. Tím se ve vrchní části tabulky koncentrovaly potraviny, u kterých byl zaznamenám nejnižší nárůst ceny v rámci bilančního období. 
### b.	Odpověď na otázku
Nejnižší nárůst ceny byl zaznamenán u **rajského jablka červeného kulatého**. Toto tvrzení je podloženo i poměrně nízkým průměrným meziročním nárůstem ceny. 


## 4.	Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
### a.	Stručný popis postupu 
Pro tento případ bylo potřeba spočítat průměrné ceny potravin a průměrné mzdy v jednotlivých letech. Opět bylo nutné použít fukci LAG() a vytvořit pomocné sloupce potřebné pro zjištění meziročního nárůstu/poklesu. Tato část dotazu byla zabalena do dočasných tabulek za použití klauzule (CTE) WITH. Konkrétně se jednalo o tabulky wage_avg, wage_growth, food_avg a food_growth. Ty byly následně použity ve výsledném selektu pro určení rozdílu mezi nárůsty cen potravin a mezd pro jednotlivé roky. 
### b.	Odpověď na otázku
V žádném roce **nebyl zaznamenám 10% nárůst** (průměrných) cen potravin vzhledem k nárůstu (průměrných) mezd. V roce 2013 byl pozorován nejvyšší procentuální rozdíl (7,08 %) mezi nárůstem cen potravin a mzdami (u mezd nepatrný meziroční pokles). V roce 2009 byl pozorován nejvyšší (absolutní) rozdíl (9,61 %) mezi cenami potravin a mzdami.  

## 5.	Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

### a.	Stručný popis postupu
Pro zodpovězení této otázky bylo třeba vytvořit druhou pomocnou tabulku *t_jiri_mach_project_sql_secondary_final*. Byly selektovány pouze sloupce year a gdp z tabulky *economies* pro Českou republiku v letech 2006-2018 Druhá dodatečná tabulka *countries* nebyla použita, jelikož neobsahovala relevantní informace pro zodpovězení této otázky. Dotaz použitý k zodpovězení 4. otázky byl použit i zde. Byl rozšířen o informace z 2. pomocné tabulky. Opět byla použita klauzule WITH a v závarečné části dotazu byl proveden JOIN dočasných tabulek a SELECT odpovídajících sloupců.
### b.	Odpověď na otázku
Procentuální nárůst HDP (5,57) mezi roky 2006 a 2007 byl spojen i s nárůstem průměrných cen potravin a mezd. Pokles HDP (-4,66 %) mezi lety 2008 a 2009 více koreloval s poklesem cen potravin oproti mzdám. Nárůst HDP mezi lety 2009-2010 více koreloval s nárůstem cen potravin oproti mzdám. Mezi léty 2016-2017 byla pozorována silná korelace mezi nárůstem HDP a nárůstem cen potravin společně s nárůstem mezd.
## Poznámky:
### 1. Přehození jednotek ve sloupci *unit_code* (z tabulky *czechia_payroll*) 
- K údaji Průměrný počet zaměstnaných osob je přiřazena jednotka, která odpovídá Kč. V případě Průměrná hrubá mzda na zaměstnance je hodnota v tis. osob (tis. os.). Jedná se tedy o prohození jednotek. Pro zodpovězení otázek to ovšem není klíčové. 
### 2. Rozdílné bilanční období u *payroll_year* a *czechia_price* – u druhé otázky nutno první období zkratit, a tedy sjednotit se druhým obdobím.
- Rozmezí let v *payroll_year* je 2000-2021!
- Rozmezí let v *czechia_price* je 2006-2018!
### 3. V případě *czechia_price* a czechia_price_category pozor na to, že kapr živý byl prodáván pouze ve 4. kvartálu (Vánoce).
### 4. Číselníky sdílených informací o ČR (*czechia_region* a *czechia_district*) nebyly použity, jelikož neobsahovaly relevantní informace pro zodpovězení otázek definovaných v zadání projektu.
### 5. HDP odpovídá anglickému názvu GDP.
### 6. Dodatečná tabulka *countries* nebyla použita, jelikož neobsahovala relevantní informace.

