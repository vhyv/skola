USE skola;
GO

CREATE TABLE xhyvv00_t_typy_zdroju (
	id_typ_zdroje		int				
	,typ_zdroje			nvarchar(255)	NOT NULL
	,CONSTRAINT PK_typyzdroju	PRIMARY KEY(id_typ_zdroje)
	)
;
GO

CREATE TABLE xhyvv00_t_funkce (
	id_funkce			int				
	,nazev_funkce		nvarchar(100)	NOT NULL
	,osobni_ohodnoceni	numeric(20,2)	NOT NULL
	,CONSTRAINT PK_funkce	PRIMARY KEY(id_funkce)
	)
;
GO

CREATE TABLE xhyvv00_t_kategorie_zakazniku (
	id_kategorie		int				
	,nazev_kategorie	nvarchar(100)	NOT NULL
	,sleva_prirazka		numeric(7,3)	NOT NULL
	,CONSTRAINT PK_kategoriezakazniku	PRIMARY KEY(id_kategorie)
	)
;
GO

CREATE TABLE xhyvv00_t_pobocky (
	id_pobocka			int				
	,zkratka			nvarchar(100)	NOT NULL
	,nazev				nvarchar(100)	NOT NULL
	,ulice				nvarchar(100)	NOT NULL
	,mesto				nvarchar(100)	NOT NULL
	,psc				int				NOT NULL
	,mesicni_pronajem	numeric(20,2)	NOT NULL
	,CONSTRAINT PK_pobocky	PRIMARY KEY(id_pobocka)
	,CONSTRAINT FK_pobocky_psc	FOREIGN KEY(psc)
		REFERENCES xhyvv00_t_psc(id_psc)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	)
;
GO

CREATE TABLE xhyvv00_t_zamestnanci (
	id_zamestnanec	int				
	,prijmeni		nvarchar(100)	NOT NULL
	,jmeno			nvarchar(100)	NOT NULL
	,fullname		AS CONCAT(jmeno, ' ', prijmeni)
	,titul			nvarchar(15)	NULL
	,plat			numeric(20,2)	NOT NULL
	,id_nadrizeny	int				NULL
	,id_pobocka		int				NOT NULL
	,id_funkce		int				NOT NULL
	,CONSTRAINT PK_zamestnanci	PRIMARY KEY(id_zamestnanec)
	,CONSTRAINT FK_zamestnanci_nadrizeny FOREIGN KEY(id_nadrizeny)
		REFERENCES xhyvv00_t_zamestnanci(id_zamestnanec)
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
	id_ukol						int				
	,id_zamestnanec				int				NOT NULL
	,popis_ukolu				nvarchar(255)	NULL
	,CONSTRAINT PK_ukoly	PRIMARY KEY(id_ukol)
	,CONSTRAINT FK_ukoly_zamestnanci FOREIGN KEY(id_zamestnanec)
		REFERENCES xhyvv00_t_zamestnanci(id_zamestnanec)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	)
;
GO

CREATE TABLE xhyvv00_t_zdroje (
	id_zdroj					int				
	,zkratka					nvarchar(50)	NOT NULL
	,nazev						nvarchar(255)	NOT NULL
	,popis						nvarchar(max)	NOT NULL
	,id_typ_zdroje				int				NOT NULL
	,naklady_den				numeric(20,2)	NOT NULL
	,zaklad_den					numeric(20,2)	NOT NULL
	,CONSTRAINT PK_zdroje	PRIMARY KEY(id_zdroj)
	,CONSTRAINT	FK_zdroje_typzdroje	FOREIGN KEY(id_typ_zdroje)
		REFERENCES xhyvv00_t_typy_zdroju(id_typ_zdroje)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	)
;
GO

CREATE TABLE xhyvv00_t_zakaznici (
	id_zakaznik					int				
	,id_zamestnanec				int				NOT NULL
	,id_kategorie				int				NOT NULL
	,ico						nvarchar(50)	NOT NULL
	,zkratka					nvarchar(20)	NULL
	,nazev						nvarchar(255)	NOT NULL
	,ulice						nvarchar(255)	NOT NULL
	,mesto						nvarchar(255)	NOT NULL
	,psc						int				NOT NULL
	,kredit						numeric(30,2)	NULL
	,CONSTRAINT PK_zakaznici	PRIMARY KEY(id_zakaznik)
	,CONSTRAINT	FK_zakaznici_zamestnanec	FOREIGN KEY(id_zamestnanec)
		REFERENCES xhyvv00_t_zamestnanci(id_zamestnanec)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	,CONSTRAINT FK_zakaznici_kategorie		FOREIGN KEY(id_kategorie)
		REFERENCES xhyvv00_t_kategorie_zakazniku(id_kategorie)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	,CONSTRAINT FK_zakaznici_psc		FOREIGN KEY(psc)
		REFERENCES xhyvv00_t_psc(id_psc)
		)
;
GO

CREATE TABLE xhyvv00_t_kontrakty
	(
	id_kontrakt					int				
	,id_zakaznik				int				NOT NULL
	,id_zdroj					int				NOT NULL
	,datumod					date			NOT NULL
	,datumdo					date			NOT NULL
	,cena_plan_celkem				money	NOT NULL
	,naklady_plan_celkem			money	NOT NULL
	,cena_skut_celkem				money	NULL
	,naklady_skut_celkem			money	NULL
	,marze_plan						AS cena_plan_celkem - naklady_plan_celkem
	,delka_trvani					AS DATEDIFF(day, datumod, datumdo)
	,marze_skut						AS cena_skut_celkem - naklady_skut_celkem
	,CONSTRAINT PK_kontrakty	PRIMARY KEY(id_kontrakt)
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

CREATE TABLE xhyvv00_t_faktury_vydane
	(
	id_faktura		int		
	,id_kontrakt	int		NOT NULL
	,id_zakaznik	int		NOT NULL
	,cena_celkem	numeric(20,2)	NOT NULL
	,datum_vystaveni	date			NOT NULL
	,datum_splatnosti	date			NOT NULL
	,datum_zaplaceni	date			NULL
	,prodleni			AS CASE WHEN datum_zaplaceni > datum_splatnosti THEN 'Ano' 
							 WHEN datum_zaplaceni <= datum_splatnosti THEN 'Ne' 
							 ELSE 'Nelze urcit'
							 END 
	,CONSTRAINT PK_faktury	PRIMARY KEY(id_faktura)
	,CONSTRAINT	FK_faktury_kontrakt		FOREIGN KEY(id_kontrakt)
		REFERENCES xhyvv00_t_kontrakty(id_kontrakt)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	,CONSTRAINT FK_faktury_zakaznik		FOREIGN KEY(id_zakaznik)
		REFERENCES xhyvv00_t_zakaznici(id_zakaznik)
	)
;
GO

/*
CREATE TABLE xhyvv00_t_prijmy_plan
	(
	id_pol		int		
	,datum		date	NOT NULL
	,castka		numeric(20,2)	NOT NULL
	,druh		nvarchar(100)	NOT NULL
	,protistrana	nvarchar(255)	NOT NULL
	,ucet		nvarchar(255)	NOT NULL
	,pozn		nvarchar(255)	NULL
	,id_kontrakt	int		NOT NULL
	,realizovano	nvarchar(50)	NULL
	,CONSTRAINT PK_prijmyplan	PRIMARY KEY(id_pol)
	,CONSTRAINT FK_prijmyplan_kontrakty	FOREIGN KEY(id_kontrakt)
		REFERENCES xhyvv00_t_kontrakty(id_kontrakt)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	)
;
GO

CREATE TABLE xhyvv00_t_prijmy_skutecnost
	(
	id_pol		int		
	,datum		date	NOT NULL
	,castka		numeric(20,2)	NOT NULL
	,druh		nvarchar(100)	NOT NULL
	,protistrana	nvarchar(255)	NOT NULL
	,ucet		nvarchar(255)	NOT NULL
	,pozn		nvarchar(255)	NULL
	,id_kontrakt	int		NOT NULL
	,id_refpol	int	NOT NULL
	,CONSTRAINT PK_prijmyskut	PRIMARY KEY(id_pol)
	,CONSTRAINT FK_prijmyskut_kontrakty	FOREIGN KEY(id_kontrakt)
		REFERENCES xhyvv00_t_kontrakty(id_kontrakt)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	,CONSTRAINT FK_prijmyskut_prijmyplan	FOREIGN KEY(id_refpol)
		REFERENCES xhyvv00_t_prijmy_plan(id_pol)
	)
;
GO

CREATE TABLE xhyvv00_t_vydaje_mzdy_plan
	(
	id_pol		int		
	,datum		date	NOT NULL
	,castka		numeric(20,2)	NOT NULL
	,druh		nvarchar(100)	NOT NULL
	,protistrana	nvarchar(255)	NOT NULL
	,ucet			nvarchar(255)	NOT NULL
	,pozn			nvarchar(255)	NULL
	,id_zamestnanec		int		NOT NULL
	,realizovano	nvarchar(100)	NULL
	,CONSTRAINT PK_vydajemzdyplan	PRIMARY KEY(id_pol)
	,CONSTRAINT FK_vydajemzdyplan_zamestnanci	FOREIGN KEY(id_zamestnanec)
		REFERENCES xhyvv00_t_zamestnanci(id_zamestnanec)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	)
;
GO

CREATE TABLE xhyvv00_t_vydaje_mzdy_skutecnost
	(
	id_pol		int		
	,datum		date	NOT NULL
	,castka		numeric(20,2)	NOT NULL
	,druh		nvarchar(100)	NOT NULL
	,protistrana	nvarchar(255)	NOT NULL
	,ucet			nvarchar(255)	NOT NULL
	,pozn			nvarchar(255)	NULL
	,id_zamestnanec		int		NOT NULL
	,id_refpol		int		NOT NULL
	,CONSTRAINT PK_vydajemzdyskut	PRIMARY KEY(id_pol)
	,CONSTRAINT FK_vydajemzdyskut_zamestnanci	FOREIGN KEY(id_zamestnanec)
		REFERENCES xhyvv00_t_zamestnanci(id_zamestnanec)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	,CONSTRAINT	FK_vydajemzdyskut_vydajemzdyplan	FOREIGN KEY(id_refpol)
		REFERENCES xhyvv00_t_vydaje_mzdy_plan(id_pol)
	)
;
GO

CREATE TABLE xhyvv00_t_vydaje_najem_plan
	(
	id_pol		int		
	,datum		date	NOT NULL
	,castka		numeric(20,2)	NOT NULL
	,druh		nvarchar(100)	NOT NULL
	,protistrana	nvarchar(255)	NOT NULL
	,ucet			nvarchar(255)	NOT NULL
	,pozn			nvarchar(255)	NULL
	,id_pobocka		int		NOT NULL
	,realizovano	nvarchar(100)	NULL
	,CONSTRAINT PK_vydajenajemplan	PRIMARY KEY(id_pol)
	,CONSTRAINT FK_vydajenajemplan_pobocky	FOREIGN KEY(id_pobocka)
		REFERENCES xhyvv00_t_pobocky(id_pobocka)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	)
;
GO

CREATE TABLE xhyvv00_t_vydaje_najem_skutecnost
	(
	id_pol		int		
	,datum		date	NOT NULL
	,castka		numeric(20,2)	NOT NULL
	,druh		nvarchar(100)	NOT NULL
	,protistrana	nvarchar(255)	NOT NULL
	,ucet			nvarchar(255)	NOT NULL
	,pozn			nvarchar(255)	NULL
	,id_pobocka	int		NOT NULL
	,id_refpol		int		NOT NULL
	,CONSTRAINT PK_vydajenajemskut	PRIMARY KEY(id_pol)
	,CONSTRAINT FK_vydajenajemskut_pobocky	FOREIGN KEY(id_pobocka)
		REFERENCES xhyvv00_t_pobocky(id_pobocka)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	,CONSTRAINT	FK_vydajenajemskut_vydajenajemplan	FOREIGN KEY(id_refpol)
		REFERENCES xhyvv00_t_vydaje_najem_plan(id_pol)
	)
;
GO

CREATE TABLE xhyvv00_t_vydaje_osobni_plan
	(
	id_pol		int		
	,datum		date	NOT NULL
	,castka		numeric(20,2)	NOT NULL
	,druh		nvarchar(100)	NOT NULL
	,protistrana	nvarchar(255)	NOT NULL
	,ucet			nvarchar(255)	NOT NULL
	,pozn			nvarchar(255)	NULL
	,id_zamestnanec		int		NOT NULL
	,realizovano	nvarchar(100)	NULL
	,CONSTRAINT PK_vydajenosobniplan	PRIMARY KEY(id_pol)
	,CONSTRAINT FK_vydajeosobniplan_zamestnanci	FOREIGN KEY(id_zamestnanec)
		REFERENCES xhyvv00_t_zamestnanci(id_zamestnanec)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	)
;
GO

CREATE TABLE xhyvv00_t_vydaje_osobni_skutecnost
	(
	id_pol		int		
	,datum		date	NOT NULL
	,castka		numeric(20,2)	NOT NULL
	,druh		nvarchar(100)	NOT NULL
	,protistrana	nvarchar(255)	NOT NULL
	,ucet			nvarchar(255)	NOT NULL
	,pozn			nvarchar(255)	NULL
	,id_zamestnanec	int		NOT NULL
	,id_refpol		int		NOT NULL
	,CONSTRAINT PK_vydajeosobniskut	PRIMARY KEY(id_pol)
	,CONSTRAINT FK_vydajeosobniskut_zamestnanci	FOREIGN KEY(id_zamestnanec)
		REFERENCES xhyvv00_t_zamestnanci(id_zamestnanec)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	,CONSTRAINT	FK_vydajeosobniskut_vydajeosobniplan	FOREIGN KEY(id_refpol)
		REFERENCES xhyvv00_t_vydaje_osobni_plan(id_pol)
	)
;
GO

CREATE TABLE xhyvv00_t_vydaje_rezie_plan
	(
	id_pol		int		
	,datum		date	NOT NULL
	,castka		numeric(20,2)	NOT NULL
	,druh		nvarchar(100)	NOT NULL
	,protistrana	nvarchar(255)	NOT NULL
	,ucet			nvarchar(255)	NOT NULL
	,pozn			nvarchar(255)	NULL
	,id_pobocka		int		NOT NULL
	,realizovano	nvarchar(100)	NULL
	,CONSTRAINT PK_vydajerezieplan	PRIMARY KEY(id_pol)
	,CONSTRAINT FK_vydajerezieplan_pobocky	FOREIGN KEY(id_pobocka)
		REFERENCES xhyvv00_t_pobocky(id_pobocka)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	)
;
GO

CREATE TABLE xhyvv00_t_vydaje_rezie_skutecnost
	(
	id_pol		int		
	,datum		date	NOT NULL
	,castka		numeric(20,2)	NOT NULL
	,druh		nvarchar(100)	NOT NULL
	,protistrana	nvarchar(255)	NOT NULL
	,ucet			nvarchar(255)	NOT NULL
	,pozn			nvarchar(255)	NULL
	,id_pobocka	int		NOT NULL
	,id_refpol		int		NOT NULL
	,CONSTRAINT PK_vydajerezieskut	PRIMARY KEY(id_pol)
	,CONSTRAINT FK_vydajerezieskut_pobocky	FOREIGN KEY(id_pobocka)
		REFERENCES xhyvv00_t_pobocky(id_pobocka)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	,CONSTRAINT	FK_vydajerezieskut_vydajerezieplan	FOREIGN KEY(id_refpol)
		REFERENCES xhyvv00_t_vydaje_rezie_plan(id_pol)
	)
;
GO

CREATE TABLE xhyvv00_t_vydaje_zdroje_plan
	(
	id_pol		int		
	,datum		date	NOT NULL
	,castka		numeric(20,2)	NOT NULL
	,druh		nvarchar(100)	NOT NULL
	,protistrana	nvarchar(255)	NOT NULL
	,ucet			nvarchar(255)	NOT NULL
	,pozn			nvarchar(255)	NULL
	,id_kontrakt		int		NOT NULL
	,id_zdroj		int	NOT NULL
	,realizovano	nvarchar(100)	NULL
	,CONSTRAINT PK_vydajezdrojeplan	PRIMARY KEY(id_pol)
	,CONSTRAINT FK_vydajezdrojeplan_kontrakty	FOREIGN KEY(id_kontrakt)
		REFERENCES xhyvv00_t_kontrakty(id_kontrakt)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	,CONSTRAINT	FK_vydajezdrojeplan_zdroje	FOREIGN KEY(id_zdroj)
		REFERENCES xhyvv00_t_zdroje
	)
;
GO

CREATE TABLE xhyvv00_t_vydaje_zdroje_skutecnost
	(
	id_pol		int		
	,datum		date	NOT NULL
	,castka		numeric(20,2)	NOT NULL
	,druh		nvarchar(100)	NOT NULL
	,protistrana	nvarchar(255)	NOT NULL
	,ucet			nvarchar(255)	NOT NULL
	,pozn			nvarchar(255)	NULL
	,id_kontrakt	int		NOT NULL
	,id_zdroj		int		NOT NULL
	,id_refpol		int		NOT NULL
	,CONSTRAINT PK_vydajezdrojeskut	PRIMARY KEY(id_pol)
	,CONSTRAINT FK_vydajezdrojeskut_kontrakty	FOREIGN KEY(id_kontrakt)
		REFERENCES xhyvv00_t_kontrakty(id_kontrakt)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	,CONSTRAINT	FK_vydajezdrojeskut_vydajezdrojeplan	FOREIGN KEY(id_refpol)
		REFERENCES xhyvv00_t_vydaje_zdroje_plan(id_pol)
	,CONSTRAINT FK_vydajezdrojeskut_zdroje		FOREIGN KEY(id_zdroj)
		REFERENCES xhyvv00_t_zdroje(id_zdroj)
	)
;
GO

*/

CREATE TABLE xhyvv00_f_PV
	(id_pol		int		
	,castka		numeric(30,2)	NOT NULL
	,datum		date		NOT NULL
	,id_typ_transakce	int		NOT NULL
	,id_druh_transakce	int		NOT NULL
	,id_plan_skutecnost	int		NOT NULL
	,id_pobocka			int		NULL
	,id_zamestnanec		int		NULL
	,id_kontrakt		int		NULL
	,id_zdroj			int		NULL
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
	,CONSTRAINT FK_PV_zdroj		FOREIGN KEY(id_zdroj)
		REFERENCES xhyvv00_t_zdroje(id_zdroj)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	,CONSTRAINT FK_PV_zamestnanec	FOREIGN KEY(id_zamestnanec)
		REFERENCES xhyvv00_t_zamestnanci(id_zamestnanec)
	,CONSTRAINT FK_PV_kontrakt	FOREIGN KEY(id_kontrakt)
		REFERENCES xhyvv00_t_kontrakty(id_kontrakt)
	)
;
GO
	
