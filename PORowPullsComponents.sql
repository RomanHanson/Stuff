SELECT
b.LagStalle AS Location
,b.ftgNr AS Company_ID
,b.BestStatKod AS PO_Status
,b.BestNr AS PO
,b.AoPos AS PO_Row
,b.AoNr AS MO
,b.ArtNr AS Item_Number
--,n.ArtBeskr AS Item_Name
,b.LedTid AS Lead_Time_Days
,m.Antal AS MO_Quantity
,b.BestAnt AS Row_Qty
,b.RowCreatedBy AS Row_Created_By
,b.RowUpdatedBy AS Row_Updated_By
,CAST(b.BestBerLevDat AS DATE) AS Est_Receipt_Date
FROM
bp b (NOLOCK)
    LEFT JOIN ti m (NOLOCK)
    ON b.AoNr = m.AoNr
    -- INNER JOIN
    --   (SELECT
    --   b1.ArtNr
    --   ,b1.ArtBeskr
    --   FROM bars b1 (NOLOCK)
    --   GROUP BY
    --   b1.ArtNr
    --   ,b1.ArtBeskr)n
    --   ON n.ArtNr=b.ArtNr
WHERE
1=1
    AND b.BestBerLevDat < GETDATE()+90
    AND b.BestBerLevDat > GETDATE()-7
    AND b.BestStatKod<40
    AND b.ftgNr > 0
    AND b.LagStalle <> 1
GROUP BY
b.LagStalle
,b.ftgNr
,b.BestStatKod
,b.BestNr
,b.AoPos
,b.AoNr
,b.ArtNr
--,n.ArtBeskr
,b.LedTid
,m.Antal
,b.RowCreatedBy
,b.RowUpdatedBy
,b.BestBerLevDat
,b.BestAnt
