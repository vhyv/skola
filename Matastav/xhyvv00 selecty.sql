USE skola;
GO

SELECT z.nazev, z.psc, o.nazev AS okres
FROM xhyvv00_t_zakaznici AS z
	INNER JOIN xhyvv00_t_psc AS p
	ON z.psc = p.id_psc
		INNER JOIN xhyvv00_t_okres AS o
		ON p.id_okres = o.id_okres

SELECT * FROM xhyvv00_t_typ_transakce;
SELECT * FROM xhyvv00_t_druh_transakce;
SELECT * FROM xhyvv00_t_plan_skutecnost;

SELECT * FROM xhyvv00_f_PV
ORDER BY id_pol ASC;

SELECT * FROM xhyvv00_t_kraj;

SELECT * FROM xhyvv00_t_okres;

SELECT * FROM xhyvv00_t_psc

SELECT * FROM xhyvv00_t_psc_placeholder
WHERE psc = 14900

SELECT * FROM xhyvv00_t_typy_zdroju;

SELECT * FROM xhyvv00_t_funkce;

SELECT * FROM xhyvv00_t_kategorie_zakazniku;

SELECT * FROM xhyvv00_t_pobocky;

SELECT * FROM xhyvv00_t_zamestnanci;

SELECT * FROM xhyvv00_t_ukoly;

SELECT * FROM xhyvv00_t_zdroje;

SELECT * FROM xhyvv00_t_zakaznici;

SELECT * FROM xhyvv00_t_kontrakty;

SELECT * FROM xhyvv00_t_faktury_vydane;

SELECT * FROM xhyvv00_t_prijmy_plan;

SELECT * FROM xhyvv00_t_prijmy_skutecnost;

SELECT * FROM xhyvv00_t_vydaje_zdroje_plan;












TRUNCATE TABLE xhyvv00_t_kraj;