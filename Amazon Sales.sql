-- Select * from salesdata;

/*checking null values here 
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'salesdata'
AND TABLE_SCHEMA = 'sales'
AND IS_NULLABLE = 'YES'; */    

/*  Add 'monthname' column to analyze sales trends during different times of the day 
ALTER TABLE salesdata ADD COLUMN monthname VARCHAR(10);
UPDATE salesdata SET monthname = UPPER(DATE_FORMAT(date, '%b')); */

/*DESCRIBE salesdata;
ALTER TABLE salesdata
MODIFY COLUMN date DATE; */ -- Changed the data type of date which was earlier into text


/*  Add 'dayname' column to analyze sales trends during different times of the day */ 

/*UPDATE salesdata SET dayname = DAYNAME(date); 
Select * from salesdata;
FROM salesdata;*/

/*DESCRIBE salesdata;
ALTER TABLE salesdata
MODIFY COLUMN Time TIME; */  -- Type of Time column was also in text so I changed it into TIME

/*  Add 'timeofday' column to analyze sales trends during different times of the day 
ALTER TABLE salesdata
ADD COLUMN timeofday VARCHAR(10);

UPDATE salesdata
SET timeofday = 
    CASE
        WHEN HOUR(time) >= 0 AND HOUR(time) < 12 THEN 'Morning'
        WHEN HOUR(time) >= 12 AND HOUR(time) < 18 THEN 'Afternoon'
        ELSE 'Evening'
    END; /*  Add 'timeofday' column to analyze sales trends during different times of the day 
ALTER TABLE salesdata
ADD COLUMN timeofday VARCHAR(10);

UPDATE salesdata
SET timeofday = 
    CASE
        WHEN HOUR(time) >= 0 AND HOUR(time) < 12 THEN 'Morning'
        WHEN HOUR(time) >= 12 AND HOUR(time) < 18 THEN 'Afternoon'
        ELSE 'Evening'
    END; */ 
    
    -- PRODUCT ANALYSIS 
    
-- Analysis of different product lines:

/* SELECT `Product line`, COUNT(*) AS num_sales, SUM(quantity) AS total_quantity, SUM(total) AS total_revenue
FROM salesdata
GROUP BY `Product line`; */

-- Product lines performing best:

/* SELECT `Product line`, SUM(total) AS total_revenue FROM salesdata
GROUP BY `Product line`
ORDER BY total_revenue DESC
LIMIT 3; */

-- Product lines that need improvement (based on threshold or target value):

/* SELECT `Product line`, SUM(total) AS total_revenue FROM salesdata
GROUP BY `Product line`
HAVING total_revenue < 54330
ORDER BY total_revenue
desc; */

-- Product Line Contribution to Total Revenue (%)

/* SELECT `Product line`, (SUM(total) / (SELECT SUM(total) FROM salesdata)) * 100 AS revenue_contribution
FROM salesdata
GROUP BY `Product line`
ORDER BY revenue_contribution DESC; */

-- CUSTOMER ANALYSIS 
-- Different customer segments:

/* SELECT `Customer type`, COUNT(*) AS num_transactions, SUM(total) AS total_revenue
FROM salesdata
GROUP BY `Customer type`; */

-- Purchase Trends Among Customer Segments

/* SELECT monthname, `Customer type`, SUM(total) AS total_revenue
FROM salesdata
GROUP BY monthname, `Customer type`
ORDER BY monthname, total_revenue DESC; */

-- Profitability of each customer segment (based on gross income):

/* SELECT `Customer type`, AVG(`gross income`) AS avg_profit
FROM salesdata
GROUP BY `Customer type`
ORDER BY avg_profit DESC; */ 

-- Purchase frequency of each customer type per month

/* SELECT monthname, `Customer type`, COUNT(*) AS num_purchases
FROM salesdata
GROUP BY monthname, `Customer type`
ORDER BY monthname, num_purchases DESC;  */

-- SALES ANALYSIS 
-- Sales trends of products

/* SELECT monthname, `Product line`, SUM(total) AS total_revenue
FROM salesdata
GROUP BY monthname, `Product line`
ORDER BY monthname, total_revenue DESC; */ 

-- Effectiveness of each sales strategy (based on payment methods)

/* SELECT Payment, SUM(total) AS total_revenue
FROM salesdata
GROUP BY Payment
ORDER BY total_revenue DESC; */

-- Modifications needed for increased sales (identify underperforming product lines):

/* SELECT `Product line`, AVG(total) AS avg_revenue
FROM salesdata
GROUP BY `Product line`
HAVING avg_revenue < (SELECT AVG(total) FROM salesdata)
ORDER BY avg_revenue; */

-- Business Problems 

-- Count of distinct cities in the dataset:

/* SELECT COUNT(DISTINCT city) AS distinct_cities FROM SalesData; */

-- For each branch, corresponding city: used subquery

/* SELECT branch, city
FROM SalesData
WHERE (branch, city) IN (SELECT branch, MAX(city) FROM SalesData GROUP BY branch); */

-- Count of distinct product lines in the dataset:

/* SELECT COUNT(DISTINCT `Product line`) AS distinct_product_lines FROM SalesData; */

-- Which payment method occurs most frequently?
/* SELECT payment, COUNT(*) AS frequency
FROM SalesData
GROUP BY payment
ORDER BY frequency DESC
LIMIT 1; */

-- Which product line has the highest sales?
/* SELECT `Product line`, SUM(total) AS total_sales
FROM SalesData
GROUP BY `Product line`
ORDER BY total_sales DESC
LIMIT 1; */ 

-- How much revenue is generated each month?
/* SELECT monthname, SUM(total) AS monthly_revenue
FROM SalesData
GROUP BY monthname
ORDER BY monthname; */

-- In which month did the cost of goods sold reach its peak?
/* SELECT monthname, MAX(cogs) AS peak_cogs
FROM SalesData
GROUP BY monthname
ORDER BY peak_cogs DESC
LIMIT 1; */

-- Which product line generated the highest revenue?
/* SELECT `Product line`, SUM(total) AS total_revenue
FROM SalesData
GROUP BY `Product line`
ORDER BY total_revenue DESC
LIMIT 1; */

-- In which city was the highest revenue recorded?
/* SELECT city, SUM(total) AS city_revenue
FROM SalesData
GROUP BY city
ORDER BY city_revenue DESC
LIMIT 1; */

-- Which product line incurred the highest Value Added Tax?
/* SELECT `Product line`, MAX(`Tax 5%`) AS highest_VAT
FROM SalesData
GROUP BY `Product line`
ORDER BY highest_VAT DESC
LIMIT 1; */

-- For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
/* ALTER TABLE SalesData ADD COLUMN sales_performance VARCHAR(10);
UPDATE SalesData sd
INNER JOIN (
    SELECT `Product line`, AVG(total) AS avg_sales
    FROM SalesData
    GROUP BY `Product line`
) AS avg_data ON sd.`Product line` = avg_data.`Product line`
SET sd.sales_performance = CASE
    WHEN sd.total > avg_data.avg_sales THEN 'Good'
    ELSE 'Bad'
END; */

-- Identify the branch that exceeded the average number of products sold.
/* SELECT branch, AVG(quantity) AS avg_quantity
FROM SalesData
GROUP BY branch
HAVING avg_quantity > (SELECT AVG(quantity) FROM SalesData); */

-- Which product line is most frequently associated with each gender?
/* SELECT gender, `Product line`, COUNT(*) AS frequency
FROM SalesData
GROUP BY gender, `Product line`
ORDER BY frequency DESC; */ 

-- Calculate the average rating for each product line.
/* SELECT `Product line`, AVG(rating) AS avg_rating
FROM SalesData
GROUP BY `Product line`
ORDER BY avg_rating DESC; */

-- Count the sales occurrences for each time of day on every weekday.
/* SELECT dayname, timeofday, COUNT(*) AS sales_occurrences
FROM SalesData
GROUP BY dayname, timeofday
ORDER BY dayname, timeofday; */

-- Identify the customer type contributing the highest revenue.
/* SELECT `Customer type`, SUM(total) AS revenue_contribution
FROM SalesData
GROUP BY `Customer type`
ORDER BY revenue_contribution DESC
LIMIT 1; */

-- Determine the city with the highest VAT percentage.
/* SELECT city, (SUM(`Tax 5%`) / SUM(total)) * 100 AS VAT_percentage
FROM SalesData
GROUP BY city
ORDER BY VAT_percentage DESC
LIMIT 1;  */

-- Identify the customer type with the highest VAT payments.
/* SELECT `Customer type`, SUM(`Tax 5%`) AS total_VAT_payments
FROM SalesData
GROUP BY `Customer type`
ORDER BY total_VAT_payments DESC
LIMIT 1; */

-- What is the count of distinct customer types in the dataset?
/* SELECT COUNT(DISTINCT `Customer type`) AS distinct_customer_types FROM SalesData; */

-- What is the count of distinct payment methods in the dataset?
/* SELECT COUNT(DISTINCT payment) AS distinct_payment_methods FROM SalesData; */

-- Which customer type occurs most frequently?
/* SELECT `Customer type`, COUNT(*) AS frequency
FROM SalesData
GROUP BY `Customer type`
ORDER BY frequency DESC
LIMIT 1; */

-- Identify the customer type with the highest purchase frequency.
/* SELECT `Customer type`, COUNT(*) AS purchase_frequency
FROM SalesData
GROUP BY `Customer type`
ORDER BY purchase_frequency DESC
LIMIT 1; */

-- Determine the predominant gender among customers.
/* SELECT gender, COUNT(*) AS customer_count
FROM SalesData
GROUP BY gender
ORDER BY customer_count DESC
LIMIT 1; */

-- Examine the distribution of genders within each branch.
/* SELECT branch, gender, COUNT(*) AS gender_count
FROM SalesData
GROUP BY branch, gender
ORDER BY branch, gender; */

-- Identify the time of day when customers provide the most ratings.
/* SELECT timeofday, COUNT(*) AS rating_count
FROM SalesData
WHERE rating IS NOT NULL
GROUP BY timeofday
ORDER BY rating_count DESC
LIMIT 1; */

-- Determine the time of day with the highest customer ratings for each branch.
/* SELECT branch, timeofday, MAX(rating) AS highest_rating
FROM SalesData
WHERE rating IS NOT NULL
GROUP BY branch, timeofday
ORDER BY branch; */

-- Identify the day of the week with the highest average ratings.
/* SELECT dayname, AVG(rating) AS avg_rating
FROM SalesData
WHERE rating IS NOT NULL
GROUP BY dayname
ORDER BY avg_rating DESC
LIMIT 1; */

-- Determine the day of the week with the highest average rsalesdataatings for each branch.
/* SELECT branch, dayname, AVG(rating) AS avg_rating
FROM SalesData
WHERE rating IS NOT NULL
GROUP BY branch, dayname
ORDER BY branch, avg_rating DESC; */

SELECT `Customer type`, COUNT(*) AS `Customer Count`
FROM salesdata
GROUP BY `Customer type`;































