SELECT
b.LagStalle AS Location_Number
,x1.Location AS Location
,b.ftgNr AS Company_ID
,b.BestStatKod AS PO_Status
,b.BestNr AS PO
,b.BestRadNr AS PO_Row
,b.AoNr AS MO
,b.ArtNr AS Item_Number
,b.ArtBeskr AS Item_Name
,b.LedTid AS Lead_Time_Days
,m.Antal AS MO_Quantity
,b.BestAnt AS Row_Qty
,b.RowCreatedBy AS Row_Created_By
,b.RowUpdatedBy AS Row_Updated_By
,b.BestInpris AS Purchase_Price
,CAST(b.BestBerLevDat AS DATE) AS Est_Receipt_Date
FROM
bp b (NOLOCK)
    LEFT JOIN ti m (NOLOCK)
    ON b.AoNr = m.AoNr
    INNER JOIN
    (SELECT DISTINCT
	     x.LagStalle
	     ,CASE
		      WHEN x.LagStalle = 0 THEN 'Main Warehouse'
		      WHEN x.LagStalle = 11 THEN 'Gordon'
		      WHEN x.LagStalle = 10 THEN 'Thibiant'
		      WHEN x.LagStalle = 21 THEN 'Amcol'
		      WHEN x.LagPlatsNamn LIKE '%Amazon%' THEN 'Amazon'
		      ELSE x.LagPlatsNamn
		      END AS 'Location'
	    FROM
	     xb x) x1
       ON x1.LagStalle = b.LagStalle
WHERE
1=1
    AND b.BestBerLevDat < GETDATE()+90
    AND b.BestBerLevDat > GETDATE()-7
    AND b.BestStatKod<40
    AND b.ftgNr > 0
    AND b.LagStalle <> 1
    AND b.BestNr < '40000'
GROUP BY
b.LagStalle
,x1.Location
,b.ftgNr
,b.BestStatKod
,b.BestNr
,b.BestRadNr
,b.AoNr
,b.ArtNr
,b.ArtBeskr
,b.LedTid
,m.Antal
,b.RowCreatedBy
,b.RowUpdatedBy
,b.BestBerLevDat
,b.BestAnt
,b.BestInpris
