USE skola;
GO

--doladit nektere meny/penize
--dodelat penezni denik
--zkontrolovat telefony/psc/faxy etc, dat jim asi numeric (xx,0) ci mozna nejaky limit
-- predelat posty a kontrakty
-- zkontrolovat vsechny PK a FK jeste podle zadani

-- potreba doladit

CREATE TABLE xhyvv00_t_plan_skutecnost
	(
	id_plan_skutecnost	int	IDENTITY(1,1)	PRIMARY KEY
	,plan_skutecnost	nvarchar(50)	NOT NULL
	)
;
GO

INSERT INTO xhyvv00_t_plan_skutecnost(plan_skutecnost)
	VALUES ('plan'),('skutecnost')
;
GO

CREATE TABLE xhyvv00_t_druh_transakce
	(
	id_druh_transakce	int	IDENTITY(1,1)	PRIMARY KEY
	,druh_transakce		nvarchar(50)	NOT NULL
	)
;
GO

INSERT INTO xhyvv00_t_druh_transakce(druh_transakce)
	VALUES('kontrakt'), ('mzdy'), ('najem'), ('osobni'), ('rezie'), ('zdroje')
;
GO

CREATE TABLE xhyvv00_t_typ_transakce
	(
	id_typ_transakce	int	IDENTITY(1,1)	PRIMARY KEY
	,typ_transakce		nvarchar(50)	NOT NULL
	)
;
GO

INSERT INTO xhyvv00_t_typ_transakce(typ_transakce)
	VALUES('prijem'), ('vydaj')
;
GO

CREATE TABLE xhyvv00_t_kraj
	(
	id_kraj	int	IDENTITY(1,1)	PRIMARY KEY
	,nazev	nvarchar(100)	NOT NULL
	)
;
GO

CREATE TABLE xhyvv00_t_okres
	(
	id_okres	int		IDENTITY(1,1) PRIMARY KEY
	,nazev		nvarchar(255)	NOT NULL
	,id_kraj	int		NOT NULL
	,CONSTRAINT	FK_okres_kraj	FOREIGN KEY(id_kraj)
		REFERENCES xhyvv00_t_kraj(id_kraj)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	)
;
GO

CREATE TABLE xhyvv00_t_psc
	(
	id_psc		int	IDENTITY(1,1)	PRIMARY KEY
	,id_okres	int		NOT NULL
	,CONSTRAINT FK_psc_okres	FOREIGN KEY(id_okres)
		REFERENCES xhyvv00_t_okres(id_okres)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	)
;
GO

/* tohle je obsazeno v tech tejblech vyse, neni treba nazvu etc ruznych mist
CREATE TABLE xhyvv00_t_posty
	(
	nazobce		nvarchar(100)	NOT NULL
	,nazcobce	nvarchar(100)	NOT NULL
	,psc		int				NOT NULL
	,nazpost	nvarchar(100)	NOT NULL
	,kod		int				NOT NULL
	,nazokresu	nvarchar(100)	NOT NULL
	)
*/


CREATE TABLE xhyvv00_t_typy_zdroju (
	id_typ_zdroje		int				PRIMARY KEY
	,typ_zdroje			nvarchar(255)	NOT NULL
	)
;
GO

CREATE TABLE xhyvv00_t_funkce (
	id_funkce			int				PRIMARY KEY
	,nazev_funkce		nvarchar(100)	NOT NULL
	,osobni_ohodnoceni	numeric(20,3)	NOT NULL
	,osobni_ohodnoceni_mena	nvarchar(15)	NOT NULL
	,osobni_ohodnoceni2	AS CONCAT(osobni_ohodnoceni, ' ', osobni_ohodnoceni_mena) 
	)
;
GO

CREATE TABLE xhyvv00_t_kategorie_zakazniku (
	id_kategorie		int				PRIMARY KEY
	,nazev_kategorie	nvarchar(100)	NOT NULL
	,sleva_prirazka		numeric(6,3)	NOT NULL
	)
;
GO

CREATE TABLE xhyvv00_t_pobocky (
	id_pobocka			int				PRIMARY KEY
	,zkratka			nvarchar(100)	NOT NULL
	,nazev				nvarchar(100)	NOT NULL
	,ulice				nvarchar(100)	NOT NULL
	,mesto				nvarchar(100)	NOT NULL
	,psc				nvarchar(10)	NOT NULL
	,telefon			nvarchar(25)	NOT NULL
	,fax				nvarchar(25)	NULL
	,email				nvarchar(100)	NOT NULL
	,mesicni_pronajem	numeric(20,3)	NOT NULL
	,mesicni_pronajem_mena	nvarchar(15)	NOT NULL
	,mesicni_pronajem2	AS CONCAT(mesicni_pronajem, ' ', mesicni_pronajem_mena)
	)
;
GO

CREATE TABLE xhyvv00_t_zamestnanci (
	id_zamestnanec	int				PRIMARY KEY
	,prijmeni		nvarchar(100)	NOT NULL
	,jmeno			nvarchar(100)	NOT NULL
	,fullname		AS CONCAT(jmeno, ' ', prijmeni)
	,titul			nvarchar(15)	NULL
	,plat			numeric(20,3)	NOT NULL
	,plat_mena		nvarchar(10)	NOT NULL
	,plat2			AS CONCAT(plat, ' ', plat_mena)
	,id_nadrizeny	int				NOT NULL
	,id_pobocka		int				NOT NULL
	,id_funkce		int				NOT NULL
	,CONSTRAINT FK_zamestnanci_nadrizeny FOREIGN KEY(id_nadrizeny)
		REFERENCES xhyvv00_t_zamestnanci(id_zamestnanec)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	,CONSTRAINT FK_zamestnanci_pobocka FOREIGN KEY(id_pobocka)
		REFERENCES xhyvv00_t_pobocky(id_pobocka)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	,CONSTRAINT FK_zamestnanci_funkce FOREIGN KEY(id_funkce)
		REFERENCES xhyvv00_t_funkce(id_funkce)
		ON DELETE CASCADE
		ON UPDATE CASCADE
		)
;
GO


CREATE TABLE xhyvv00_t_ukoly (
	id_ukol						int				PRIMARY KEY
	,id_zamestnanec				int				NOT NULL
	,popis_ukolu				nvarchar(255)	NOT NULL
	,CONSTRAINT FK_ukoly_zamestnanci FOREIGN KEY(id_zamestnanec)
		REFERENCES xhyvv00_t_zamestnanci(id_zamestnanec)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	)
;
GO

CREATE TABLE xhyvv00_t_zdroje (
	id_zdroj					int				PRIMARY KEY
	,zkratka					nvarchar(50)	NOT NULL
	,popis						nvarchar(255)	NOT NULL
	,id_typ_zdroje				int				NOT NULL
	,naklady_den				numeric(20,3)	NOT NULL
	,naklady_den_mena			nvarchar(15)	NOT NULL
	,naklady_den2				AS CONCAT(naklady_den, ' ', naklady_den_mena)
	,zaklad_den					numeric(20,3)	NOT NULL
	,zaklad_den_mena			nvarchar(15)	NOT NULL
	,zaklad_den2				AS CONCAT(zaklad_den, ' ', zaklad_den_mena)
	,CONSTRAINT	FK_zdroje_typzdroje	FOREIGN KEY(id_typ_zdroje)
		REFERENCES xhyvv00_t_typy_zdroju(id_typ_zdroje)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	)
;
GO

CREATE TABLE xhyvv00_t_zakaznici (
	id_zakaznik					int				PRIMARY KEY
	,id_zamestnanec				int				NOT NULL
	,id_kategorie				int				NOT NULL
	,ico						numeric(20,0)	NOT NULL
	,zkratka					nvarchar(20)	NULL
	,nazev						nvarchar(255)	NOT NULL
	,ulice						nvarchar(255)	NOT NULL
	,mesto						nvarchar(255)	NOT NULL
	,psc						nvarchar(10)	NOT NULL
	,psc2						nvarchar(10)	NOT NULL
	,kredit						numeric(20,3)	NOT NULL
	,kredit_mena				nvarchar(15)	NOT NULL
	,kredit2					AS CONCAT(kredit, ' ', kredit_mena)
	,telefon					nvarchar(30)	NOT NULL
	,fax						nvarchar(50)	NULL
	,webovky					nvarchar(255)	NULL
	,poznamka					nvarchar(255)	NULL
	,CONSTRAINT	FK_zakaznici_zamestnanec	FOREIGN KEY(id_zamestnanec)
		REFERENCES xhyvv00_t_zamestnanci(id_zamestnanec)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	,CONSTRAINT FK_zakaznici_kategorie		FOREIGN KEY(id_kategorie)
		REFERENCES xhyvv00_t_kategorie_zakazniku(id_kategorie)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	,CONSTRAINT FK_zakaznici_psc			FOREIGN KEY(psc2)
		REFERENCES xhyvv00_t_psc(id_psc)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	)
;
GO

CREATE TABLE xhyvv00_t_kontrakty
	(
	id_kontrakt					int				PRIMARY KEY
	,id_zakaznik				int				NOT NULL
	,id_zdroj					int				NOT NULL
	,datumod					date			NOT NULL
	,datumdo					date			NOT NULL
	,cena_plan_celkem				numeric(20,3)	NOT NULL
	,cena_plan_celkem_mena			nvarchar(15)	NOT NULL
	,cena_plan_celkem2				AS CONCAT(cena_plan_celkem, ' ', cena_plan_celkem_mena)
	,naklady_plan_celkem			numeric(20,3)	NOT NULL
	,naklady_plan_celkem_mena		nvarchar(15)	NOT NULL
	,naklady_plan_celkem2			AS CONCAT(naklady_plan_celkem, ' ', naklady_plan_celkem_mena)
	,cena_skut_celkem				numeric(20,3)	NULL
	,cena_skut_celkem_mena			nvarchar(15)	NULL
	,cena_skut_celkem2				AS CONCAT(cena_skut_celkem, ' ', cena_skut_celkem_mena)
	,naklady_skut_celkem			numeric(20,3)	NULL
	,naklady_skut_celkem_mena		nvarchar(15)	NULL
	,naklady_skut_celkem2			AS CONCAT(naklady_skut_celkem, ' ', naklady_skut_celkem_mena)
	,marze_plan						AS cena_plan_celkem - naklady_plan_celkem
	,marze_skut						AS cena_skut_celkem - naklady_skut_celkem
	,CONSTRAINT FK_kontrakytplan_zakaznik	FOREIGN KEY(id_zakaznik)
		REFERENCES xhyvv00_t_zakaznici(id_zakaznik)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	,CONSTRAINT FK_kontrakytplan_zdroj	FOREIGN KEY(id_zdroj)
		REFERENCES xhyvv00_t_zdroje(id_zdroj)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	)
;
GO

/* Mozna zbytecna zalezitost, nechavam skutecne naklady a prijmy v puvodnim tejblu.

CREATE TABLE xhyvv00_t_kontrakty_skutecnost
	(
	id_kontrakt					int				PRIMARY KEY
	,id_zakaznik				int				NOT NULL
	,id_zdroj					int				NOT NULL
	,datumod					date			NOT NULL
	,datumdo					date			NOT NULL
	,cena_celkem1				numeric(20,3)	NOT NULL
	,cena_celkem_mena			nvarchar(15)	NOT NULL
	,cena_celkem2				nvarchar(50)	NOT NULL
	,naklady_celkem1			numeric(20,3)	NOT NULL
	,naklady_celkem_mena		nvarchar(15)	NOT NULL
	,naklady_celkem2			nvarchar(50)	NOT NULL
	,CONSTRAINT	FK_kontraktyskut_kontraktyplan	FOREIGN KEY(id_kontrakt)
		REFERENCES xhyvv00_t_kontrakty_plan(id_kontrakt)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	,CONSTRAINT FK_kontraktyskutecnost_zakaznik	FOREIGN KEY(id_zakaznik)
		REFERENCES xhyvv00_t_zakaznici(id_zakaznik)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	,CONSTRAINT FK_kontraktyskutecnost_zdroj	FOREIGN KEY(id_zdroj)
		REFERENCES xhyvv00_t_zdroje(id_zdroj)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	)
;
GO
*/


CREATE TABLE xhyvv00_t_faktury_vydane
	(
	id_faktura		int		PRIMARY KEY
	,id_kontrakt	int		NOT NULL
	,id_zakaznik	int		NOT NULL
	,cena_celkem	numeric(20,3)	NOT NULL
	,cena_celkem_mena	nvarchar(15)	NOT NULL
	,cena_celkem2		AS CONCAT(cena_celkem, ' ', cena_celkem_mena)
	,datum_vystaveni	date			NOT NULL
	,datum_splatnosti	date			NOT NULL
	,datum_zaplaceni	date			NULL
	,CONSTRAINT	FK_faktury_kontrakt		FOREIGN KEY(id_kontrakt)
		REFERENCES xhyvv00_t_kontrakty(id_kontrakt)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	,CONSTRAINT FK_faktury_zakaznik		FOREIGN KEY(id_zakaznik)
		REFERENCES xhyvv00_t_zakaznici(id_zakaznik)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	)
;
GO

CREATE TABLE xhyvv00_t_prijmy_plan
	(
	id_pol		int		PRIMARY KEY
	,datum		date	NOT NULL
	,castka		numeric(20,3)	NOT NULL
	,castka_mena	nvarchar(15)	NOT NULL
	,castka2	AS CONCAT(castka, ' ', castka_mena)
	,druh		nvarchar(100)	NOT NULL
	,protistrana	nvarchar(255)	NOT NULL
	,ucet		nvarchar(255)	NOT NULL
	,pozn		nvarchar(255)	NULL
	,id_kontrakt	int		NOT NULL
	,realizovano	nvarchar(50)	NULL
	,CONSTRAINT FK_prijmyplan_kontrakty	FOREIGN KEY(id_kontrakt)
		REFERENCES xhyvv00_t_kontrakty(id_kontrakt)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	)
;
GO

CREATE TABLE xhyvv00_t_prijmy_skutecnost
	(
	id_pol		int		PRIMARY KEY
	,datum		date	NOT NULL
	,castka		numeric(20,3)	NOT NULL
	,castka_mena	nvarchar(15)	NOT NULL
	,castka2	AS CONCAT(castka, ' ', castka_mena)
	,druh		nvarchar(100)	NOT NULL
	,protistrana	nvarchar(255)	NOT NULL
	,ucet		nvarchar(255)	NOT NULL
	,pozn		nvarchar(255)	NULL
	,id_kontrakt	int		NOT NULL
	,id_refpol	int	NOT NULL
	,CONSTRAINT FK_prijmyskut_kontrakty	FOREIGN KEY(id_kontrakt)
		REFERENCES xhyvv00_t_kontrakty(id_kontrakt)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	,CONSTRAINT FK_prijmyskut_prijmyplan	FOREIGN KEY(id_refpol)
		REFERENCES xhyvv00_t_prijmy_plan(id_pol)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	)
;
GO

CREATE TABLE xhyvv00_t_vydaje_mzdy_plan
	(
	id_pol		int		PRIMARY KEY
	,datum		date	NOT NULL
	,castka		numeric(20,3)	NOT NULL
	,castka_mena	nvarchar(15)	NOT NULL
	,castka2	AS CONCAT(castka, ' ', castka_mena)
	,druh		nvarchar(100)	NOT NULL
	,protistrana	nvarchar(255)	NOT NULL
	,ucet			nvarchar(255)	NOT NULL
	,pozn			nvarchar(255)	NULL
	,id_zamestnanec		int		NOT NULL
	,realizovano	nvarchar(100)	NULL
	,CONSTRAINT FK_vydajemzdyplan_zamestnanci	FOREIGN KEY(id_zamestnanec)
		REFERENCES xhyvv00_t_zamestnanci(id_zamestnanec)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	)
;
GO

CREATE TABLE xhyvv00_t_vydaje_mzdy_skutecnost
	(
	id_pol		int		PRIMARY KEY
	,datum		date	NOT NULL
	,castka		numeric(20,3)	NOT NULL
	,castka_mena	nvarchar(15)	NOT NULL
	,castka2	AS CONCAT(castka, ' ', castka_mena)
	,druh		nvarchar(100)	NOT NULL
	,protistrana	nvarchar(255)	NOT NULL
	,ucet			nvarchar(255)	NOT NULL
	,pozn			nvarchar(255)	NULL
	,id_zamestnanec		int		NOT NULL
	,id_refpol		int		NOT NULL
	,CONSTRAINT FK_vydajemzdyskut_zamestnanci	FOREIGN KEY(id_zamestnanec)
		REFERENCES xhyvv00_t_zamestnanci(id_zamestnanec)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	,CONSTRAINT	FK_vydajemzdyskut_vydajemzdyplan	FOREIGN KEY(id_refpol)
		REFERENCES xhyvv00_t_vydaje_mzdy_plan(id_pol)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	)
;
GO

CREATE TABLE xhyvv00_t_vydaje_najem_plan
	(
	id_pol		int		PRIMARY KEY
	,datum		date	NOT NULL
	,castka		numeric(20,3)	NOT NULL
	,castka_mena	nvarchar(15)	NOT NULL
	,castka2	AS CONCAT(castka, ' ', castka_mena)
	,druh		nvarchar(100)	NOT NULL
	,protistrana	nvarchar(255)	NOT NULL
	,ucet			nvarchar(255)	NOT NULL
	,pozn			nvarchar(255)	NULL
	,id_pobocka		int		NOT NULL
	,realizovano	nvarchar(100)	NULL
	,CONSTRAINT FK_vydajenajemplan_pobocky	FOREIGN KEY(id_pobocka)
		REFERENCES xhyvv00_t_pobocky(id_pobocka)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	)
;
GO

CREATE TABLE xhyvv00_t_vydaje_najem_skutecnost
	(
	id_pol		int		PRIMARY KEY
	,datum		date	NOT NULL
	,castka		numeric(20,3)	NOT NULL
	,castka_mena	nvarchar(15)	NOT NULL
	,castka2	AS CONCAT(castka, ' ', castka_mena)
	,druh		nvarchar(100)	NOT NULL
	,protistrana	nvarchar(255)	NOT NULL
	,ucet			nvarchar(255)	NOT NULL
	,pozn			nvarchar(255)	NULL
	,id_pobocka	int		NOT NULL
	,id_refpol		int		NOT NULL
	,CONSTRAINT FK_vydajenajemskut_pobocky	FOREIGN KEY(id_pobocka)
		REFERENCES xhyvv00_t_pobocky(id_pobocka)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	,CONSTRAINT	FK_vydajenajemskut_vydajenajemplan	FOREIGN KEY(id_refpol)
		REFERENCES xhyvv00_t_vydaje_najem_plan(id_pol)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	)
;
GO

CREATE TABLE xhyvv00_t_vydaje_osobni_plan
	(
	id_pol		int		PRIMARY KEY
	,datum		date	NOT NULL
	,castka		numeric(20,3)	NOT NULL
	,castka_mena	nvarchar(15)	NOT NULL
	,castka2	AS CONCAT(castka, ' ', castka_mena)
	,druh		nvarchar(100)	NOT NULL
	,protistrana	nvarchar(255)	NOT NULL
	,ucet			nvarchar(255)	NOT NULL
	,pozn			nvarchar(255)	NULL
	,id_zamestnanec		int		NOT NULL
	,realizovano	nvarchar(100)	NULL
	,CONSTRAINT FK_vydajeosobniplan_zamestnanci	FOREIGN KEY(id_zamestnanec)
		REFERENCES xhyvv00_t_zamestnanci(id_zamestnanec)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	)
;
GO

CREATE TABLE xhyvv00_t_vydaje_osobni_skutecnost
	(
	id_pol		int		PRIMARY KEY
	,datum		date	NOT NULL
	,castka		numeric(20,3)	NOT NULL
	,castka_mena	nvarchar(15)	NOT NULL
	,castka2	AS CONCAT(castka, ' ', castka_mena)
	,druh		nvarchar(100)	NOT NULL
	,protistrana	nvarchar(255)	NOT NULL
	,ucet			nvarchar(255)	NOT NULL
	,pozn			nvarchar(255)	NULL
	,id_zamestnanec	int		NOT NULL
	,id_refpol		int		NOT NULL
	,CONSTRAINT FK_vydajeosobniskut_zamestnanci	FOREIGN KEY(id_zamestnanec)
		REFERENCES xhyvv00_t_zamestnanci(id_zamestnanec)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	,CONSTRAINT	FK_vydajeosobniskut_vydajeosobniplan	FOREIGN KEY(id_refpol)
		REFERENCES xhyvv00_t_vydaje_osobni_plan(id_pol)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	)
;
GO

CREATE TABLE xhyvv00_t_vydaje_rezie_plan
	(
	id_pol		int		PRIMARY KEY
	,datum		date	NOT NULL
	,castka		numeric(20,3)	NOT NULL
	,castka_mena	nvarchar(15)	NOT NULL
	,castka2	AS CONCAT(castka, ' ', castka_mena)
	,druh		nvarchar(100)	NOT NULL
	,protistrana	nvarchar(255)	NOT NULL
	,ucet			nvarchar(255)	NOT NULL
	,pozn			nvarchar(255)	NULL
	,id_pobocka		int		NOT NULL
	,realizovano	nvarchar(100)	NULL
	,CONSTRAINT FK_vydajerezieplan_pobocky	FOREIGN KEY(id_pobocka)
		REFERENCES xhyvv00_t_pobocky(id_pobocka)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	)
;
GO

CREATE TABLE xhyvv00_t_vydaje_rezie_skutecnost
	(
	id_pol		int		PRIMARY KEY
	,datum		date	NOT NULL
	,castka		numeric(20,3)	NOT NULL
	,castka_mena	nvarchar(15)	NOT NULL
	,castka2	AS CONCAT(castka, ' ', castka_mena)
	,druh		nvarchar(100)	NOT NULL
	,protistrana	nvarchar(255)	NOT NULL
	,ucet			nvarchar(255)	NOT NULL
	,pozn			nvarchar(255)	NULL
	,id_pobocka	int		NOT NULL
	,id_refpol		int		NOT NULL
	,CONSTRAINT FK_vydajerezieskut_pobocky	FOREIGN KEY(id_pobocka)
		REFERENCES xhyvv00_t_pobocky(id_pobocka)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	,CONSTRAINT	FK_vydajerezieskut_vydajerezieplan	FOREIGN KEY(id_refpol)
		REFERENCES xhyvv00_t_vydaje_rezie_plan(id_pol)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	)
;
GO

CREATE TABLE xhyvv00_t_vydaje_zdroje_plan
	(
	id_pol		int		PRIMARY KEY
	,datum		date	NOT NULL
	,castka		numeric(20,3)	NOT NULL
	,castka_mena	nvarchar(15)	NOT NULL
	,castka2	AS CONCAT(castka, ' ', castka_mena)
	,druh		nvarchar(100)	NOT NULL
	,protistrana	nvarchar(255)	NOT NULL
	,ucet			nvarchar(255)	NOT NULL
	,pozn			nvarchar(255)	NULL
	,id_kontrakt		int		NOT NULL
	,id_zdroj		int	NOT NULL
	,realizovano	nvarchar(100)	NULL
	,CONSTRAINT FK_vydajezdrojeplan_kontrakty	FOREIGN KEY(id_kontrakt)
		REFERENCES xhyvv00_t_kontrakty(id_kontrakt)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	,CONSTRAINT	FK_vydajezdrojeplan_zdroje	FOREIGN KEY(id_zdroj)
		REFERENCES xhyvv00_t_zdroje
		ON DELETE CASCADE
		ON UPDATE CASCADE
	)
;
GO

CREATE TABLE xhyvv00_t_vydaje_zdroje_skutecnost
	(
	id_pol		int		PRIMARY KEY
	,datum		date	NOT NULL
	,castka		numeric(20,3)	NOT NULL
	,castka_mena	nvarchar(15)	NOT NULL
	,castka2	AS CONCAT(castka, ' ', castka_mena)
	,druh		nvarchar(100)	NOT NULL
	,protistrana	nvarchar(255)	NOT NULL
	,ucet			nvarchar(255)	NOT NULL
	,pozn			nvarchar(255)	NULL
	,id_kontrakt	int		NOT NULL
	,id_zdroj		int		NOT NULL
	,id_refpol		int		NOT NULL
	,CONSTRAINT FK_vydajezdrojeskut_kontrakty	FOREIGN KEY(id_kontrakt)
		REFERENCES xhyvv00_t_kontrakty(id_kontrakt)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	,CONSTRAINT	FK_vydajezdrojeskut_vydajezdrojeplan	FOREIGN KEY(id_refpol)
		REFERENCES xhyvv00_t_vydaje_zdroje_plan(id_pol)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	,CONSTRAINT FK_vydajezdrojeskut_zdroje		FOREIGN KEY(id_zdroj)
		REFERENCES xhyvv00_t_zdroje(id_zdroj)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	)
;
GO

CREATE TABLE xhyvv00_t_PV
	(id_pol		int		
	,castka		numeric(30,3)	NOT NULL
	,datum		date		NOT NULL
	,id_typ_transakce	int		NOT NULL
	,id_druh_transakce	int		NOT NULL
	,id_plan_skutecnost	int		NOT NULL
	,id_pobocka			int		NULL
	,id_zamestnanec		int		NULL
	,abs_rozdil_od_planu	numeric(30,3)	NULL
	,rel_rozdil_od_planu	numeric(7,4)	NULL
	,CONSTRAINT PK_PV_skupina	PRIMARY KEY NONCLUSTERED (id_pol, id_typ_transakce, id_druh_transakce, id_plan_skutecnost)
	,CONSTRAINT	FK_PV_typtransakce	FOREIGN KEY(id_typ_transakce)
		REFERENCES xhyvv00_t_typ_transakce(id_typ_transakce)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	,CONSTRAINT FK_PV_druhtransakce	FOREIGN KEY(id_druh_transakce)
		REFERENCES xhyvv00_t_druh_transakce(id_druh_transakce)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	,CONSTRAINT FK_PV_planskutecnost	FOREIGN KEY(id_plan_skutecnost)
		REFERENCES xhyvv00_t_plan_skutecnost(id_plan_skutecnost)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	,CONSTRAINT	FK_PV_pobocka	FOREIGN KEY(id_pobocka)
		REFERENCES xhyvv00_t_pobocky(id_pobocka)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	,CONSTRAINT FK_PV_zamestnanec	FOREIGN KEY(id_zamestnanec)
		REFERENCES xhyvv00_t_zamestnanci(id_zamestnanec)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	
