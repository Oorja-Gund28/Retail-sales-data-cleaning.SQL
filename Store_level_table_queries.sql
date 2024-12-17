SELECT 
    S.*,
	COUNT(DISTINCT O.customer_id) AS Customer_count,
	COUNT(DISTINCT CASE WHEN C.Custid = O.Customer_id THEN (C.customer_city) ELSE NULL END) AS Cities_count,
	COUNT(DISTINCT O.order_id) AS Frequency,
    COUNT(CASE WHEN O.Discount > 0 THEN (O.order_id) ELSE NULL END) AS [Discount Trans_count],
	COUNT(DISTINCT O.product_id) AS Distinct_PROD_QTY,
	SUM(O.Quantity) AS TOT_PROD_QTY,
	COUNT(DISTINCT P.Category) AS Distinct_Category,
    MIN(Bill_Date) AS First_Sale_Date, 
    MAX(Bill_Date) AS Last_Sale_Date,
	((SUM([Total Amount]))/(DATEDIFF(DAY, MIN(Bill_Date), MAX(Bill_Date)))) AS Avg_daily_Sale,	
    SUM([Total Amount]) AS Total_Revenue,
    SUM([Total Amount]) - SUM(O.Quantity * [Cost Per Unit]) AS Profit,
    SUM(O.Discount) AS Tot_Discount,
    -- Amount paid using Credit Card
	SUM(CASE WHEN payment_type = 'Credit_Card' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS CC_amt,
	-- Amount paid using Debit Card
	SUM(CASE WHEN payment_type = 'Debit_Card' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS DC_amt,
	-- Amount paid using UPI/Cash
	SUM(CASE WHEN payment_type = 'UPI/Cash' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS UPI_Cash_amt,
	-- Amount paid using Voucher
	SUM(CASE WHEN payment_type = 'Voucher' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Vouch_amt,
	-- Total no of distinct Customers with store via Online
	COUNT(CASE WHEN O.channel = 'Online' THEN O.Customer_id ELSE NULL END) AS Online_Cust_count,
	-- Total no. of sale via Online
    COUNT(CASE WHEN O.channel = 'Online' THEN (O.order_id) ELSE NULL END) AS Online_Freq,
	-- Total no. of purchase with discount in Online Purchase
	COUNT(CASE WHEN O.Channel = 'Online' AND O.Discount > 0 THEN (O.order_id) ELSE NULL END) AS Disc_TransCount_Online,
    -- Online monetory value
    SUM(CASE WHEN O.channel = 'Online' THEN ([Total Amount]) ELSE 0 END) AS Online_Tot_amt,
    -- Profit from Online transaction
    SUM(CASE WHEN O.channel = 'Online' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END) AS Online_Profit,
	-- Total discount given on Online channel
	SUM(CASE WHEN O.channel = 'Online' THEN (O.Discount) ELSE 0 END) AS Tot_Disc_Online,
	-- Total Product Quantity in Online Purchase
	SUM(CASE WHEN O.Channel = 'Online' THEN (O.Quantity) ELSE 0 END) AS Online_PROD_QTY,
	-- Total DISTINCT Product Quantity in Online Purchase
	COUNT(DISTINCT CASE WHEN O.Channel = 'Online' THEN (O.product_id) ELSE NULL END) AS Distinct_PROD_QTY_Online,
	-- Total DISTINCT Category Quantity in Online Purchase
	COUNT(DISTINCT CASE WHEN O.Channel = 'Online' THEN (P.Category) ELSE NULL END) AS Distinct_Cat_QTY_Online,	
	-- Amount paid using Credit Card in Online
	SUM(CASE WHEN payment_type = 'Credit_Card' AND O.channel = 'Online' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Online_CC_amt,
	-- Amount paid using Debit Card in Online
	SUM(CASE WHEN payment_type = 'Debit_Card' AND O.channel = 'Online' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Online_DC_amt,
	-- Amount paid using UPI/Cash in Online
	SUM(CASE WHEN payment_type = 'UPI/Cash' AND O.channel = 'Online' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Online_UPI_Cash_amt,
	-- Amount paid using Voucher in Online
	SUM(CASE WHEN payment_type = 'Voucher' AND O.channel = 'Online' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Online_Vouch_amt,   
    -- Total no of distinct Customers with store via Instore
	COUNT(CASE WHEN O.channel = 'Instore' THEN O.Customer_id ELSE NULL END) AS Instore_Cust_count,
	-- Total no. of sale via Instore
	COUNT(CASE WHEN O.channel = 'Instore' THEN (O.order_id) ELSE NULL END) AS Freq_Instore,
	-- Total no. of purchase with discount in Instore Purchase
	COUNT(CASE WHEN O.Channel = 'Instore' AND O.Discount > 0 THEN (O.order_id) ELSE NULL END) AS Disc_TransCount_Instore,
	-- Instore monetary value
	SUM(CASE WHEN O.channel = 'Instore' THEN ([Total Amount]) ELSE 0 END) AS Instore_Tot_amt,
	-- Profit from Instore transaction
	SUM(CASE WHEN O.channel = 'Instore' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END) AS Instore_Profit,
	-- Total discount given on Instore channel
	SUM(CASE WHEN O.channel = 'Instore' THEN (O.Discount) ELSE 0 END) AS Tot_Disc_Instore,
	-- Total Product Quantity in Instore Purchase
	SUM(CASE WHEN O.Channel = 'Instore' THEN (O.Quantity) ELSE 0 END) AS Instore_PROD_QTY,
	-- Total DISTINCT Product Quantity in Instore Purchase
	COUNT(DISTINCT CASE WHEN O.Channel = 'Instore' THEN (O.product_id) ELSE NULL END) AS Distinct_PROD_QTY_Instore,
	-- Total DISTINCT Category Quantity in Instore Purchase
	COUNT(DISTINCT CASE WHEN O.Channel = 'Instore' THEN (P.Category) ELSE NULL END) AS Distinct_Cat_QTY_Instore,	
	-- Amount paid using Credit Card in Instore
	SUM(CASE WHEN payment_type = 'Credit_Card' AND O.channel = 'Instore' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Instore_CC_amt,
	-- Amount paid using Debit Card in Instore
	SUM(CASE WHEN payment_type = 'Debit_Card' AND O.channel = 'Instore' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Instore_DC_amt,
	-- Amount paid using UPI/Cash in Instore
	SUM(CASE WHEN payment_type = 'UPI/Cash' AND O.channel = 'Instore' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Instore_UPI_Cash_amt,
	-- Amount paid using Voucher in Instore
	SUM(CASE WHEN payment_type = 'Voucher' AND O.channel = 'Instore' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Instore_Vouch_amt,
    -- Total no of distinct Customers with store via Phone Delivery
	COUNT(CASE WHEN O.channel = 'Phone Delivery' THEN O.Customer_id ELSE NULL END) AS PhoneDel_Cust_count,
	-- Total no. of sale via Phone Delivery
	COUNT(CASE WHEN O.channel = 'Phone Delivery' THEN (O.order_id) ELSE NULL END) AS PhoneDel_Freq,
	-- Total no. of purchase with discount in Phone Delivery Purchase
	COUNT(CASE WHEN O.Channel = 'Phone Delivery' AND O.Discount > 0 THEN (O.order_id) ELSE NULL END) AS Disc_TransCount_PhoneDel,
	-- Phone Delivery monetary value
	SUM(CASE WHEN O.channel = 'Phone Delivery' THEN ([Total Amount]) ELSE 0 END) AS PhoneDel_Tot_amt,
	-- Profit from Phone Delivery transaction
	SUM(CASE WHEN O.channel = 'Phone Delivery' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END) AS PhoneDel_Profit,
	-- Total discount given on Phone Delivery channel
	SUM(CASE WHEN O.channel = 'Phone Delivery' THEN (O.Discount) ELSE 0 END) AS Tot_Disc_PhoneDel,
	-- Total Product Quantity in Phone Delivery Purchase
	SUM(CASE WHEN O.Channel = 'Phone Delivery' THEN (O.Quantity) ELSE 0 END) AS PhoneDel_PROD_QTY,
	-- Total DISTINCT Product Quantity in Phone Delivery Purchase
	COUNT(DISTINCT CASE WHEN O.Channel = 'Phone Delivery' THEN (O.product_id) ELSE NULL END) AS Distinct_PROD_QTY_PhoneDel,
	-- Total DISTINCT Category Quantity in Phone Delivery Purchase
	COUNT(DISTINCT CASE WHEN O.Channel = 'Phone Delivery' THEN (P.Category) ELSE NULL END) AS Distinct_Cat_QTY_PhoneDel,	
	-- Amount paid using Credit Card in Phone Delivery
	SUM(CASE WHEN payment_type = 'Credit_Card' AND O.channel = 'Phone Delivery' THEN ([Total Amount]) ELSE 0 END ) AS PhoneDelivery_CC_amt,
	-- Amount paid using Debit Card in Phone Delivery
	SUM(CASE WHEN payment_type = 'Debit_Card' AND O.channel = 'Phone Delivery' THEN ([Total Amount]) ELSE 0 END ) AS PhoneDelivery_DC_amt,
	-- Amount paid using UPI/Cash in Phone Delivery
	SUM(CASE WHEN payment_type = 'UPI/Cash' AND O.channel = 'Phone Delivery' THEN ([Total Amount]) ELSE 0 END ) AS PhoneDelivery_UPI_Cash_amt,
	-- Amount paid using Voucher in Phone Delivery
	SUM(CASE WHEN payment_type = 'Voucher' AND O.channel = 'Phone Delivery' THEN ([Total Amount]) ELSE 0 END ) AS PhoneDelivery_Vouch_amt,
    -- BABY Category related Information per Customer :
	COUNT(DISTINCT CASE WHEN P.Category = 'Baby' THEN (O.order_id) ELSE NULL END) AS Baby_TransCount,
	COUNT(CASE WHEN P.Category = 'Baby' THEN (O.product_id) ELSE NULL END) AS Baby_Prod_count,
	SUM(CASE WHEN P.Category = 'Baby' THEN ([Total Amount]) ELSE 0 END) AS Baby_Tot_amt,
	SUM(CASE WHEN P.Category = 'Baby' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END) AS Baby_Profit,
	SUM(CASE WHEN P.Category = 'Baby' THEN (O.Discount) ELSE 0 END) AS Tot_Disc_Baby,
	-- AUTO Category-related Information per Store:
	COUNT(DISTINCT CASE WHEN P.Category = 'Auto' THEN (O.order_id) ELSE NULL END) AS Auto_TransCount,
	COUNT(CASE WHEN P.Category = 'Auto' THEN (O.product_id) ELSE NULL END) AS Auto_Prod_count,
	SUM(CASE WHEN P.Category = 'Auto' THEN ([Total Amount]) ELSE 0 END) AS Auto_Tot_amt,
	SUM(CASE WHEN P.Category = 'Auto' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END) AS Auto_Profit,
	SUM(CASE WHEN P.Category = 'Auto' THEN (O.Discount) ELSE 0 END) AS Tot_Disc_Auto,
		-- FASHION Category-related Information per Store:
	COUNT(DISTINCT CASE WHEN P.Category = 'Fashion' THEN (O.order_id) ELSE NULL END) AS Fashion_TransCount,
	COUNT(CASE WHEN P.Category = 'Fashion' THEN (O.product_id) ELSE NULL END) AS Fashion_Prod_count,
	SUM(CASE WHEN P.Category = 'Fashion' THEN ([Total Amount]) ELSE 0 END) AS Fashion_Tot_amt,
	SUM(CASE WHEN P.Category = 'Fashion' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END) AS Fashion_Profit,
	SUM(CASE WHEN P.Category = 'Fashion' THEN (O.Discount) ELSE 0 END) AS Tot_Disc_Fashion,
		-- FOOD & BEVERAGES Category-related Information per Store:
	COUNT(DISTINCT CASE WHEN P.Category = 'Food & Beverages' THEN (O.order_id) ELSE NULL END) AS FoodBev_TransCount,
	COUNT(CASE WHEN P.Category = 'Food & Beverages' THEN (O.product_id) ELSE NULL END) AS FoodBev_Prod_count,
	SUM(CASE WHEN P.Category = 'Food & Beverages' THEN ([Total Amount]) ELSE 0 END) AS FoodBev_Tot_amt,
	SUM(CASE WHEN P.Category = 'Food & Beverages' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END) AS FoodBev_Profit,
	SUM(CASE WHEN P.Category = 'Food & Beverages' THEN (O.Discount) ELSE 0 END) AS Tot_Disc_FoodBev,
		-- FURNITURE Category-related Information per Store:
	COUNT(DISTINCT CASE WHEN P.Category = 'Furniture' THEN (O.order_id) ELSE NULL END) AS Furniture_TransCount,
	COUNT(CASE WHEN P.Category = 'Furniture' THEN (O.product_id) ELSE NULL END) AS Furniture_Prod_count,
	SUM(CASE WHEN P.Category = 'Furniture' THEN ([Total Amount]) ELSE 0 END) AS Furniture_Tot_amt,
	SUM(CASE WHEN P.Category = 'Furniture' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END) AS Furniture_Profit,
	SUM(CASE WHEN P.Category = 'Furniture' THEN (O.Discount) ELSE 0 END) AS Tot_Disc_Furniture,
		-- HOME APPLIANCES Category-related Information per Store:
	COUNT(DISTINCT CASE WHEN P.Category = 'Home_Appliances' THEN (O.order_id) ELSE NULL END) AS HomeApp_Transcount,
	COUNT(CASE WHEN P.Category = 'Home_Appliances' THEN (O.product_id) ELSE NULL END) AS HomeApp_Prod_count,
	SUM(CASE WHEN P.Category = 'Home_Appliances' THEN ([Total Amount]) ELSE 0 END) AS HomeApp_Tot_amt,
	SUM(CASE WHEN P.Category = 'Home_Appliances' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END) AS HomeApp_Profit,
	SUM(CASE WHEN P.Category = 'Home_Appliances' THEN (O.Discount) ELSE 0 END) AS Tot_Disc_HomeApp,
		-- LUGGAGE ACCESSORIES Category-related Information per Store:
	COUNT(DISTINCT CASE WHEN P.Category = 'Luggage_Accessories' THEN (O.order_id) ELSE NULL END) AS Luggage_TransCount,
	COUNT(CASE WHEN P.Category = 'Luggage_Accessories' THEN (O.product_id) ELSE NULL END) AS Luggage_Prod_count,
	SUM(CASE WHEN P.Category = 'Luggage_Accessories' THEN ([Total Amount]) ELSE 0 END) AS Luggage_Tot_amt,
	SUM(CASE WHEN P.Category = 'Luggage_Accessories' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END) AS Luggage_Profit,
	SUM(CASE WHEN P.Category = 'Luggage_Accessories' THEN (O.Discount) ELSE 0 END) AS Tot_Disc_Luggage,
		-- PET SHOP Category-related Information per Store:
	COUNT(DISTINCT CASE WHEN P.Category = 'Pet_Shop' THEN (O.order_id) ELSE NULL END) AS PetShop_TransCount,
	COUNT(CASE WHEN P.Category = 'Pet_Shop' THEN (O.product_id) ELSE NULL END) AS PetShop_Prod_count,
	SUM(CASE WHEN P.Category = 'Pet_Shop' THEN ([Total Amount]) ELSE 0 END) AS PetShop_Tot_amt,
	SUM(CASE WHEN P.Category = 'Pet_Shop' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END) AS PetShop_Profit,
	SUM(CASE WHEN P.Category = 'Pet_Shop' THEN (O.Discount) ELSE 0 END) AS Tot_Disc_PetShop,
		-- STATIONERY Category-related Information per Store:
	COUNT(DISTINCT CASE WHEN P.Category = 'Stationery' THEN (O.order_id) ELSE NULL END) AS Stationery_TransCount,
	COUNT(CASE WHEN P.Category = 'Stationery' THEN (O.product_id) ELSE NULL END) AS Stationery_Prod_count,
	SUM(CASE WHEN P.Category = 'Stationery' THEN ([Total Amount]) ELSE 0 END) AS Stationery_Tot_amt,
	SUM(CASE WHEN P.Category = 'Stationery' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END) AS Stationery_Profit,
	SUM(CASE WHEN P.Category = 'Stationery' THEN (O.Discount) ELSE 0 END) AS Tot_Disc_Stationery,
		-- TOYS & GIFTS Category-related Information per Store:
	COUNT(DISTINCT CASE WHEN P.Category = 'Toys & Gifts' THEN (O.order_id) ELSE NULL END) AS ToysGifts_TransCount,
	COUNT(CASE WHEN P.Category = 'Toys & Gifts' THEN (O.product_id) ELSE NULL END) AS ToysGifts_Prod_count,
	SUM(CASE WHEN P.Category = 'Toys & Gifts' THEN ([Total Amount]) ELSE 0 END) AS ToysGifts_Tot_amt,
	SUM(CASE WHEN P.Category = 'Toys & Gifts' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END) AS ToysGifts_Profit,
	SUM(CASE WHEN P.Category = 'Toys & Gifts' THEN (O.Discount) ELSE 0 END) AS Tot_Disc_ToysGifts,
		-- COMPUTERS & ACCESSORIES Category-related Information per Store:
	COUNT(DISTINCT CASE WHEN P.Category = 'Computers & Accessories' THEN (O.order_id) ELSE NULL END) AS ComputersAcc_TransCount,
	COUNT(CASE WHEN P.Category = 'Computers & Accessories' THEN (O.product_id) ELSE NULL END) AS ComputersAcc_Prod_count,
	SUM(CASE WHEN P.Category = 'Computers & Accessories' THEN ([Total Amount]) ELSE 0 END) AS ComputersAcc_Tot_amt,
	SUM(CASE WHEN P.Category = 'Computers & Accessories' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END) AS ComputersAcc_Profit,
	SUM(CASE WHEN P.Category = 'Computers & Accessories' THEN (O.Discount) ELSE 0 END) AS Tot_Disc_ComputersAcc,
		-- CONSTRUCTION TOOLS Category-related Information per Store:
	COUNT(DISTINCT CASE WHEN P.Category = 'Construction_Tools' THEN (O.order_id) ELSE NULL END) AS ConsTools_TransCount,
	COUNT(CASE WHEN P.Category = 'Construction_Tools' THEN (O.product_id) ELSE NULL END) AS ConsTools_Prod_count,
	SUM(CASE WHEN P.Category = 'Construction_Tools' THEN ([Total Amount]) ELSE 0 END) AS ConsTools_Tot_amt,
	SUM(CASE WHEN P.Category = 'Construction_Tools' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END) AS ConsTools_Profit,
	SUM(CASE WHEN P.Category = 'Construction_Tools' THEN (O.Discount) ELSE 0 END) AS Tot_Disc_ConsTools,
		-- ELECTRONICS Category-related Information per Store:
	COUNT(DISTINCT CASE WHEN P.Category = 'Electronics' THEN (O.order_id) ELSE NULL END) AS Elect_TransCount,
	COUNT(CASE WHEN P.Category = 'Electronics' THEN (O.product_id) ELSE NULL END) AS Elect_Prod_count,
	SUM(CASE WHEN P.Category = 'Electronics' THEN ([Total Amount]) ELSE 0 END) AS Elect_Tot_amt,
	SUM(CASE WHEN P.Category = 'Electronics' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END) AS Elect_Profit,
	SUM(CASE WHEN P.Category = 'Electronics' THEN (O.Discount) ELSE 0 END) AS Tot_Disc_Elect,
		-- UNKNOWN Category-related Information per Store:
	COUNT(DISTINCT CASE WHEN P.Category = '#N/A' THEN (O.order_id) ELSE NULL END) AS Unknown_TransCount,
	COUNT(CASE WHEN P.Category = '#N/A' THEN (O.product_id) ELSE NULL END) AS Unknown_Prod_count,
	SUM(CASE WHEN P.Category = '#N/A' THEN ([Total Amount]) ELSE 0 END) AS Unknown_Tot_amt,
	SUM(CASE WHEN P.Category = '#N/A' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END) AS Unknown_Profit,
	SUM(CASE WHEN P.Category = '#N/A' THEN (O.Discount) ELSE 0 END) AS Tot_Disc_Unknown
	INTO STORE360
FROM 
    ['Stores Info$'] S
INNER JOIN 
    ORDER13 O ON S.StoreID = O.Delivered_StoreID
INNER JOIN 
    ProductsInfo$ P ON O.product_id = P.product_id
INNER JOIN
	Customers$ C ON C.Custid = O.Customer_id
INNER JOIN 
   OrderPayments$ T ON O.order_id = T.order_id
GROUP BY StoreID, seller_city, seller_state, Region
--ORDER BY Frequency DESC
