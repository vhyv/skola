USE [4IT436];
GO

/*
2)	Porovnejte pr�m�rn� mzdy u jednotliv�ch pobo�ek a uka�te jejich v�voj v �ase, v r�mci jednotliv�ch funkc�,
 v r�mci pracovn�k� pracuj�c�ch v t�chto funkc�ch. Krom� toho tak� zpracuje ukazatele % meziro�n�ho rozd�lu v t�chto mzd�ch.
 */
 
-- prumer na kazdeho zamestnance podle jednotlivych mesicu/vyplat a rozdil oproti predeslemu roku
WITH t AS (
 SELECT m.datum
		 ,LEFT(Convert(DATE, m.datum, 112), 7) AS mesic
		, z.fullname AS zamestnanec
		, CAST(avg(abs(m.castka)) OVER(PARTITION BY z.id_zamestnanec ORDER BY m.datum ASC) AS numeric(20,2)) AS prumer_na_zamestnance
 FROM xhyvv00_t_vydaje_mzdy_skutecnost AS m
	INNER JOIN xhyvv00_t_zamestnanci AS z
	ON m.id_zamestnanec = z.id_zamestnanec
		INNER JOIN xhyvv00_t_pobocky AS p
		ON z.id_pobocka = p.id_pobocka
			INNER JOIN xhyvv00_t_funkce AS f
			ON z.id_funkce = f.id_funkce
)
SELECT mesic, zamestnanec, prumer_na_zamestnance,
 CONCAT(CAST(((prumer_na_zamestnance/LAG(prumer_na_zamestnance, 1) OVER (PARTITION BY zamestnanec ORDER BY mesic ASC)) -1)*100 AS numeric(5,2)), '%') AS narust_pokles
FROM t

-- prumer na kazdou funkci podle jednotlivych mesicu/vyplat a rozdil oproti predeslemu roku
WITH f AS (
 SELECT m.datum
		 ,LEFT(Convert(DATE, m.datum, 112), 7) AS mesic
		, f.nazev_funkce
		, CAST(avg(abs(m.castka)) OVER(PARTITION BY f.id_funkce ORDER BY m.datum ASC) AS numeric(20,2)) AS prumer_na_funkci
 FROM xhyvv00_t_vydaje_mzdy_skutecnost AS m
	INNER JOIN xhyvv00_t_zamestnanci AS z
	ON m.id_zamestnanec = z.id_zamestnanec
		INNER JOIN xhyvv00_t_pobocky AS p
		ON z.id_pobocka = p.id_pobocka
			INNER JOIN xhyvv00_t_funkce AS f
			ON z.id_funkce = f.id_funkce
)
SELECT mesic, nazev_funkce, prumer_na_funkci,
 CONCAT(CAST(((prumer_na_funkci/LAG(prumer_na_funkci, 1) OVER (PARTITION BY nazev_funkce ORDER BY mesic ASC)) -1)*100 AS numeric(5,2)), '%') AS narust_pokles
FROM f


/*
 SELECT DISTINCT m.datum, abs(m.castka) AS castka, m.id_zamestnanec, z.fullname, z.id_pobocka, p.zkratka, z.id_funkce, f.nazev_funkce
	,CAST(AVG(abs(castka)) OVER(PARTITION BY m.id_zamestnanec ORDER BY datum ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS numeric(20,2)) AS prumerna_mzda_na_zamestnance
	,CAST(AVG(abs(castka)) OVER(PARTITION BY z.id_pobocka	ORDER BY datum ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS numeric(20,2)) AS prumerna_mzda_na_pobocku
	,CAST(AVG(abs(castka)) OVER(PARTITION BY z.id_funkce ORDER BY datum ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS numeric(20,2)) AS prumerna_mzda_na_funkci
	,CAST(AVG(abs(castka)) OVER(PARTITION BY z.id_pobocka, z.id_funkce ORDER BY datum ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS numeric(20,2)) AS prumerna_mzda_na_funkci_na_pobocce
FROM xhyvv00_t_vydaje_mzdy_skutecnost AS m
	INNER JOIN xhyvv00_t_zamestnanci AS z
	ON m.id_zamestnanec = z.id_zamestnanec
		INNER JOIN xhyvv00_t_pobocky AS p
		ON z.id_pobocka = p.id_pobocka
			INNER JOIN xhyvv00_t_funkce AS f
			ON z.id_funkce = f.id_funkce
;
*/

/*
-- prumer na kazdou pobocku podle jednotlivych mesicu/vyplat a rozdil oproti predeslemu roku
--TOHLE NENI DOBRE, CHYBI AGREGACE ZA JEDNOTLIVE MESICE...
WITH p AS (
  SELECT m.datum
		 ,LEFT(Convert(DATE, m.datum, 112), 7) AS mesic
		, p.nazev AS pobocka
		, CAST(avg(abs(m.castka)) OVER(PARTITION BY  month(m.datum),z.id_pobocka ORDER BY m.datum ASC) AS numeric(20,2)) AS prumer_na_pobocku
 FROM xhyvv00_t_vydaje_mzdy_skutecnost AS m
	INNER JOIN xhyvv00_t_zamestnanci AS z
	ON m.id_zamestnanec = z.id_zamestnanec
		INNER JOIN xhyvv00_t_pobocky AS p
		ON z.id_pobocka = p.id_pobocka
			INNER JOIN xhyvv00_t_funkce AS f
			ON z.id_funkce = f.id_funkce
)
SELECT mesic, pobocka, prumer_na_pobocku,
 CONCAT(CAST(((prumer_na_pobocku/LAG(prumer_na_pobocku, 1) OVER (PARTITION BY pobocka ORDER BY mesic ASC)) -1)*100 AS numeric(5,2)), '%') AS narust_pokles
FROM p
*/