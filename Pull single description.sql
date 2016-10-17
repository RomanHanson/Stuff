SELECT Distinct
a.ArtNr
,a.ArtBeskr
FROM
(SELECT DISTINCT
ArtNr
,ArtBeskr
,DENSE_RANK()OVER(partition by ArtNr order by ArtBeskr desc) Rank
FROM
bp
WHERE
ArtNr ='92063')a
WHERE
a.Rank = 1
GROUP BY
a.ArtNr
,a.ArtBeskr
