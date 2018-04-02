USE skola;
GO

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
	id_kraj	int	
	,nazev	nvarchar(100)	NOT NULL
	,CONSTRAINT PK_kraj	PRIMARY KEY(id_kraj)
	)
;
GO

CREATE TABLE xhyvv00_t_okres
	(
	id_okres	nvarchar(5)		
	,nazev		nvarchar(255)	NOT NULL
	,id_kraj	int		NOT NULL
	,CONSTRAINT PK_okres	PRIMARY KEY(id_okres)
	,CONSTRAINT	FK_okres_kraj	FOREIGN KEY(id_kraj)
		REFERENCES xhyvv00_t_kraj(id_kraj)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	)
;
GO

CREATE TABLE xhyvv00_t_psc
	(
	id_psc		int	
	,mesto		nvarchar(255)
	,id_okres	nvarchar(5)		NOT NULL
	,CONSTRAINT PK_psc	PRIMARY KEY(id_psc)
	,CONSTRAINT FK_psc_okres	FOREIGN KEY(id_okres)
		REFERENCES xhyvv00_t_okres(id_okres)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	)
;
GO

CREATE TABLE xhyvv00_t_psc_placeholder
	(
	psc		int
	,nazpost	nvarchar(255)
	,nazokres	nvarchar(255)
)
;
GO

CREATE PROCEDURE update_t_kraje
	@idkraj	int
	,@jmenokraje	nvarchar(255)
AS
BEGIN
	UPDATE xhyvv00_t_kraj
	SET nazev = @jmenokraje
	WHERE id_kraj = @idkraj
END
GO

CREATE PROCEDURE update_t_okres
	@idokres	nvarchar(5)
	,@nazevokres	nvarchar(255)
	,@idkraj		int
AS
BEGIN
	UPDATE xhyvv00_t_okres
	SET nazev = @nazevokres
	,id_kraj = @idkraj
	WHERE id_okres = @idokres
END
GO

CREATE PROCEDURE update_t_psc_placeholder
	@psc	int
	,@nazevokres	nvarchar(255)
	,@nazpost	nvarchar(255)
AS
BEGIN
	UPDATE xhyvv00_t_psc_placeholder
	SET nazpost = @nazpost
	,nazokres = @nazevokres
	WHERE psc = @psc
END
GO