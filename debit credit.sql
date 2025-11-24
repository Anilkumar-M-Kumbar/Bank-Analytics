select *
from banking_data;
-- 1. Standardize transaction types
UPDATE banking_data
SET `Transaction Type` = CASE
    WHEN LOWER(`Transaction Type`) IN ('cr', 'credit', 'c') THEN 'Credit'
    WHEN LOWER(`Transaction Type`) IN ('dr', 'debit', 'd') THEN 'Debit'
    ELSE `Transaction Type`
END;

-- 2. Remove rows with NULL amounts or transaction types
DELETE FROM banking_data
WHERE Amount IS NULL OR `Transaction Type` IS NULL;

-- 3. Optional: Trim spaces in text columns
UPDATE banking_data
SET 
    Branch = TRIM(Branch),
    `Bank Name` = TRIM(`Bank Name`);
    
    
-- 1. Total Credit Amount
SELECT 
    SUM(Amount) AS Total_Credit_Amount
FROM banking_data
WHERE `Transaction Type` = 'Credit';

-- 2. Total Debit Amount
SELECT 
    SUM(Amount) AS Total_Debit_Amount
FROM banking_data
WHERE `Transaction Type` = 'Debit';

-- 3. Credit to Debit Ratio
SELECT 
    ROUND(
        SUM(CASE WHEN `Transaction Type` = 'Credit' THEN Amount ELSE 0 END) /
        SUM(CASE WHEN `Transaction Type` = 'Debit' THEN Amount ELSE 0 END), 2
    ) AS Credit_Debit_Ratio
FROM banking_data;

-- 4. Net transaction amount
SELECT 
    (SUM(CASE WHEN `Transaction Type` = 'Credit' THEN Amount ELSE 0 END)
   - SUM(CASE WHEN `Transaction Type` = 'Debit' THEN Amount ELSE 0 END)) 
   AS Net_Transaction_Amount
FROM banking_data;

-- 5. Account activity ratio
SELECT 
    `Account Number`,
    COUNT(*) AS Transaction_Count,
    MAX(Balance) AS Latest_Balance,
    ROUND(COUNT(*) / NULLIF(MAX(Balance), 0), 4) AS Account_Activity_Ratio
FROM banking_data
GROUP BY `Account Number`;

-- 6. Transactions per day/week/month
-- Per Day
SELECT 
    DATE(`Transaction Date`) AS Day,
    COUNT(*) AS Transactions_Per_Day
FROM banking_data
GROUP BY Day
ORDER BY Day;
-- Per Week
SELECT 
    YEARWEEK(`Transaction Date`) AS YearWeek,
    COUNT(*) AS Transactions_Per_Week
FROM banking_data
GROUP BY YearWeek
ORDER BY YearWeek;
-- Per Month
SELECT 
    DATE_FORMAT(`Transaction Date`, '%Y-%m') AS Month,
    COUNT(*) AS Transactions_Per_Month
FROM banking_data
GROUP BY Month
ORDER BY Month;

-- 7. Total Transaction Amount by branch 
SELECT 
    Branch,
    SUM(CASE WHEN `Transaction Type` = 'Credit' THEN Amount ELSE 0 END) AS Total_Credit,
    SUM(CASE WHEN `Transaction Type` = 'Debit' THEN Amount ELSE 0 END) AS Total_Debit,
    SUM(Amount) AS Total_Transaction_Amount
FROM banking_data
GROUP BY Branch
ORDER BY Total_Transaction_Amount DESC;

-- 8. Transaction Volume by Bank
SELECT 
    `Bank Name`,
    SUM(CASE WHEN `Transaction Type` = 'Credit' THEN Amount ELSE 0 END) AS Total_Credit,
    SUM(CASE WHEN `Transaction Type` = 'Debit' THEN Amount ELSE 0 END) AS Total_Debit,
    SUM(Amount) AS Total_Transaction_Amount
FROM banking_data
GROUP BY `Bank Name`
ORDER BY Total_Transaction_Amount DESC;

-- 9. Combined KPI Overview
SELECT 
    SUM(CASE WHEN `Transaction Type` = 'Credit' THEN Amount ELSE 0 END) AS Total_Credit_Amount,
    SUM(CASE WHEN `Transaction Type` = 'Debit' THEN Amount ELSE 0 END) AS Total_Debit_Amount,
    ROUND(
        SUM(CASE WHEN `Transaction Type` = 'Credit' THEN Amount ELSE 0 END) /
        NULLIF(SUM(CASE WHEN `Transaction Type` = 'Debit' THEN Amount ELSE 0 END), 0), 2
    ) AS Credit_Debit_Ratio,
    (SUM(CASE WHEN `Transaction Type` = 'Credit' THEN Amount ELSE 0 END)
   - SUM(CASE WHEN `Transaction Type` = 'Debit' THEN Amount ELSE 0 END)) AS Net_Transaction_Amount
FROM banking_data;

-- Summary Table
CREATE TABLE kpi_summary AS
SELECT 
    NOW() AS Report_Date,
    SUM(CASE WHEN `Transaction Type` = 'Credit' THEN Amount ELSE 0 END) AS Total_Credit_Amount,
    SUM(CASE WHEN `Transaction Type` = 'Debit' THEN Amount ELSE 0 END) AS Total_Debit_Amount,
    ROUND(
        SUM(CASE WHEN `Transaction Type` = 'Credit' THEN Amount ELSE 0 END) /
        NULLIF(SUM(CASE WHEN `Transaction Type` = 'Debit' THEN Amount ELSE 0 END), 0), 2
    ) AS Credit_Debit_Ratio,
    (SUM(CASE WHEN `Transaction Type` = 'Credit' THEN Amount ELSE 0 END)
   - SUM(CASE WHEN `Transaction Type` = 'Debit' THEN Amount ELSE 0 END)) AS Net_Transaction_Amount
FROM banking_data;

select * from kpi_summary;




