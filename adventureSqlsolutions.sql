select * from dimproduct;
select * from fact_sales_union;
select * from dimcustomer;
drop table dimproduct;

-- Lookup  (1 & 2)
SELECT s.*, p.ProductName as productname, c.CustomerFullName AS CustomerFullName, p.Unitprice as UnitPrice
FROM fact_sales_union AS s
JOIN dimproduct AS p
ON s.ProductKey = p.ProductKey
JOIN dimcustomer AS c
on s.CustomerKey = c.CustomerKey;

-- Date functions Q3

SELECT orderdate,
    YEAR(orderdate) AS Year,                          -- Extract the year
    MONTH(orderdate) AS MonthNo,                      -- Extract the month number (1-12)
    DATE_FORMAT(orderdate, '%M') AS MonthFullName,    -- Get the full name of the month
    QUARTER(orderdate) AS Quarter,                   -- Get the quarter (1-4)
    DATE_FORMAT(orderdate, '%Y-%b') AS YearMonth,     -- Format as 'YYYY-MMM' (e.g., 2023-Nov)
    WEEKDAY(orderdate) + 1 AS WeekdayNo,              -- Get weekday number (Monday=1 to Sunday=7)
    DAYNAME(orderdate) AS WeekdayName,                -- Get the full name of the weekday
    CASE 
        WHEN MONTH(orderdate) >= 7 THEN MONTH(orderdate) - 6  -- Adjust for financial month starting in July
        ELSE MONTH(orderdate) + 6
    END AS FinancialMonth,
    CASE 
        WHEN MONTH(orderdate) >= 7 THEN FLOOR((MONTH(orderdate) - 7) / 3) + 1  -- Adjust for financial quarter
        ELSE FLOOR((MONTH(orderdate) + 5) / 3) + 1
    END AS FinancialQuarter
FROM fact_sales_union;

	-- Sales Amount (4,5,6)
    
    select * from fact_sales_union;
    
    select ProductKey, UnitPrice, OrderQuantity, 
			UnitPriceDiscountPct, ProductStandardCost,
            ((UnitPrice*OrderQuantity) - (OrderQuantity*UnitPriceDiscountPct)) as SalesAmount,
            (ProductStandardCost*OrderQuantity) as ProductionCost,
            ((UnitPrice*OrderQuantity) - (OrderQuantity*UnitPriceDiscountPct)) - (ProductStandardCost*OrderQuantity) as Profit
    from fact_sales_union;
    
    --  Yearwise monthwise sales (7,8,9,10,11)
    
    select * from fact_sales_union;
    
    select 	year(orderdate) as Year_sales, 
			monthname(orderdate) as Month_sales,
            sum(salesAmount) as sales
	from fact_sales_union
    group by year(orderdate),month(orderdate), monthname(orderdate)
    order by year(orderdate), month(orderdate);
    
    -- Yearwise sales
    
    select year(orderdate) as Year,
			sum(salesAmount) as sales
	from fact_sales_union
    group by year(orderdate)
    order by year(orderdate);
    
    -- Monthwise Sales
    
	select monthname(orderdate) as month,
			sum(salesAmount) as sales
	from fact_sales_union
    group by month(orderdate), monthname(orderdate)
    order by month(orderdate);
    
    -- QuarterWise Sales
    
	select QUARTER(orderdate) as Quarter,
			sum(salesAmount) as sales
	from fact_sales_union
    group by Quarter(orderdate)
    order by Quarter(orderdate);
    
    -- Yearwise Sales and Production Cost
    
    select year(orderdate) as Year,
			SUM(Totalproductcost) as Production_cost,
            SUM(Salesamount) as Sales_cost
	from fact_sales_union
    group by year(orderdate)
    order by year(orderdate);
    
    