USE skola;
GO

--Porovnejte prùmìrné mzdy u jednotlivých poboèek (agregat)
SELECT p.nazev AS pobocka, CAST(AVG(ABS(pv.castka)) AS numeric(10,2)) AS prumernamzda
FROM xhyvv00_t_pobocky AS p
	INNER JOIN xhyvv00_f_PV AS pv
	ON p.id_pobocka = pv.id_pobocka
WHERE pv.id_druh_transakce = 2
	AND pv.id_plan_skutecnost = 2
	AND pv.id_typ_transakce = 2
GROUP BY p.nazev
ORDER BY pobocka ASC
;

-- ukazte jejich vyvoj v case (mesicne) a mezirocni rozdil
WITH t AS(
SELECT p.nazev AS pobocka, d.Year AS rok, d.Month AS mesic, CAST(AVG(ABS(pv.castka)) AS numeric(10,2)) AS prumernamzda
FROM xhyvv00_t_pobocky AS p
	INNER JOIN xhyvv00_f_PV AS pv
	ON p.id_pobocka = pv.id_pobocka
		INNER JOIN DateDimension AS d
		ON pv.datum = d.Date
WHERE pv.id_druh_transakce = 2
	AND pv.id_plan_skutecnost = 2
	AND pv.id_typ_transakce = 2
GROUP BY p.nazev, d.year, d.month
), tt AS (
SELECT pobocka, rok, mesic, prumernamzda, LAG(prumernamzda, 1) OVER(PARTITION BY pobocka, mesic ORDER BY rok) AS predrokem
FROM t)

SELECT pobocka, rok, mesic, prumernamzda
, CONCAT(CAST(((prumernamzda/predrokem)-1)*100.00 AS numeric(10,2)), CASE WHEN predrokem IS NULL then '' ELSE ' %' END) AS rozdil
FROM tt
ORDER BY rok, mesic
;
-- ukazte jejich vyvoj v case (rocne) a mezirocni rozdil
WITH t AS(
SELECT p.nazev AS pobocka, d.Year AS rok, CAST(AVG(ABS(pv.castka)) AS numeric(10,2)) AS prumernamzda
FROM xhyvv00_t_pobocky AS p
	INNER JOIN xhyvv00_f_PV AS pv
	ON p.id_pobocka = pv.id_pobocka
		INNER JOIN DateDimension AS d
		ON pv.datum = d.Date
WHERE pv.id_druh_transakce = 2
	AND pv.id_plan_skutecnost = 2
	AND pv.id_typ_transakce = 2
GROUP BY p.nazev, d.year
), tt AS (
SELECT pobocka, rok, prumernamzda, LAG(prumernamzda, 1) OVER(PARTITION BY pobocka ORDER BY rok) AS predrokem
FROM t)

SELECT pobocka, rok, prumernamzda
, CONCAT(CAST(((prumernamzda/predrokem)-1)*100.00 AS numeric(10,2)), CASE WHEN predrokem IS NULL then '' ELSE ' %' END) AS rozdil
FROM tt
ORDER BY rok
;

--v rámci jednotlivých funkcí (agregat)
SELECT f.nazev_funkce AS funkce, p.nazev AS pobocka, CAST(AVG(ABS(pv.castka)) AS numeric(10,2)) AS prumernamzda
FROM xhyvv00_t_pobocky AS p
	INNER JOIN xhyvv00_f_PV AS pv
	ON p.id_pobocka = pv.id_pobocka
		INNER JOIN xhyvv00_t_zamestnanci AS z
		ON pv.id_pobocka = z.id_pobocka
		AND pv.id_zamestnanec = z.id_zamestnanec
			INNER JOIN xhyvv00_t_funkce AS f
			ON z.id_funkce = f.id_funkce
WHERE pv.id_druh_transakce = 2
	AND pv.id_plan_skutecnost = 2
	AND pv.id_typ_transakce = 2
GROUP BY p.nazev, f.nazev_funkce
ORDER BY funkce, pobocka
;
--v rámci jednotlivých funkcí (mesicne)
WITH t AS(
SELECT f.nazev_funkce AS funkce, p.nazev AS pobocka, d.year AS rok, d.month AS mesic, CAST(AVG(ABS(pv.castka)) AS numeric(10,2)) AS prumernamzda
FROM xhyvv00_t_pobocky AS p
	INNER JOIN xhyvv00_f_PV AS pv
	ON p.id_pobocka = pv.id_pobocka
		INNER JOIN xhyvv00_t_zamestnanci AS z
		ON pv.id_pobocka = z.id_pobocka
		AND pv.id_zamestnanec = z.id_zamestnanec
			INNER JOIN xhyvv00_t_funkce AS f
			ON z.id_funkce = f.id_funkce
				INNER JOIN DateDimension AS d
				ON pv.datum = d.date
WHERE pv.id_druh_transakce = 2
	AND pv.id_plan_skutecnost = 2
	AND pv.id_typ_transakce = 2
GROUP BY p.nazev, f.nazev_funkce, d.year, d.month
), tt AS(
SELECT funkce, pobocka, rok, mesic, prumernamzda, LAG(prumernamzda, 1) OVER(PARTITION BY funkce, pobocka, mesic ORDER BY rok) AS predrokem
FROM t
)
SELECT funkce, pobocka, rok, mesic, prumernamzda
, CONCAT(CAST(((prumernamzda/predrokem)-1)*100.00 AS numeric(10,2)), CASE WHEN predrokem IS NULL then '' ELSE ' %' END) AS rozdil
FROM tt
ORDER BY rok, mesic
;
--v rámci jednotlivých funkcí (rocne)
WITH t AS(
SELECT f.nazev_funkce AS funkce, p.nazev AS pobocka, d.year AS rok,  CAST(AVG(ABS(pv.castka)) AS numeric(10,2)) AS prumernamzda
FROM xhyvv00_t_pobocky AS p
	INNER JOIN xhyvv00_f_PV AS pv
	ON p.id_pobocka = pv.id_pobocka
		INNER JOIN xhyvv00_t_zamestnanci AS z
		ON pv.id_pobocka = z.id_pobocka
		AND pv.id_zamestnanec = z.id_zamestnanec
			INNER JOIN xhyvv00_t_funkce AS f
			ON z.id_funkce = f.id_funkce
				INNER JOIN DateDimension AS d
				ON pv.datum = d.date
WHERE pv.id_druh_transakce = 2
	AND pv.id_plan_skutecnost = 2
	AND pv.id_typ_transakce = 2
GROUP BY p.nazev, f.nazev_funkce, d.year

), tt AS(
SELECT funkce, pobocka, rok, prumernamzda, LAG(prumernamzda, 1) OVER(PARTITION BY funkce, pobocka ORDER BY rok) AS predrokem
FROM t
)
SELECT funkce, pobocka, rok, prumernamzda
, CONCAT(CAST(((prumernamzda/predrokem)-1)*100.00 AS numeric(10,2)), CASE WHEN predrokem IS NULL then '' ELSE ' %' END) AS rozdil
FROM tt
ORDER BY rok
;

--v rámci pracovníkù pracujících v tìchto funkcích (agregat)
SELECT f.nazev_funkce AS funkce, z.fullname, p.nazev AS pobocka,   CAST(AVG(ABS(pv.castka)) AS numeric(10,2)) AS prumernamzda
FROM xhyvv00_t_pobocky AS p
	INNER JOIN xhyvv00_f_PV AS pv
	ON p.id_pobocka = pv.id_pobocka
		INNER JOIN xhyvv00_t_zamestnanci AS z
		ON pv.id_pobocka = z.id_pobocka
		AND pv.id_zamestnanec = z.id_zamestnanec
			INNER JOIN xhyvv00_t_funkce AS f
			ON z.id_funkce = f.id_funkce
WHERE pv.id_druh_transakce = 2
	AND pv.id_plan_skutecnost = 2
	AND pv.id_typ_transakce = 2
GROUP BY p.nazev, f.nazev_funkce, z.fullname
ORDER BY funkce, pobocka
;

--v rámci pracovníkù pracujících v tìchto funkcích (mesic - eh?)
WITH t AS(
SELECT  z.fullname, f.nazev_funkce AS funkce, p.nazev AS pobocka, d.year AS rok, d.month AS mesic,  CAST(AVG(ABS(pv.castka)) AS numeric(10,2)) AS prumernamzda
FROM xhyvv00_t_pobocky AS p
	INNER JOIN xhyvv00_f_PV AS pv
	ON p.id_pobocka = pv.id_pobocka
		INNER JOIN xhyvv00_t_zamestnanci AS z
		ON pv.id_pobocka = z.id_pobocka
		AND pv.id_zamestnanec = z.id_zamestnanec
			INNER JOIN xhyvv00_t_funkce AS f
			ON z.id_funkce = f.id_funkce
				INNER JOIN DateDimension AS d
				ON pv.datum = d.Date
WHERE pv.id_druh_transakce = 2
	AND pv.id_plan_skutecnost = 2
	AND pv.id_typ_transakce = 2
GROUP BY f.nazev_funkce, p.nazev, z.fullname, d.year, d.month
), tt AS (
SELECT fullname, funkce, pobocka, rok, mesic, prumernamzda
,LAG(prumernamzda, 1) OVER(PARTITION BY pobocka, funkce, fullname, mesic ORDER BY rok) AS predrokem
FROM t
)
SELECT fullname, funkce, pobocka, rok, mesic, prumernamzda
,CONCAT(CAST(((prumernamzda/predrokem)-1)*100.00 AS numeric(10,2)), CASE WHEN predrokem IS NULL then '' ELSE ' %' END) AS rozdil
FROM tt
ORDER BY rok, mesic
;

--v rámci pracovníkù pracujících v tìchto funkcích (rok)
WITH t AS(
SELECT z.fullname, f.nazev_funkce AS funkce, p.nazev AS pobocka, d.year AS rok, CAST(AVG(ABS(pv.castka)) AS numeric(10,2)) AS prumernamzda
FROM xhyvv00_t_pobocky AS p
	INNER JOIN xhyvv00_f_PV AS pv
	ON p.id_pobocka = pv.id_pobocka
		INNER JOIN xhyvv00_t_zamestnanci AS z
		ON pv.id_pobocka = z.id_pobocka
		AND pv.id_zamestnanec = z.id_zamestnanec
			INNER JOIN xhyvv00_t_funkce AS f
			ON z.id_funkce = f.id_funkce
				INNER JOIN DateDimension AS d
				ON pv.datum = d.Date
WHERE pv.id_druh_transakce = 2
	AND pv.id_plan_skutecnost = 2
	AND pv.id_typ_transakce = 2
GROUP BY f.nazev_funkce, p.nazev, z.fullname, d.year
), tt AS (
SELECT fullname, funkce, pobocka, rok, prumernamzda
,LAG(prumernamzda, 1) OVER(PARTITION BY pobocka, funkce, fullname ORDER BY rok) AS predrokem
FROM t
)
SELECT fullname, funkce, pobocka, rok, prumernamzda
,CONCAT(CAST(((prumernamzda/predrokem)-1)*100.00 AS numeric(10,2)), CASE WHEN predrokem IS NULL then '' ELSE ' %' END) AS rozdil
FROM tt
ORDER BY rok
;