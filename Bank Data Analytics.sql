create database Bank_Data;
SHOW COLUMNS FROM bank_data_table;


# 1. TOTAL LOAN AMOUNT FUNDED

SELECT 
    SUM(Loan_Amount) AS Total_Loan_Amount_Funded
FROM
    bank_data_table;
    
# 2. TOTAL LOANS
 
SELECT COUNT(*) AS TOTAL_LOANS FROM bank_data_table;

# 3. TOTAL COLLECTION
 
SELECT SUM(Total_Rec_Prncp) + SUM(Total_Rrec_int) AS TOTAL_COLLECTION
FROM bank_data_table;

# 4. TOTAL INTEREST

SELECT SUM(Total_Rrec_int) AS TOTAL_INTEREST
FROM bank_data_table;
 
# 5. BRANCH-WISE (INTEREST, FEES, TOTAL REVENUE)

SELECT 
  Branch_Name,
  SUM(Total_Rrec_int)    AS TOTAL_INTEREST,
  SUM(Total_Fees)        AS TOTAL_FEES,
  SUM(Total_Rrec_int + Total_Fees) AS TOTAL_REVENUE
FROM bank_data_table
GROUP BY Branch_Name;

# 6. STATE-WISE LOAN

SELECT 
  State_Name, 
  COUNT(*) AS LOANS_DISTRIBUTED,
    SUM(Loan_Amount)   AS TOTAL_LOAN_AMOUNT
FROM bank_data_table
GROUP BY State_Name;

# 7. RELIGION-WISE LOAN

SELECT 
  Religion, 
  COUNT(*)           AS LOANS_BY_RELIGION,
  SUM(Loan_Amount)   AS TOTAL_LOAN_AMOUNT
FROM bank_data_table
GROUP BY Religion;

# 8. PRODUCT GROUP-WISE LOAN

SELECT 
  Product_Code, 
  COUNT(*)         AS LOANS_BY_PRODUCT,
  SUM(Loan_Amount) AS TOTAL_LOAN_AMOUNT
FROM bank_data_table
GROUP BY Product_Code;

# 9. DISBURSEMENT TREND

SELECT 
  YEAR(STR_TO_DATE(Disbursement_Date, '%Y-%m-%d')) AS YEAR, 
  COUNT(*) AS LOANS_DISBURSED
FROM bank_data_table
GROUP BY YEAR
ORDER BY YEAR;

# 10. GRADE-WISE LOAN

SELECT 
  Grrade, 
  COUNT(*) AS LOANS_BY_GRADE,
  SUM(Loan_Amount) AS TOTAL_LOAN_AMOUNT
FROM bank_data_table
GROUP BY Grrade;

# 11. COUNT OF DEFAULT LOAN

SELECT 
  COUNT(*) AS DEFAULT_LOANS
FROM bank_data_table
WHERE Is_Default_Loan = 'Y';

# 12. COUNT OF DELINQUENT CLIENTS

SELECT 
  COUNT(*) AS DELINQUENT_CLIENTS
FROM bank_data_table
WHERE Is_Delinquent_Loan = 'Y';

# 13. DELINQUENT LOANS RATE

SELECT 
  (SUM(CASE WHEN Is_Delinquent_Loan = 'Y' THEN 1 ELSE 0 END) / COUNT(*)) * 100 
    AS DELINQUENT_LOAN_RATE
FROM bank_data_table;

# 14. DEFAULT LOAN RATE

SELECT 
  (SUM(CASE WHEN Is_Default_Loan = 'Y' THEN 1 ELSE 0 END) / COUNT(*)) * 100 
    AS DEFAULT_LOAN_RATE
FROM bank_data_table;

# 15. LOAN STATUS-WISE LOAN

SELECT 
  Loan_Status,
  COUNT(*)         AS LOANS_BY_STATUS,
  SUM(Loan_Amount) AS TOTAL_LOAN_AMOUNT
FROM bank_data_table
GROUP BY Loan_Status;

# 16. AGE GROUP-WISE LOAN

SELECT
  CASE
    WHEN Age__T BETWEEN 18 AND 30 THEN '18-30'
    WHEN Age__T BETWEEN 31 AND 45 THEN '31-45'
    WHEN Age__T BETWEEN 46 AND 60 THEN '46-60'
    ELSE '61+'
  END AS AGE_GROUP,
  COUNT(*) AS LOANS_COUNT,
  SUM(Loan_Amount) AS TOTAL_LOAN_AMOUNT
FROM bank_data_table
GROUP BY AGE_GROUP;

# 17. NO VERIFIED LOAN

SELECT 
  COUNT(*) AS NO_VERIFIED_LOANS
FROM bank_data_table
WHERE Verification_Status = 'Not Verified';

# 18. LOAN MATURITY

SELECT Disbursement_Date_Years, COUNT(*)
FROM bank_data_table
GROUP BY Disbursement_Date_Years
ORDER BY Disbursement_Date_Years;















