SELECT C.*,MIN(Bill_Date) [FIRST TRANS DATE],MAX(Bill_Date) [LAST TRANS DATE], DATEDIFF(DAY, MIN(Bill_Date),MAX(Bill_Date)) [TENURE(DAYS)], 
	DATEDIFF(DAY, MAX(Bill_Date),(SELECT MAX(Bill_Date) FROM TEMP)) [INACTIVE DAYS], count(distinct O.order_id) [No. of Trans], 
	COUNT(DISTINCT Channel) [Channels count], SUM([Total Amount]) [Total amount spent] ,
	ROUND(SUM([Total Amount])-SUM(QUANTITY*[Cost Per Unit]),2) [Total Profit], SUM(Discount) [Total Discount],
	SUM(Quantity) [Total Quantity], COUNT(DISTINCT O.product_id) [Distinct Prod_count], COUNT(DISTINCT Category) [Distinct category],
	COUNT(DISTINCT Delivered_StoreID) [Store_id count], COUNT(DISTINCT seller_city) [Cities_count],
	COUNT(CASE WHEN O.Discount > 0 THEN (O.order_id) ELSE NULL END) [Discount Trans_count],
	COUNT(DISTINCT payment_type) [Pay_TYPE COUNT],
	SUM(CASE WHEN payment_type = 'Credit_Card' THEN ([Total Amount]) ELSE 0 END )  CC_amt,
	SUM(CASE WHEN payment_type = 'Debit_Card' THEN ([Total Amount]) ELSE 0 END )  DC_amt,
	SUM(CASE WHEN payment_type = 'UPI/Cash' THEN ([Total Amount]) ELSE 0 END )  UPI_Cash_amt,
	SUM(CASE WHEN payment_type = 'Voucher' THEN ([Total Amount]) ELSE 0 END )  Voucher_amt,
	COUNT(DISTINCT CASE WHEN O.channel = 'Instore' THEN (O.order_id) ELSE NULL END)  Instore_Freq,
	SUM(CASE WHEN O.channel = 'Instore' THEN ([Total Amount]) ELSE 0 END)  Instore_Tot_amt,
	ROUND(SUM(CASE WHEN O.channel = 'Instore' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END),2) Instore_Profit,
	SUM(CASE WHEN O.channel = 'Instore' THEN Discount ELSE 0 END) Instore_Discount,
	SUM(CASE WHEN O.Channel = 'Instore' THEN (Quantity) ELSE 0 END) Instore_Qty,
	COUNT(DISTINCT CASE WHEN O.Channel = 'Instore' THEN (O.product_id) ELSE NULL END) Instore_Distinct_Prod,
	COUNT(DISTINCT CASE WHEN O.Channel = 'Instore' THEN (P.Category) ELSE NULL END) Instore_Distinct_Category,
	COUNT(CASE WHEN O.Channel = 'Instore' AND O.Discount > 0 THEN (O.order_id) ELSE NULL END) Instore_Discount_Count,
	COUNT(DISTINCT CASE WHEN O.Channel = 'Instore' THEN (O.Delivered_StoreID) ELSE NULL END) Instore_Distinct_Stores,
	COUNT(DISTINCT CASE WHEN O.Channel = 'Instore' THEN (seller_city) ELSE NULL END) Instore_Distinct_Cities,
	COUNT(DISTINCT CASE WHEN O.Channel = 'Instore' THEN (payment_type) ELSE NULL END) Instore_Distinct_PayType,
	SUM(CASE WHEN payment_type = 'Credit_Card' AND O.channel = 'Instore' THEN ([Total Amount]) ELSE 0 END ) Instore_CC_amt,
	SUM(CASE WHEN payment_type = 'Debit_Card' AND O.channel = 'Instore' THEN ([Total Amount]) ELSE 0 END ) Instore_DC_amt,
	SUM(CASE WHEN payment_type = 'UPI/Cash' AND O.channel = 'Instore' THEN ([Total Amount]) ELSE 0 END ) Instore_UPI_Cash_amt,
    SUM(CASE WHEN payment_type = 'Voucher' AND O.channel = 'Instore' THEN ([Total Amount]) ELSE 0 END ) Instore_Vouch_amt,
	COUNT(DISTINCT CASE WHEN O.channel = 'Phone Delivery' THEN (O.order_id) ELSE NULL END)  PhoneDelivery_Freq,
	SUM(CASE WHEN O.channel = 'Phone Delivery' THEN ([Total Amount]) ELSE 0 END)  PhoneDelivery_Tot_amt,
	ROUND(SUM(CASE WHEN O.channel = 'Phone Delivery' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END),2) PhoneDelivery_Profit,
	SUM(CASE WHEN O.channel = 'Phone Delivery' THEN Discount ELSE 0 END) PhoneDelivery_Discount,
	SUM(CASE WHEN O.Channel = 'Phone Delivery' THEN (Quantity) ELSE 0 END) PhoneDelivery_Qty,
	COUNT(DISTINCT CASE WHEN O.Channel = 'Phone Delivery' THEN (O.product_id) ELSE NULL END) PhoneDelivery_Distinct_Prod,
	COUNT(DISTINCT CASE WHEN O.Channel = 'Phone Delivery' THEN (P.Category) ELSE NULL END) PhoneDelivery_Distinct_Category,
	COUNT(CASE WHEN O.Channel = 'Phone Delivery' AND O.Discount > 0 THEN (O.order_id) ELSE NULL END) PhoneDelivery_Discount_Count,
	COUNT(DISTINCT CASE WHEN O.Channel = 'Phone Delivery' THEN (O.Delivered_StoreID) ELSE NULL END) PhoneDelivery_Distinct_Stores,
	COUNT(DISTINCT CASE WHEN O.Channel = 'Phone Delivery' THEN (seller_city) ELSE NULL END) PhoneDelivery_Distinct_Cities,
	COUNT(DISTINCT CASE WHEN O.Channel = 'Phone Delivery' THEN (payment_type) ELSE NULL END) PhoneDelivery_Distinct_PayType,
	SUM(CASE WHEN payment_type = 'Credit_Card' AND O.channel = 'Phone Delivery' THEN ([Total Amount]) ELSE 0 END ) PhoneDelivery_CC_amt,
	SUM(CASE WHEN payment_type = 'Debit_Card' AND O.channel = 'Phone Delivery' THEN ([Total Amount]) ELSE 0 END ) PhoneDelivery_DC_amt,
	SUM(CASE WHEN payment_type = 'UPI/Cash' AND O.channel = 'Phone Delivery' THEN ([Total Amount]) ELSE 0 END ) PhoneDelivery_UPI_Cash_amt,
    SUM(CASE WHEN payment_type = 'Voucher' AND O.channel = 'Phone Delivery' THEN ([Total Amount]) ELSE 0 END ) PhoneDelivery_Vouch_amt,
	COUNT(DISTINCT CASE WHEN O.channel = 'Online' THEN (O.order_id) ELSE NULL END)  Online_Freq,
	SUM(CASE WHEN O.channel = 'Online' THEN ([Total Amount]) ELSE 0 END)  Online_Tot_amt,
	ROUND(SUM(CASE WHEN O.channel = 'Online' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END),2) Online_Profit,
	SUM(CASE WHEN O.channel = 'Online' THEN Discount ELSE 0 END) Online_Discount,
	SUM(CASE WHEN O.Channel = 'Online' THEN (Quantity) ELSE 0 END) Online_Qty,
	COUNT(DISTINCT CASE WHEN O.Channel = 'Online' THEN (O.product_id) ELSE NULL END) Online_Distinct_Prod,
	COUNT(DISTINCT CASE WHEN O.Channel = 'Online' THEN (P.Category) ELSE NULL END) Online_Distinct_Category,
	COUNT(CASE WHEN O.Channel = 'Online' AND O.Discount > 0 THEN (O.order_id) ELSE NULL END) Online_Discount_Count,
	COUNT(DISTINCT CASE WHEN O.Channel = 'Online' THEN (O.Delivered_StoreID) ELSE NULL END) Online_Distinct_Stores,
	COUNT(DISTINCT CASE WHEN O.Channel = 'Online' THEN (seller_city) ELSE NULL END) Online_Distinct_Cities,
	COUNT(DISTINCT CASE WHEN O.Channel = 'Online' THEN (payment_type) ELSE NULL END) Online_Distinct_PayType,
	SUM(CASE WHEN payment_type = 'Credit_Card' AND O.channel = 'Online' THEN ([Total Amount]) ELSE 0 END ) Online_CC_amt,
	SUM(CASE WHEN payment_type = 'Debit_Card' AND O.channel = 'Online' THEN ([Total Amount]) ELSE 0 END ) Online_DC_amt,
	SUM(CASE WHEN payment_type = 'UPI/Cash' AND O.channel = 'Online' THEN ([Total Amount]) ELSE 0 END ) Online_UPI_Cash_amt,
    SUM(CASE WHEN payment_type = 'Voucher' AND O.channel = 'Online' THEN ([Total Amount]) ELSE 0 END ) Online_Vouch_amt,
	COUNT(DISTINCT CASE WHEN P.Category = 'Auto' THEN (O.order_id) ELSE NULL END) Auto_Trans,
	COUNT(CASE WHEN P.Category = 'Auto' THEN (O.product_id) ELSE NULL END) Auto_Prod_count,
	SUM(CASE WHEN P.Category = 'Auto' THEN ([Total Amount]) ELSE 0 END) Auto_Tot_amt,
	ROUND(SUM(CASE WHEN P.Category = 'Auto' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END),2) Auto_Profit,
	SUM(CASE WHEN P.Category = 'Auto' THEN (O.Discount) ELSE 0 END) Auto_Discount,
	SUM(CASE WHEN P.Category = 'Auto' THEN (QUANTITY) ELSE 0 END) Auto_Qty,
	COUNT(DISTINCT CASE WHEN P.Category = 'Baby' THEN (O.order_id) ELSE NULL END) Baby_Trans,
	COUNT(CASE WHEN P.Category = 'Baby' THEN (O.product_id) ELSE NULL END) Baby_Prod_count,
	SUM(CASE WHEN P.Category = 'Baby' THEN ([Total Amount]) ELSE 0 END) Baby_Tot_amt,
	ROUND(SUM(CASE WHEN P.Category = 'Baby' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END),2) Baby_Profit,
	SUM(CASE WHEN P.Category = 'Baby' THEN (O.Discount) ELSE 0 END) Baby_Discount,
	SUM(CASE WHEN P.Category = 'Baby' THEN (QUANTITY) ELSE 0 END) Baby_Qty,
	COUNT(DISTINCT CASE WHEN P.Category = 'Computers & Accessories' THEN (O.order_id) ELSE NULL END) ComputerAcs_Trans,
	COUNT(CASE WHEN P.Category = 'Computers & Accessories' THEN (O.product_id) ELSE NULL END) ComputerAcs_Prod_count,
	SUM(CASE WHEN P.Category = 'Computers & Accessories' THEN ([Total Amount]) ELSE 0 END) ComputerAcs_Tot_amt,
	ROUND(SUM(CASE WHEN P.Category = 'Computers & Accessories' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END),2) ComputerAcs_Profit,
	SUM(CASE WHEN P.Category = 'Computers & Accessories' THEN (O.Discount) ELSE 0 END) ComputerAcs_Discount,
	SUM(CASE WHEN P.Category = 'Computers & Accessories' THEN (QUANTITY) ELSE 0 END) ComputerAcs_Qty,
	COUNT(DISTINCT CASE WHEN P.Category = 'Construction_Tools' THEN (O.order_id) ELSE NULL END) ConsTools_Trans,
	COUNT(CASE WHEN P.Category = 'Construction_Tools' THEN (O.product_id) ELSE NULL END) ConsTools_Prod_count,
	SUM(CASE WHEN P.Category = 'Construction_Tools' THEN ([Total Amount]) ELSE 0 END) ConsTools_Tot_amt,
	ROUND(SUM(CASE WHEN P.Category = 'Construction_Tools' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END),2) ConsTools_Profit,
	SUM(CASE WHEN P.Category = 'Construction_Tools' THEN (O.Discount) ELSE 0 END) ConsTools_Discount,
	SUM(CASE WHEN P.Category = 'Construction_Tools' THEN (QUANTITY) ELSE 0 END) ConsTools_Qty,
	COUNT(DISTINCT CASE WHEN P.Category = 'Electronics' THEN (O.order_id) ELSE NULL END) Elect_Trans,
	COUNT(CASE WHEN P.Category = 'Electronics' THEN (O.product_id) ELSE NULL END) Elect_Prod_count,
	SUM(CASE WHEN P.Category = 'Electronics' THEN ([Total Amount]) ELSE 0 END) Elect_Tot_amt,
	ROUND(SUM(CASE WHEN P.Category = 'Electronics' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END),2) Elect_Profit,
	SUM(CASE WHEN P.Category = 'Electronics' THEN (O.Discount) ELSE 0 END) Elect_Discount,
	SUM(CASE WHEN P.Category = 'Electronics' THEN (QUANTITY) ELSE 0 END) Elect_Qty,
	COUNT(DISTINCT CASE WHEN P.Category = 'Fashion' THEN (O.order_id) ELSE NULL END) Fashion_Trans,
	COUNT(CASE WHEN P.Category = 'Fashion' THEN (O.product_id) ELSE NULL END) Fashion_Prod_count,
	SUM(CASE WHEN P.Category = 'Fashion' THEN ([Total Amount]) ELSE 0 END) Fashion_Tot_amt,
	ROUND(SUM(CASE WHEN P.Category = 'Fashion' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END),2) Fashion_Profit,
	SUM(CASE WHEN P.Category = 'Fashion' THEN (O.Discount) ELSE 0 END) Fashion_Discount,
	SUM(CASE WHEN P.Category = 'Fashion' THEN (QUANTITY) ELSE 0 END) Fashion_Qty,
	COUNT(DISTINCT CASE WHEN P.Category = 'Food & Beverages' THEN (O.order_id) ELSE NULL END) FoodBev_Trans,
	COUNT(CASE WHEN P.Category = 'Food & Beverages' THEN (O.product_id) ELSE NULL END) FoodBev_Prod_count,
	SUM(CASE WHEN P.Category = 'Food & Beverages' THEN ([Total Amount]) ELSE 0 END) FoodBev_Tot_amt,
	ROUND(SUM(CASE WHEN P.Category = 'Food & Beverages' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END),2) FoodBev_Profit,
	SUM(CASE WHEN P.Category = 'Food & Beverages' THEN (O.Discount) ELSE 0 END) FoodBev_Discount,
	SUM(CASE WHEN P.Category = 'Food & Beverages' THEN (QUANTITY) ELSE 0 END) FoodBev_Qty,
	COUNT(DISTINCT CASE WHEN P.Category = 'Furniture' THEN (O.order_id) ELSE NULL END) Furniture_Trans,
	COUNT(CASE WHEN P.Category = 'Furniture' THEN (O.product_id) ELSE NULL END) Furniture_Prod_count,
	SUM(CASE WHEN P.Category = 'Furniture' THEN ([Total Amount]) ELSE 0 END) Furniture_Tot_amt,
	ROUND(SUM(CASE WHEN P.Category = 'Furniture' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END),2) Furniture_Profit,
	SUM(CASE WHEN P.Category = 'Furniture' THEN (O.Discount) ELSE 0 END) Furniture_Discount,
	SUM(CASE WHEN P.Category = 'Furniture' THEN (QUANTITY) ELSE 0 END) Furniture_Qty,
	COUNT(DISTINCT CASE WHEN P.Category = 'Home_Appliances' THEN (O.order_id) ELSE NULL END) HomeApp_Trans,
	COUNT(CASE WHEN P.Category = 'Home_Appliances' THEN (O.product_id) ELSE NULL END) HomeApp_Prod_count,
	SUM(CASE WHEN P.Category = 'Home_Appliances' THEN ([Total Amount]) ELSE 0 END) HomeApp_Tot_amt,
	ROUND(SUM(CASE WHEN P.Category = 'Home_Appliances' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END),2) HomeApp_Profit,
	SUM(CASE WHEN P.Category = 'Home_Appliances' THEN (O.Discount) ELSE 0 END) HomeApp_Discount,
	SUM(CASE WHEN P.Category = 'Home_Appliances' THEN (QUANTITY) ELSE 0 END) HomeApp_Qty,
	COUNT(DISTINCT CASE WHEN P.Category = 'Luggage_Accessories' THEN (O.order_id) ELSE NULL END) Luggage_Trans,
	COUNT(CASE WHEN P.Category = 'Luggage_Accessories' THEN (O.product_id) ELSE NULL END) Luggage_Prod_count,
	SUM(CASE WHEN P.Category = 'Luggage_Accessories' THEN ([Total Amount]) ELSE 0 END) Luggage_Tot_amt,
	ROUND(SUM(CASE WHEN P.Category = 'Luggage_Accessories' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END),2) Luggage_Profit,
	SUM(CASE WHEN P.Category = 'Luggage_Accessories' THEN (O.Discount) ELSE 0 END) Luggage_Discount,
	SUM(CASE WHEN P.Category = 'Luggage_Accessories' THEN (QUANTITY) ELSE 0 END) Luggage_Qty,
	COUNT(DISTINCT CASE WHEN P.Category = 'Pet_Shop' THEN (O.order_id) ELSE NULL END) PetShop_Trans,
	COUNT(CASE WHEN P.Category = 'Pet_Shop' THEN (O.product_id) ELSE NULL END) PetShop_Prod_count,
	SUM(CASE WHEN P.Category = 'Pet_Shop' THEN ([Total Amount]) ELSE 0 END) PetShop_Tot_amt,
	ROUND(SUM(CASE WHEN P.Category = 'Pet_Shop' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END),2) PetShop_Profit,
	SUM(CASE WHEN P.Category = 'Pet_Shop' THEN (O.Discount) ELSE 0 END) PetShop_Discount,
	SUM(CASE WHEN P.Category = 'Pet_Shop' THEN (QUANTITY) ELSE 0 END) PetShop_Qty,
	COUNT(DISTINCT CASE WHEN P.Category = 'Stationery' THEN (O.order_id) ELSE NULL END) Stationery_Trans,
	COUNT(CASE WHEN P.Category = 'Stationery' THEN (O.product_id) ELSE NULL END) Stationery_Prod_count,
	SUM(CASE WHEN P.Category = 'Stationery' THEN ([Total Amount]) ELSE 0 END) Stationery_Tot_amt,
	ROUND(SUM(CASE WHEN P.Category = 'Stationery' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END),2) Stationery_Profit,
	SUM(CASE WHEN P.Category = 'Stationery' THEN (O.Discount) ELSE 0 END) Stationery_Discount,
	SUM(CASE WHEN P.Category = 'Stationery' THEN (QUANTITY) ELSE 0 END) Stationery_Qty,
	COUNT(DISTINCT CASE WHEN P.Category = 'Toys & Gifts' THEN (O.order_id) ELSE NULL END) ToysGifts_Trans,
	COUNT(CASE WHEN P.Category = 'Toys & Gifts' THEN (O.product_id) ELSE NULL END) ToysGifts_Prod_count,
	SUM(CASE WHEN P.Category = 'Toys & Gifts' THEN ([Total Amount]) ELSE 0 END) ToysGifts_Tot_amt,
	ROUND(SUM(CASE WHEN P.Category = 'Toys & Gifts' THEN ([Total Amount]) - (O.Quantity * [Cost Per Unit]) ELSE 0 END),2) ToysGifts_Profit,
	SUM(CASE WHEN P.Category = 'Toys & Gifts' THEN (O.Discount) ELSE 0 END) ToysGifts_Discount,
	SUM(CASE WHEN P.Category = 'Toys & Gifts' THEN (QUANTITY) ELSE 0 END) ToysGifts_Qty,
	CASE 
        WHEN SUM([Total Amount]) > 9018 THEN 'High spender'
        WHEN SUM([Total Amount]) <= 9018 AND SUM([Total Amount]) >= 4509 THEN 'Medium spender'
        ELSE 'Low spender'
    END Customer_Segment
	INTO CUSTOMER360
	
FROM Customers$ C
JOIN ORDER13 O ON C.Custid=O.Customer_id
JOIN ProductsInfo$ P ON O.product_id=P.product_id
JOIN OrderPayments$ I ON O.order_id=I.order_id
JOIN ['Stores Info$'] S ON O.Delivered_StoreID=S.StoreID
GROUP BY Custid,customer_city,customer_state,Gender 
