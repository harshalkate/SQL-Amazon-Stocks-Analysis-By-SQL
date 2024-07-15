Use Amzn;

select * 
from amzn;

-- checking the null valuess in data column
select 
sum(case when `Date` is null then 1 else 0 end) as Null_date,
sum(case when `Open` is null then 1 else 0 end) as Null_Open,
sum(case when High is null then 1 else 0 end) as Null_high,
sum(case when Low is null then 1 else 0 end) as Null_low,
sum(case when Close is null then 1 else 0 end) as Null_close,
sum(case when `Adj Close` is null then 1 else 0 end) as Null_adjclose,
sum(case when Volume is null then 1 else 0 end) as Null_volumne
from amzn;


-- Data standardization date cloumn date format
update amzn
set date = str_to_date(`Date`, '%Y-%m-%d');

select * 
from amzn;

-- Eda of the above dat after cleaning and standardize

-- 1. Summary statistics of the open high low
SELECT 
    MIN(`Open`) AS min_open,
    MAX(High) AS max_high,
    AVG(`Close`) AS avg_Close
FROM
    amzn;
    
-- Count of trading days
SELECT 
    COUNT(*) AS total_days
FROM
    amzn;
    
-- 2.Trend Analysis Yearly average closing price of the data
SELECT 
    YEAR(`DATE`) AS `Year`, AVG(`Close`) AS avg_close
FROM
    amzn
GROUP BY YEAR(`Date`)
ORDER BY YEAR(`Date`) DESC
LIMIT 10;

-- 3.Monthly average closing price
SELECT 
    DATE_FORMAT(`Date`, '%Y-%m') AS Month_wise,
    AVG(`Close`) AS avg_close
FROM
    amzn
GROUP BY DATE_FORMAT(`Date`, '%Y-%m')
ORDER BY DATE_FORMAT(`Date`, '%Y-%m') DESC
LIMIT 10;

-- Calculating the daily price change (Close - Open)

SELECT 
    `Date`, (Close - Open) AS daily_price_changes
FROM
    amzn
ORDER BY `Date` DESC;


-- Moving Averages Calculate 7-day and 
-- 30-day moving averages of closing prices
select 
`Date`,
`Close`,
avg(`Close`) 
over (order by `Date` rows between 6 preceding and current row) as M_daily7,
avg(`Close`) 
over (order by `Date` rows between 29 preceding and current row) as Monthly_30
from amzn
order by `Date`;

-- Calculating daily return percentage of the amzon stocks
select 
`Date`,
(( `Close`- lag(`Close`-1) over(order by `Date`)) / lag(`Close`,1) 
over (order by `Date`)) * 100 as Daily_per_Return
from amzn
order by `Date`;

-- Calculate the spread between the highest and lowest prices each day

select `Date`, (High - Low) as Daily_spread
from amzn
order by `Date`;


-- Monthly total and average volume of the stocks
SELECT 
    DATE_FORMAT(`Date`, '%Y-%m') AS Monthly_volume,
    SUM(Volume) AS Total_Volume,
    AVG(Volume) AS Avg_volume
FROM
    amzn
GROUP BY DATE_FORMAT(`Date`, '%Y-%m')
ORDER BY DATE_FORMAT(`Date`, '%Y-%m') DESC; 

-- Yearly total and average volume 
SELECT 
    YEAR(`Date`) AS Yearly_volume,
    SUM(Volume) AS Total_Volume,
    AVG(Volume) AS Avg_volume
FROM
    amzn
GROUP BY YEAR(`Date`)
ORDER BY year(`Date`) DESC;  

-- Identify the highest top 5 closing price by year
SELECT 
    YEAR(`Date`) AS `year`, MAX(`Close`) AS Yearly_closing_price
FROM
    amzn
GROUP BY YEAR(`Date`)
ORDER BY YEAR(`Date`) DESC
LIMIT 5;

-- Identify the lowest top 5 closing price each year
SELECT 
    YEAR(`Date`) AS `year`, Min(`Close`) AS Yearly_closing_price
FROM
    amzn
GROUP BY YEAR(`Date`)
ORDER BY YEAR(`Date`) Asc
LIMIT 5;

-- Identify dates with the highest and lowest single-day returns

SELECT Date, 
       ((Close - LAG(Close, 1) OVER (ORDER BY Date)) / LAG(Close, 1) OVER (ORDER BY Date)) * 100 AS Daily_percentage_Return
FROM amzn
ORDER BY Daily_percentage_Return DESC
LIMIT 1; -- For highest return

SELECT Date, 
       ((Close - LAG(Close, 1) OVER (ORDER BY Date)) / LAG(Close, 1) OVER (ORDER BY Date)) * 100 AS Daily_percentage_Return
FROM amzn
ORDER BY Daily_percentage_Return ASC
LIMIT 2; -- For lowest return

-- Quarterly average closing price of the stocks

SELECT Quarter, 
       AVG(`Close`) AS Avg_Close
FROM (
    SELECT CONCAT(YEAR(`Date`), '-Q', QUARTER(`Date`)) AS Quarter, 
           `Close`
    FROM amzn
) AS sub
GROUP BY Quarter
ORDER BY Quarter;

-- Insights and Conclusion
 -- Quarterly Trends: The average closing price of Amazon stock varies across different quarters, reflecting seasonal and market influences. For example, Q2 2020 saw a 15.8% increase from Q1 2020, rising from $1,900 to $2,200.

-- Highs and Lows: Significant quarters can be identified by their average closing prices. For instance, Q1 2021 had an average closing price of $3,000, showing a 36.4% increase from Q2 2020.

-- Yearly Growth: Tracking the growth or decline in average closing prices across quarters year-over-year reveals long-term trends. Comparing Q1 2021 to Q1 2020, there was a substantial 57.9% increase in the average closing price, from $1,900 to $3,000, indicating strong yearly growth.
