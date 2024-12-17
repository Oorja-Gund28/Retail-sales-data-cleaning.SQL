--CLEANING OF RAW TABLE

--88631 ROWS THAT ARE MATCHED OUT OF RAW DATA(1,12,650)
SELECT * 
FROM
(SELECT Y.order_id, TOTAL_AMT, TOTAL_PAY                      
FROM
(SELECT order_id, SUM([Total Amount]) TOTAL_AMT
FROM Orders$ 
GROUP BY order_id) X
LEFT JOIN
(SELECT order_id, SUM(payment_value) TOTAL_PAY
FROM OrderPayments$ 
GROUP BY order_id) Y
ON X.order_id=Y.order_id
WHERE ROUND(TOTAL_AMT,0) = ROUND(TOTAL_PAY,0))Z

--------------------------------------------------
--24,019 RECORDS OF MISMATCHED DATA
with orderid as
(SELECT DISTINCT order_id                           
FROM Orders$

EXCEPT

SELECT Y.order_id
FROM 
    (SELECT order_id, SUM(payment_value) AS tot 
     FROM OrderPayments$ 
     GROUP BY order_id) AS X
INNER JOIN 
    (SELECT order_id, SUM([Total Amount]) AS tmt 
     FROM Orders$
     GROUP BY order_id) AS Y
ON X.order_id = Y.order_id
WHERE ABS(ROUND(tot, 0) - ROUND(tmt, 0)) < 1)

select X.* INTO ORDER1
from Orders$ as X
inner join orderid as Y
on X.order_id=Y.order_id

--------------------------------------------------
--O1=13,794 RECORDS WITH MAX QUANTITY(TREATING CUMULATIVE QUANTITY)
WITH RankedOrders AS (
    SELECT                                          
        Customer_id, 
        order_id, 
        product_id, Channel,Delivered_StoreID,
        Quantity, 
        Bill_date_timestamp, 
        [Cost Per Unit], 
        MRP, 
        Discount, 
        [Total Amount],
        DENSE_RANK() OVER (
            PARTITION BY order_id, product_id 
            ORDER BY Quantity DESC
        ) AS Rank
    FROM ORDER1
)
SELECT  
    Customer_id, 
    order_id, 
    product_id, Channel,Delivered_StoreID,
    Quantity AS [QUANTITY], 
    Bill_date_timestamp, 
    [Cost Per Unit], 
    MRP, 
    Discount, 
    [Total Amount]
	INTO O1
FROM RankedOrders
WHERE Rank = 1
ORDER BY Quantity DESC

--------------------------------------------------------
--6,553 RECORDS OF MATCHING ORDER-IDS
SELECT O.* INTO O2
FROM O1 O                                                 
JOIN(
SELECT Y.order_id
FROM(
SELECT O.order_id, SUM([Total Amount]) TOTAL_AMOUNT, [TOTAL PAYMENT VALUE]
FROM O1 O
LEFT JOIN(
SELECT order_id, SUM(payment_value) [TOTAL PAYMENT VALUE]
FROM OrderPayments$ 
GROUP BY order_id
) X
ON O.order_id=X.order_id
GROUP BY O.order_id, [TOTAL PAYMENT VALUE]
HAVING ROUND(SUM([Total Amount]),0)=ROUND([TOTAL PAYMENT VALUE],0)) Y ) C
ON O.order_id=C.order_id

--------------------------------------------------------------------------
--(88,631 + 6,553=95,184 ROWS)
--------------------------------------------------------------------------
--3,482 RECORDS OF MISMATCHED IDS
SELECT * INTO O3 
FROM 
(SELECT order_id FROM O1                                         
EXCEPT
SELECT order_id FROM O2) X

--------------------------------------------------------------------------

--8032 TOTAL RECORDS OF 3,482 IDS
 SELECT * INTO O4 FROM
 (SELECT O.*                                                               
 FROM Orders$ O
 JOIN O3 C
 ON O.order_id=C.order_id
 ) Y

-------------------------------------------------------------------------------
---ORDER11--> CONTAINS THE TOTAL 7725 RECORDS OF 3221 ORDER IDS(OUT OF 3482) THAT HAVE MATCHED PAYMENT VALUE
SELECT Customer_id, O.order_id, O.product_id, Channel,Delivered_StoreID, [Formatted date_timestamp] Bill_Date, 
		Quantity,[Cost Per Unit],MRP,Discount,[Total Amount] 
FROM Orders$ O
JOIN
(select X.order_id from                                                     --3221 ROWS 
(select order_id,(sum(MRP)-sum(Discount)) as tot  from O4
group by order_id) as X
inner join (select order_id,sum(payment_value) as pay from OrderPayments$
             group by order_id) as Y
on X.order_id=Y.order_id
 WHERE ABS(ROUND(tot, 0) - ROUND(pay, 0))<1) Y
 ON O.order_id=Y.order_id
 
----------------------------------------------------------------------------

---ORDER12-->CHANGING TOTAL AMOUNT COLUMN TO MRP-DISCOUNT
 SELECT Customer_id, order_id, product_id, Channel,Delivered_StoreID,Quantity, Bill_Date, 
		[Cost Per Unit],MRP,Discount, (MRP-DISCOUNT) [TOTAL AMOUNT] INTO ORDER12
FROM ORDER11 

------------------------------------------------------------------------------
--ORDER15-->CLUBBING THE QUANTITY OF SAME ORDER-IDS TO AVOID DUPLICATION.
select Customer_id,	order_id,	product_id	,Channel ,Delivered_StoreID, sum(Quantity) as Quantity,	
Bill_Date,[Cost Per Unit],MRP	,Discount, sum([Total Amount]) as[Total Amount] into ORDER15
 from ORDER12
group by Customer_id,	order_id,	product_id	,Channel	,Delivered_StoreID,	Bill_Date,	[Cost Per Unit],MRP	,Discount

-------------------------------------------------------------------------------
 ---FINAL ORDERS TABLE
select * into ORDER13
from
( SELECT * FROM ORDERS_NEW0
 UNION 
 SELECT * FROM ORDER15) x

-------------------------------------------------------------------------------
 ---updating storeIDs for instore and phone delivery channels.
WITH MaxStore AS (
    SELECT 
        order_id,
        Delivered_StoreID,
        SUM([Total Amount]) AS TotalAmount,
        ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY SUM([Total Amount]) DESC) AS RowNum
    FROM ORDER13
    GROUP BY order_id,
        Delivered_StoreID
)

-- Step 2: Update the Orders table by replacing the StoreID
UPDATE O
SET O.Delivered_StoreID = M.Delivered_StoreID
FROM ORDER13 as O
INNER JOIN MaxStore as M
    ON O.order_id = M.order_id
WHERE M.RowNum = 1 AND CHANNEL IN ('instore','phone delivery')

-------------------------------------------------------------------------------------------
 --JONING AVERAGE RATINGS
 SELECT O.*, [AVG SATISFACTION SCORE] INTO ORDER14
FROM ORDER13 O
JOIN(
SELECT order_id, AVG(Customer_Satisfaction_Score) [AVG SATISFACTION SCORE]
FROM OrderReview_Ratings$
GROUP BY order_id) X
ON O.order_id=X.order_id

------------------------------------------------------------------------------------------
--FINAL ORDER LEVEL TABLE
SELECT O.* , Category, COUNT( DISTINCT payment_type) PayType_count,
		SUM(CASE WHEN payment_type = 'Credit_Card' THEN ([Total Amount]) ELSE 0 END ) CC_amt,
		SUM(CASE WHEN payment_type = 'Debit_Card' THEN ([Total Amount]) ELSE 0 END )  DC_amt,
		SUM(CASE WHEN payment_type = 'UPI/Cash' THEN ([Total Amount]) ELSE 0 END )  UPI_Cash_amt,
		SUM(CASE WHEN payment_type = 'Voucher' THEN ([Total Amount]) ELSE 0 END )  Voucher_amt
FROM ORDER14 O
JOIN ProductsInfo$ P ON O.product_id=P.product_id
JOIN OrderPayments$ T ON O.order_id=T.order_id
GROUP BY Customer_id,O.order_id,O.product_id,Channel,Delivered_StoreID,QUANTITY,Bill_Date,[Cost Per Unit],MRP,
		Discount,[Total Amount],[AVG SATISFACTION SCORE],Category
