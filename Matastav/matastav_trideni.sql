USE skola;
GO
WITH t AS(
SELECT psc,COUNT(distinct nazokres) AS drank
 FROM xhyvv00_t_psc_placeholder
 GROUP BY psc
 HAVING COUNT(distinct nazokres) > 1
 ), osklivosti AS (
SELECT psc, nazpost, nazokres, COUNT(psc) OVER(PARTITION BY nazpost, nazokres) AS cnt
FROM xhyvv00_t_psc_placeholder
WHERE psc IN (select psc FROM t)
), ppp AS (
SELECT  *, DENSE_RANK() OVER(PARTITION BY psc ORDER BY cnt DESC) AS drank
FROM osklivosti
), ddd AS(
SELECT psc, nazpost, nazokres, cnt, drank, ROW_NUMBER() OVER(PARTITION BY psc,drank ORDER BY cnt) AS rownum
FROM ppp
), predposledni AS (
SELECT *
	, MAX(rownum) OVER(PARTITION BY psc, drank) AS maxrownumdrank
	, MAX(rownum) OVER(PARTITION BY psc) AS maxrownumpsc	
FROM ddd
), posledni AS (
SELECT  psc, nazpost, nazokres, dense_rank() OVER(PARTITION BY psc ORDER BY nazokres) AS rnk FROM predposledni WHERE drank = 1 AND  cnt  < maxrownumpsc
)

--DELETE FROM posledni WHERE rnk > 1
--SELECT ABS(Checksum(NewID()) % 2) + 1
--DELETE FROM predposledni WHERE drank > 1;

-- order by u rownum je v podstate random, takze pokazde deletneme neco jineho
