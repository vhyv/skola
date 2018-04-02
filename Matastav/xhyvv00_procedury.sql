USE skola;
GO

CREATE PROCEDURE update_t_psc
	@psc	int
	,@mesto	nvarchar(255)
AS
BEGIN
	UPDATE xhyvv00_t_psc
	SET mesto = @mesto
	WHERE id_psc = @psc
END
GO

CREATE PROCEDURE update_t_kontrakty_prijmy
	@idkontrakt	int
	,@skutecneprijmy	money
AS
BEGIN
	UPDATE xhyvv00_t_kontrakty
	SET cena_skut_celkem = @skutecneprijmy
	WHERE id_kontrakt = @idkontrakt
END
GO

CREATE PROCEDURE update_t_kontrakty_naklady
	@idkontrakt	int
	,@skutecnenaklady	money
AS
BEGIN
	UPDATE xhyvv00_t_kontrakty
	SET naklady_skut_celkem = @skutecnenaklady
	WHERE id_kontrakt = @idkontrakt
END
GO

CREATE PROCEDURE update_t_typy_zdroju
	@idtypzdroje	int
	,@typzdroje		nvarchar(255)
AS
BEGIN
	UPDATE xhyvv00_t_typy_zdroju
	SET typ_zdroje = @typzdroje
	WHERE id_typ_zdroje = @idtypzdroje
END
GO

CREATE PROCEDURE update_t_funkce
	@id_funkce	int
	,@nazevfunkce	nvarchar(100)
	,@osobniohodnoceni	numeric(20,2)
AS
BEGIN
	UPDATE xhyvv00_t_funkce
	SET nazev_funkce = @nazevfunkce
	,osobni_ohodnoceni = @osobniohodnoceni
	WHERE id_funkce = @id_funkce
END 
GO

CREATE PROCEDURE update_t_kategorie_zakazniku
	@katid	int
	,@katnazev	nvarchar(100)
	,@sleva	numeric(6,3)
AS
BEGIN
	UPDATE xhyvv00_t_kategorie_zakazniku
	SET	nazev_kategorie = @katnazev
	,sleva_prirazka = @sleva
	WHERE id_kategorie = @katid
END
GO

CREATE PROCEDURE update_t_pobocky
	@idpob	int
	,@zkratka			nvarchar(100)
	,@nazev				nvarchar(100)	
	,@ulice				nvarchar(100)	
	,@mesto				nvarchar(100)	
	,@psc				int	
	,@mesicni_pronajem	numeric(20,2)	
AS
BEGIN
	UPDATE xhyvv00_t_pobocky
	SET zkratka = @zkratka
	,nazev = @nazev
	,ulice = @ulice
	,psc = @psc
	,mesicni_pronajem = @mesicni_pronajem
	WHERE id_pobocka = @idpob
END
GO

CREATE PROCEDURE update_t_zamestnanci2
	@id_zamestnanec	int				
	,@prijmeni		nvarchar(100)	
	,@jmeno			nvarchar(100)	
	,@titul			nvarchar(15)	
	,@plat			numeric(20,2)	
	,@id_pobocka		int				
	,@id_funkce		int				
AS
BEGIN
	UPDATE xhyvv00_t_zamestnanci
	SET prijmeni = @prijmeni
	,jmeno = @jmeno
	,titul = @titul
	,plat = @plat
	,id_pobocka = @id_pobocka
	,id_funkce = @id_funkce
	WHERE id_zamestnanec = @id_zamestnanec
END
GO


CREATE PROCEDURE update_t_zamestnanci
	@id	int
	,@nadrizeny	int

AS
BEGIN
	UPDATE xhyvv00_t_zamestnanci
	SET id_nadrizeny = @nadrizeny
	WHERE id_zamestnanec = @id
END
GO



CREATE PROCEDURE update_t_ukoly
	@idukol	int
	,@idzam	int
	,@popisukolu	nvarchar(255)
AS
BEGIN
	UPDATE xhyvv00_t_ukoly
	SET id_zamestnanec = @idzam
	,popis_ukolu = @popisukolu
	WHERE id_ukol = @idukol
END
GO

CREATE PROCEDURE update_t_zdroje
	@idzdroj	int
	,@zkratka	nvarchar(50)
	,@nazev		nvarchar(255)
	,@popis		nvarchar(max)
	,@idtypzdroje	int
	,@naklady_den	numeric(20,2)
	,@zaklad_den	numeric(20,2)
AS
BEGIN
	UPDATE xhyvv00_t_zdroje
	SET zkratka = @zkratka
	,nazev = @nazev
	,popis = @popis
	,id_typ_zdroje = @idtypzdroje
	,naklady_den = @naklady_den
	,zaklad_den = @zaklad_den
	WHERE id_zdroj = @idzdroj
END
GO

CREATE PROCEDURE update_t_zakaznici
	@id_zakaznik					int				
	,@id_zamestnanec				int				
	,@id_kategorie				int				
	,@ico						nvarchar(50)	
	,@zkratka					nvarchar(20)	
	,@nazev						nvarchar(255)	
	,@ulice						nvarchar(255)	
	,@mesto						nvarchar(255)	
	,@psc						int	
	,@kredit					numeric(30, 2)	
AS
BEGIN
	UPDATE xhyvv00_t_zakaznici
	SET 
	id_zamestnanec = @id_zamestnanec			
	,id_kategorie = @id_kategorie						
	,ico = @ico						
	,zkratka = @zkratka					
	,nazev = @nazev							
	,ulice = @ulice						
	,mesto = @mesto						
	,psc = @psc							
	,kredit = @kredit
	WHERE id_zakaznik = @id_zakaznik
END
GO



CREATE PROCEDURE update_t_faktury_vydane
	@idfaktura	int
	,@idkontrakt	int
	,@idzakaznik	int
	,@cena_celkem	numeric(20,2)
	,@datumvystaveni	date
	,@datumsplatnosti	date
	,@datumzaplaceni	date

AS
BEGIN
	UPDATE xhyvv00_t_faktury_vydane
	SET id_kontrakt = @idkontrakt
	,id_zakaznik = @idzakaznik
	,cena_celkem = @cena_celkem
	,datum_vystaveni = @datumvystaveni
	,datum_splatnosti =@datumsplatnosti
	,datum_zaplaceni = @datumzaplaceni
	WHERE id_faktura = @idfaktura
END
GO

/*
CREATE PROCEDURE update_f_PV_prijmy_plan
	@idpol	int
	,@datum	date
	,@castka	numeric(20,2)
	,@druh		nvarchar(100)
	,@protistrana	nvarchar(255)
	,@ucet	nvarchar(255)
	,@poznamka	nvarchar(255)
	,@idkontrakt	int
	,@realizovano	nvarchar(50)
AS
BEGIN
	UPDATE xhyvv00_f_PV_prijmy_plan
	SET datum = @datum
	,castka = @castka
	,druh = @druh
	,protistrana = @protistrana
	,ucet = @ucet
	,pozn = @poznamka
	,id_kontrakt = @idkontrakt
	,realizovano = @realizovano
	WHERE id_pol = @idpol
END
GO

CREATE PROCEDURE update_f_PV_prijmy_skutecnost
	@idpol	int
	,@datum	date
	,@castka	numeric(20,2)
	,@druh		nvarchar(100)
	,@protistrana	nvarchar(255)
	,@ucet	nvarchar(255)
	,@poznamka	nvarchar(255)
	,@idkontrakt	int
	,@idrefpol	int
AS
BEGIN
	UPDATE xhyvv00_f_PV_prijmy_skutecnost
	SET datum = @datum
	,castka = @castka
	,druh = @druh
	,protistrana = @protistrana
	,ucet = @ucet
	,pozn = @poznamka
	,id_kontrakt = @idkontrakt
	,id_refpol = @idrefpol
	WHERE id_pol = @idpol
END
GO

CREATE PROCEDURE update_f_PV_vydaje_mzdy_plan
	@idpol	int
	,@datum	date
	,@castka	numeric(20,2)
	,@druh		nvarchar(100)
	,@protistrana	nvarchar(255)
	,@ucet	nvarchar(255)
	,@poznamka	nvarchar(255)
	,@idzamestnanec	int
	,@realizovano	nvarchar(50)
	AS
BEGIN
	UPDATE xhyvv00_f_PV_vydaje_mzdy_plan
	SET datum = @datum
	,castka = @castka
	,druh = @druh
	,protistrana = @protistrana
	,ucet = @ucet
	,pozn = @poznamka
	,id_zamestnanec = @idzamestnanec
	,realizovano = @realizovano
	WHERE id_pol = @idpol
END
GO

CREATE PROCEDURE update_f_PV_vydaje_mzdy_skutecnost
	@idpol	int
	,@datum	date
	,@castka	numeric(20,2)
	,@druh		nvarchar(100)
	,@protistrana	nvarchar(255)
	,@ucet	nvarchar(255)
	,@poznamka	nvarchar(255)
	,@idzamestnanec	int
	,@idrefpol	int
	AS
BEGIN
	UPDATE xhyvv00_f_PV_vydaje_mzdy_skutecnost
	SET datum = @datum
	,castka = @castka
	,druh = @druh
	,protistrana = @protistrana
	,ucet = @ucet
	,pozn = @poznamka
	,id_zamestnanec = @idzamestnanec
	,id_refpol = @idrefpol
	WHERE id_pol = @idpol
END
GO

CREATE PROCEDURE update_f_PV_vydaje_najem_plan
	@idpol	int
	,@datum	date
	,@castka	numeric(20,2)
	,@druh		nvarchar(100)
	,@protistrana	nvarchar(255)
	,@ucet	nvarchar(255)
	,@poznamka	nvarchar(255)
	,@idpobocka	int
	,@realizovano	nvarchar(50)
	AS
BEGIN
	UPDATE xhyvv00_f_PV_vydaje_najem_plan
	SET datum = @datum
	,castka = @castka
	,druh = @druh
	,protistrana = @protistrana
	,ucet = @ucet
	,pozn = @poznamka
	,id_pobocka = @idpobocka
	,realizovano = @realizovano
	WHERE id_pol = @idpol
END
GO

CREATE PROCEDURE update_f_PV_vydaje_najem_skutecnost
	@idpol	int
	,@datum	date
	,@castka	numeric(20,2)
	,@druh		nvarchar(100)
	,@protistrana	nvarchar(255)
	,@ucet	nvarchar(255)
	,@poznamka	nvarchar(255)
	,@idpobocka	int
	,@idrefpol	int
	AS
BEGIN
	UPDATE xhyvv00_f_PV_vydaje_najem_skutecnost
	SET datum = @datum
	,castka = @castka
	,druh = @druh
	,protistrana = @protistrana
	,ucet = @ucet
	,pozn = @poznamka
	,id_pobocka = @idpobocka
	,id_refpol = @idrefpol
	WHERE id_pol = @idpol
END
GO

CREATE PROCEDURE update_f_PV_vydaje_osobni_plan
	@idpol	int
	,@datum	date
	,@castka	numeric(20,2)
	,@druh		nvarchar(100)
	,@protistrana	nvarchar(255)
	,@ucet	nvarchar(255)
	,@poznamka	nvarchar(255)
	,@idzamestnanec	int
	,@realizovano	nvarchar(50)
	AS
BEGIN
	UPDATE xhyvv00_f_PV_vydaje_osobni_plan
	SET datum = @datum
	,castka = @castka
	,druh = @druh
	,protistrana = @protistrana
	,ucet = @ucet
	,pozn = @poznamka
	,id_zamestnanec = @idzamestnanec
	,realizovano = @realizovano
	WHERE id_pol = @idpol
END
GO

CREATE PROCEDURE update_f_PV_vydaje_osobni_skutecnost
	@idpol	int
	,@datum	date
	,@castka	numeric(20,2)
	,@druh		nvarchar(100)
	,@protistrana	nvarchar(255)
	,@ucet	nvarchar(255)
	,@poznamka	nvarchar(255)
	,@idzamestnanec	int
	,@idrefpol	int
	AS
BEGIN
	UPDATE xhyvv00_f_PV_vydaje_osobni_skutecnost
	SET datum = @datum
	,castka = @castka
	,druh = @druh
	,protistrana = @protistrana
	,ucet = @ucet
	,pozn = @poznamka
	,id_zamestnanec = @idzamestnanec
	,id_refpol = @idrefpol
	WHERE id_pol = @idpol
END
GO

CREATE PROCEDURE update_f_PV_vydaje_rezie_plan
	@idpol	int
	,@datum	date
	,@castka	numeric(20,2)
	,@druh		nvarchar(100)
	,@protistrana	nvarchar(255)
	,@ucet	nvarchar(255)
	,@poznamka	nvarchar(255)
	,@idpobocka	int
	,@realizovano	nvarchar(50)
	AS
BEGIN
	UPDATE xhyvv00_f_PV_vydaje_rezie_plan
	SET datum = @datum
	,castka = @castka
	,druh = @druh
	,protistrana = @protistrana
	,ucet = @ucet
	,pozn = @poznamka
	,id_pobocka = @idpobocka
	,realizovano = @realizovano
	WHERE id_pol = @idpol
END
GO

CREATE PROCEDURE update_f_PV_vydaje_rezie_skutecnost
	@idpol	int
	,@datum	date
	,@castka	numeric(20,2)
	,@druh		nvarchar(100)
	,@protistrana	nvarchar(255)
	,@ucet	nvarchar(255)
	,@poznamka	nvarchar(255)
	,@idpobocka	int
	,@idrefpol	int
	AS
BEGIN
	UPDATE xhyvv00_f_PV_vydaje_rezie_skutecnost
	SET datum = @datum
	,castka = @castka
	,druh = @druh
	,protistrana = @protistrana
	,ucet = @ucet
	,pozn = @poznamka
	,id_pobocka = @idpobocka
	,id_refpol = @idrefpol
	WHERE id_pol = @idpol
END
GO

CREATE PROCEDURE update_f_PV_vydaje_zdroje_plan
	@idpol	int
	,@datum	date
	,@castka	numeric(20,4)
	,@druh		nvarchar(100)
	,@protistrana	nvarchar(255)
	,@ucet	nvarchar(255)
	,@poznamka	nvarchar(255)
	,@idkontrakt int
	,@idzdroj	int
	,@realizovano	nvarchar(50)
	AS
BEGIN
	UPDATE xhyvv00_f_PV_vydaje_zdroje_plan
	SET datum = @datum
	,castka = @castka
	,druh = @druh
	,protistrana = @protistrana
	,ucet = @ucet
	,pozn = @poznamka
	,id_kontrakt = @idkontrakt
	,id_zdroj = @idzdroj
	,realizovano = @realizovano
	WHERE id_pol = @idpol
END
GO

CREATE PROCEDURE update_f_PV_vydaje_zdroje_skutecnost
	@idpol	int
	,@datum	date
	,@castka	numeric(20,4)
	,@druh		nvarchar(100)
	,@protistrana	nvarchar(255)
	,@ucet	nvarchar(255)
	,@poznamka	nvarchar(255)
	,@idkontrakt	int
	,@idzdroj	int
	,@idrefpol	int
	AS
BEGIN
	UPDATE xhyvv00_f_PV_vydaje_zdroje_skutecnost
	SET datum = @datum
	,castka = @castka
	,druh = @druh
	,protistrana = @protistrana
	,ucet = @ucet
	,pozn = @poznamka
	,id_kontrakt = @idkontrakt
	,id_zdroj = @idzdroj
	,id_refpol = @idrefpol
	WHERE id_pol = @idpol
END
GO
*/

CREATE PROCEDURE update_t_kontrakty
	@idkontrakt	int
	,@idzakaznik	int
	,@idzdroj	int
	,@datumod	date
	,@datumdo	date
	,@prijmyplan	money
	,@nakladyplan	money
AS
BEGIN
	UPDATE xhyvv00_t_kontrakty
	SET id_zakaznik = @idzakaznik
	,id_zdroj = @idzdroj
	,datumod = @datumod
	,datumdo = @datumdo
	,cena_plan_celkem = @prijmyplan
	,naklady_plan_celkem = @nakladyplan
	WHERE id_kontrakt = @idkontrakt
END
GO

CREATE PROCEDURE update_t_kontrakty_prijmy
	@idkontrakt	int
	,@skutecnyprijem	numeric(20,4)
AS
BEGIN
	UPDATE xhyvv00_t_kontrakty
	SET cena_skut_celkem = @skutecnyprijem
	WHERE id_kontrakt = @idkontrakt
END
GO




CREATE PROCEDURE update_f_mzdy_plan
	@idpol	int
	,@castka	numeric(20,2)
	,@datum		date
	,@idtyp		int
	,@iddruh	int
	,@idplanskut	int
	,@idzam	int
AS
BEGIN
	UPDATE xhyvv00_f_PV
	SET castka = @castka
	,datum = @datum
	,id_zamestnanec = @idzam
	WHERE id_pol = @idpol
	AND id_druh_transakce = @iddruh
	AND id_typ_transakce = @idtyp
	AND id_plan_skutecnost = @idplanskut
END
GO

CREATE PROCEDURE update_f_mzdy_skutecnost
	@idpol	int
	,@castka	numeric(20,2)
	,@datum		date
	,@idtyp		int
	,@iddruh	int
	,@idplanskut	int
	,@idzam	int
AS
BEGIN
	UPDATE xhyvv00_f_PV
	SET castka = @castka
	,datum = @datum
	,id_zamestnanec = @idzam
	WHERE id_pol = @idpol
	AND id_druh_transakce = @iddruh
	AND id_typ_transakce = @idtyp
	AND id_plan_skutecnost = @idplanskut
END
GO

CREATE PROCEDURE update_f_najem_plan
	@idpol	int
	,@castka	numeric(20,2)
	,@datum		date
	,@idtyp		int
	,@iddruh	int
	,@idplanskut	int
	,@idpobocka	int
AS
BEGIN
	UPDATE xhyvv00_f_PV
	SET castka = @castka
	,datum = @datum
	,id_pobocka = @idpobocka
	WHERE id_pol = @idpol
	AND id_druh_transakce = @iddruh
	AND id_typ_transakce = @idtyp
	AND id_plan_skutecnost = @idplanskut
END
GO

CREATE PROCEDURE update_f_najem_skutecnost
	@idpol	int
	,@castka	numeric(20,2)
	,@datum		date
	,@idtyp		int
	,@iddruh	int
	,@idplanskut	int
	,@idpobocka	int
AS
BEGIN
	UPDATE xhyvv00_f_PV
	SET castka = @castka
	,datum = @datum
	,id_pobocka = @idpobocka
	WHERE id_pol = @idpol
	AND id_druh_transakce = @iddruh
	AND id_typ_transakce = @idtyp
	AND id_plan_skutecnost = @idplanskut
END
GO




CREATE PROCEDURE update_f_osobni_plan
	@idpol	int
	,@castka	numeric(20,2)
	,@datum		date
	,@idtyp		int
	,@iddruh	int
	,@idplanskut	int
	,@idzam	int
AS
BEGIN
	UPDATE xhyvv00_f_PV
	SET castka = @castka
	,datum = @datum
	,id_zamestnanec = @idzam
	WHERE id_pol = @idpol
	AND id_druh_transakce = @iddruh
	AND id_typ_transakce = @idtyp
	AND id_plan_skutecnost = @idplanskut
END
GO

CREATE PROCEDURE update_f_osobni_skutecnost
	@idpol	int
	,@castka	numeric(20,2)
	,@datum		date
	,@idtyp		int
	,@iddruh	int
	,@idplanskut	int
	,@idzam	int
AS
BEGIN
	UPDATE xhyvv00_f_PV
	SET castka = @castka
	,datum = @datum
	,id_zamestnanec = @idzam
	WHERE id_pol = @idpol
	AND id_druh_transakce = @iddruh
	AND id_typ_transakce = @idtyp
	AND id_plan_skutecnost = @idplanskut
END
GO

CREATE PROCEDURE update_f_rezie_plan
	@idpol	int
	,@castka	numeric(20,2)
	,@datum		date
	,@idtyp		int
	,@iddruh	int
	,@idplanskut	int
	,@idpobocka	int
AS
BEGIN
	UPDATE xhyvv00_f_PV
	SET castka = @castka
	,datum = @datum
	,id_pobocka = @idpobocka
	WHERE id_pol = @idpol
	AND id_druh_transakce = @iddruh
	AND id_typ_transakce = @idtyp
	AND id_plan_skutecnost = @idplanskut
END
GO

CREATE PROCEDURE update_f_rezie_skutecnost
	@idpol	int
	,@castka	numeric(20,2)
	,@datum		date
	,@idtyp		int
	,@iddruh	int
	,@idplanskut	int
	,@idpobocka	int
AS
BEGIN
	UPDATE xhyvv00_f_PV
	SET castka = @castka
	,datum = @datum
	,id_pobocka = @idpobocka
	WHERE id_pol = @idpol
	AND id_druh_transakce = @iddruh
	AND id_typ_transakce = @idtyp
	AND id_plan_skutecnost = @idplanskut
END
GO

CREATE PROCEDURE update_f_zdroje_plan
	@idpol	int
	,@castka	numeric(20,2)
	,@datum		date
	,@idtyp		int
	,@iddruh	int
	,@idplanskut	int
	,@idkontrakt	int
	,@idzdroj	int
AS
BEGIN
	UPDATE xhyvv00_f_PV
	SET castka = @castka
	,datum = @datum
	,id_kontrakt = @idkontrakt
	,id_zdroj = @idzdroj
	WHERE id_pol = @idpol
	AND id_druh_transakce = @iddruh
	AND id_typ_transakce = @idtyp
	AND id_plan_skutecnost = @idplanskut
END
GO

CREATE PROCEDURE update_f_zdroje_skutecnost
	@idpol	int
	,@castka	numeric(20,2)
	,@datum		date
	,@idtyp		int
	,@iddruh	int
	,@idplanskut	int
	,@idkontrakt	int
	,@idzdroj	int
AS
BEGIN
	UPDATE xhyvv00_f_PV
	SET castka = @castka
	,datum = @datum
	,id_kontrakt = @idkontrakt
	,id_zdroj = @idzdroj
	WHERE id_pol = @idpol
	AND id_druh_transakce = @iddruh
	AND id_typ_transakce = @idtyp
	AND id_plan_skutecnost = @idplanskut
END
GO

CREATE PROCEDURE update_f_prijmy_plan
	@idpol	int
	,@castka	numeric(20,2)
	,@datum		date
	,@idtyp		int
	,@iddruh	int
	,@idplanskut	int
	,@idkontrakt	int
AS
BEGIN
	UPDATE xhyvv00_f_PV
	SET castka = @castka
	,datum = @datum
	,id_kontrakt = @idkontrakt
	WHERE id_pol = @idpol
	AND id_druh_transakce = @iddruh
	AND id_typ_transakce = @idtyp
	AND id_plan_skutecnost = @idplanskut
END
GO

CREATE PROCEDURE update_f_prijmy_skutecnost
	@idpol	int
	,@castka	numeric(20,2)
	,@datum		date
	,@idtyp		int
	,@iddruh	int
	,@idplanskut	int
	,@idkontrakt	int
AS
BEGIN
	UPDATE xhyvv00_f_PV
	SET castka = @castka
	,datum = @datum
	,id_kontrakt = @idkontrakt
	WHERE id_pol = @idpol
	AND id_druh_transakce = @iddruh
	AND id_typ_transakce = @idtyp
	AND id_plan_skutecnost = @idplanskut
END
GO

