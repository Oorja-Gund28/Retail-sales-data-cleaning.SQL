# Retail Sales Data Analysis (SQL)

## Business Context

The client is one of the leading retail chains in India and would like to partner with Analytixlabs to provide data-driven insights from the point of sales data to define CRM/marketing/campaign/sales strategies going forward.  
The client also wants help in measuring, managing, and analyzing the performance of the business.  

Analytixlabs has hired you as an analyst for this project where the client asked you to provide data-driven insights about business and understand customer behaviors, product behavior, store behavior, channel behavior, etc.  

As part of the analytics team, you are required to support clients with key metrics and different types of analysis, including:  
- Product analysis  
- Product category analysis  
- Customer category analysis  
- Customer segment analysis  
- Sales patterns and trends  
- Seasonality impact on sales  
- Cross selling  
- Customer satisfaction  
- Cohort analysis  
- Store-level analysis  

The goal is to understand category performance and define a strategy to increase sales for the upcoming year.

---

## Available Data

- Data has been provided from **Sep 2021 to Oct 2023** for randomly selected **39 stores out of 535 stores**, for specific categories of products, and randomly selected customers.
- No data dictionary is provided, as all the variables are intuitive.  
- For any clarifications, please send an email to your POC.  

**Note:**  
- Ideal relationship between the tables:  
  - One customer can have multiple `Order_ID`s.  
  - One `Order_ID` can have multiple items.

---

## Expectations

- Import all the data (6 files) into any RDBMS system (**SQL Server**, **MySQL**, etc.).
- Perform **data auditing** and **data cleaning** (if required) in SQL.
- List down your observations related to data-related issues.
- Process your data based on the assumptions you can make.

Also:  
- Create the following **3 tables** (with maximum possible variables) after cleaning the data:
  1. **Customer-level table**: One record for each customer.  
  2. **Order-level table**: One record for each order.  
  3. **Store-level table**: One record for each store.  

These tables can then be leveraged in the analysis wherever needed.
