--CROSS-SELLING PRODUCTS
---FOR 2 CATEGORY COMBO
WITH CombinationCounts AS (
    SELECT 
        A.order_id, 
        A.Category AS Category1, 
        B.Category AS Category2
    FROM 
        ORDER360 A
    JOIN 
        ORDER360 B
    ON 
        A.order_id = B.order_id 
        AND A.Category < B.Category -- Avoid duplicate/reverse pairs
)
SELECT 
    Category1, 
    Category2, 
    COUNT(*) AS Frequency 
FROM 
    CombinationCounts
GROUP BY 
    Category1, Category2
ORDER BY 
    Frequency DESC

--------------------------------------------------------------------------------------
---FOR 3 CATEGORY COMBO
WITH CombinationCounts AS (
    SELECT 
        A.order_id, 
        A.Category AS Category1, 
        B.Category AS Category2, 
        C.Category AS Category3
    FROM 
        ORDER360 A
    JOIN 
        ORDER360 B
    ON 
        A.order_id = B.order_id 
        AND A.Category < B.Category -- Avoid duplicate/reverse combinations
    JOIN 
        ORDER360 C
    ON 
        B.order_id = C.order_id 
        AND B.Category < C.Category -- Avoid duplicate/reverse combinations
)
SELECT TOP 10
    Category1, 
    Category2, 
    Category3, 
    COUNT(*) AS Frequency
FROM 
    CombinationCounts
GROUP BY 
    Category1, Category2, Category3
ORDER BY 
    Frequency DESC


-----------------------------------------------------------
--COHORT ANALYSIS
--For Fixed Month
WITH FirstPurchase AS (
    SELECT Customer_id, MIN(Bill_Date) AS First_Purchase_Date FROM ORDER360
    GROUP BY Customer_id
),
 counts as ( select Customer_id,min(Bill_Date) as mins,max(Bill_Date) as maxs,
                count(distinct order_id) as cnt,
				datediff(MONTH, min(Bill_Date), max(Bill_Date)) / (count(distinct order_id) - 1) as avg_order_gap
				from ORDER360
            group by Customer_id
			having count(distinct order_id)>1),

Retention_rates as (select YEAR(First_Purchase_Date) as Years,MONTH(First_Purchase_Date) as months,
COUNT( X.Customer_id) AS New_Customers_Acquired,count(Y.Customer_id) as [Total customer retention],
 CASE 
      WHEN COUNT(Y.Customer_id) is null THEN 0
      ELSE  CAST((COUNT(Y.Customer_id) * 1.0 / COUNT(X.Customer_id) * 100) AS DECIMAL(10, 3))

 END AS Retention_Rate from FirstPurchase as X
left join counts as Y
on X.Customer_id=Y.Customer_id 
group by YEAR(First_Purchase_Date),MONTH(First_Purchase_Date)),

avgs as(select 
    Z.*,
     case 
	   when avg(Y.avg_order_gap) is null
	     then 0
	   else avg(Y.avg_order_gap) 
	end  as Avg_Months_Repeated_Customers
from 
    ORDER360 as X
left join 
    counts as Y on Year(X.Bill_Date)=year(Y.mins) and MONTH(X.Bill_Date)=month(Y.mins)
right join
    Retention_rates as Z
	on Year(X.Bill_Date)=Z.Years and MONTH(X.Bill_Date)=Z.months

group by Z.Years,Z.months,Z.New_Customers_Acquired,Z.[Total customer retention],Z.Retention_Rate),


Total_amt_qty  as (select X.*,round(sum([Total Amount]),2) as [Tot.amount by new customer],sum(Quantity) as 
[Tot.quantity by new customer] from avgs as X
left join ORDER360 as O
on X.Years=Year(O.Bill_Date)
and X.months=month(Bill_Date)
group by X.Years,x.months,X.New_Customers_Acquired,X.[Total customer retention],X.Retention_Rate,X.Avg_Months_Repeated_Customers)

select Z.*,
case 
      when sum([Total Amount]) is null 
      then 0 
else round(sum([Total Amount]),2) 
end as [Tot.amount by retention customer],
case 
      when  sum(Quantity) is null 
	  then 0
else sum(Quantity) 
end as [Tot.quantity by retention customer] from     
ORDER360 as X
right join 
    counts as Y on X.Customer_id=Y.Customer_id and Year(X.Bill_Date)=year(Y.mins) and MONTH(X.Bill_Date)=month(Y.mins)
right join
    Total_amt_qty as Z
	on Year(X.Bill_Date)=Z.Years and MONTH(X.Bill_Date)=Z.months
group by Z.Years,Z.months,Z.New_Customers_Acquired,Z.[Total customer retention],Z.Retention_Rate,
Z.Avg_Months_Repeated_Customers,[Tot.amount by new customer],[Tot.quantity by new customer]
order by Z.Years,Z.months


------------------------------------------------------------------------------------------------------------------
--For Retention by Month.
SELECT Customer_id, MIN(Bill_Date) AS First_Purchase_Date,
DATEFROMPARTS(year(MIN(Bill_Date)),MONTH(MIN(Bill_Date)),1) as cohort_date INTO cohort01 FROM ORDER360
    GROUP BY Customer_id
	
--
with cte1 as (select Z.*,
  (order_month-cohort_month)
 as diff_month                    --(order_year-cohort_year) as diff_year
from(select X.*,Y.cohort_date,month(Bill_Date) as order_month,
 month(cohort_date) as cohort_month from ORDER360 as X
 left join cohort01 as Y
 on X.Customer_id=Y.Customer_id
 and year(X.Bill_Date)=year(Y.cohort_date)) as Z)

 select *, (diff_month) as cohort_index --into cohort_retention04  
 from cte1 

-- 
 select * from 
 (select distinct Customer_id,cohort_date,cohort_index 
 from cohort_retention04
 where cohort_date is not null
) as tbl
 pivot ( count(Customer_id) for cohort_index in
           ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])) as pivot_table
		    order by cohort_date


------------------------------------------------------------------------------------------
--TOTAL DISCOUNT
SELECT SUM(Discount)
FROM ORDER360

--Avg days btw 2 customer trans
SELECT AVG(AvgDaysBetween) [Avg days btw 2 customer trans]
FROM
(SELECT Customer_id, AVG(DaysBetween) AvgDaysBetween
FROM
(SELECT Customer_id, DATEDIFF(DAY, Bill_Date, NextTransDate) DaysBetween
FROM
(SELECT Customer_id, Bill_Date, LEAD(Bill_Date) OVER(PARTITION BY Customer_id ORDER BY Bill_Date) NextTransDate
FROM ORDER360) Y
WHERE NextTransDate IS NOT NULL) Z
GROUP BY Customer_id) X


--AVG DISCOUNT
SELECT sum(Discount)/count(distinct order_id)
FROM ORDER360


----------------------------------------------------------------------------------------------------------------------------
--HOUR-WISE REVENUE
SELECT 
    FORMAT(Bill_Date, 'HH') AS HOUR, 
    SUM([Total Amount]) AS REVENUE
FROM 
    ORDER360
GROUP BY 
    FORMAT(Bill_Date, 'HH')

---------------------------------------------------------------------------------------------------------------------------
--REPEAT CUSTOMERS
SELECT COUNT(Custid)
FROM CUSTOMER360
WHERE [No. of Trans]>1

--ONE-TIME CUSTOMERS
SELECT COUNT(Custid)
FROM CUSTOMER360
WHERE [No. of Trans]=1



--INACTIVE CUSTOMERS
select COUNT(Custid) [Customer count]
from CUSTOMER360
where [INACTIVE DAYS]>=90

--CHURN RATE
SELECT (CAST([Customer count] AS FLOAT)/(SELECT COUNT(Custid) FROM CUSTOMER360))*100 [Churn rate]
FROM
(select COUNT(Custid) [Customer count]
from CUSTOMER360
where [INACTIVE DAYS]>=90) X

--CUSTOMERS WHO USED ALL CHANNELS
SELECT COUNT(Custid)[CUSTOMER COUNT]
FROM CUSTOMER360
WHERE [Channels count]=3

--MULTI-CATEGORY BUYERS
SELECT COUNT(Custid)
FROM CUSTOMER360
WHERE [Distinct category]>1