SELECT
b.BehovStartDat AS Start_Purchase_Date
,b.BestBerLevDat AS Est_Receipt_Date
,b.BestBegLevDat AS Request_Disp_Date
,b.LagStalle AS Inventory_Location
,b.AnskaffningKop AS Purchased
,b.AnskaffningTillv AS Manufactured
,b.ArtNr AS Item_Number
,b1.ArtBeskr AS Item_Description
,b.FtgNr AS Company_ID
,b.BehovAntal AS Required_Quantity
,b.BestAnt AS Order_Qty
,b.AoNr AS MO_Number
,b.Bestnr AS PO_Number
,b.BestRadNr AS PO_Row
,b.KortNotering AS Note
,b.InkHandl AS Buyer
,b.PlanAnsv AS Planning_Manager
,b.NRP_Action AS MRP_Action
,b.NRP_FromDate AS Change_From_Date
,b.NRP_ToDate AS Change_To_Date
,b.NRP_FromQty AS Change_From_Qty
,b.NRP_ToQty  AS Change_To_Qty
,CASE
  WHEN b.KortNotering LIKE '%Excess%' THEN 'Excess Inventory'
  WHEN b.KortNotering LIKE '%Date Change%' THEN 'Date Change'
  WHEN b.KortNotering IS NULL THEN 'Order'
  ELSE 'Move Order Up'
  END AS 'Action'
,CASE
  WHEN b.ArtNr LIKE '%R' THEN 'AF'
  WHEN b.ArtNr LIKE '4%' THEN 'AF'
  WHEN b.InkHandl IS NULL AND b.LagStalle IN (0,394) THEN 'Print/Warehouse'
  WHEN b.InkHandl IS NULL AND b.LagStalle = '440' THEN 'Amazon'
  WHEN b.InkHandl IS NULL AND (b.PlanAnsv <> 'WHS MO' AND b.PlanAnsv IS NOT NULL) THEN b.PlanAnsv
  WHEN b.InkHandl = 'AF' OR b.PlanAnsv = 'AF'  THEN 'AF'
  WHEN b.InkHandl = 'SA' OR b.PlanAnsv = 'SA' THEN 'SA'
  WHEN b.InkHandl = 'MS' OR b.PlanAnsv = 'MS' THEN 'MS'
  WHEN b.InkHandl = 'MR' OR b.PlanAnsv = 'MR' THEN 'MR'
  WHEN b.LagStalle IN (10,11,14,21,22,23) THEN 'MS'
  WHEN b.LagStalle IN (19,15) THEN 'MR'
  WHEN b.LagStalle IN (48,45,44,18,17) THEN 'MR'
  WHEN b.LagStalle IN (46) THEN 'Diamond Wipes'

  ELSE b.InkHandl
  END AS 'Owner'

FROM
bia b (NOLOCK)
 INNER JOIN
 (SELECT DISTINCT
	ArtNr
	,ArtBeskr
	,DENSE_RANK()OVER(partition by ArtNr order by ArtBeskr desc) Rank
	FROM
	bp bp (NOLOCK)) b1
	ON b1.ArtNr = b.ArtNr
WHERE
1=1
AND
b.BehovStartDat < GETDATE()+30
AND
b.BehovStartDat > GETDATE()-7
AND
b.LagStalle <> '1'
AND
b1.Rank=1
