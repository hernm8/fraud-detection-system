`
-- Step 1: Load the data with the specified settings (adjust the file path if needed)
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data.csv'
INTO TABLE ecommerce_transactions
CHARACTER SET latin1
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@InvoiceNo, @StockCode, @Description, @Quantity, @InvoiceDate, @UnitPrice, @CustomerID, @Country)
SET 
    InvoiceNo = @InvoiceNo,
    StockCode = @StockCode,
    Description = @Description,
    Quantity = @Quantity,
    InvoiceDate = STR_TO_DATE(@InvoiceDate, '%m/%d/%Y %H:%i'),
    UnitPrice = @UnitPrice,
    CustomerID = @CustomerID,
    Country = @Country;

-- Step 1: Create a temporary table to hold the distinct records
CREATE TEMPORARY TABLE temp_ecommerce_transactions AS
SELECT 
    InvoiceNo, 
    StockCode, 
    Description, 
    Quantity, 
    STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i') AS InvoiceDate, 
    UnitPrice, 
    CustomerID, 
    Country
FROM ecommerce_transactions
GROUP BY 
    InvoiceNo, 
    StockCode, 
    Description, 
    Quantity, 
    InvoiceDate, 
    UnitPrice, 
    CustomerID, 
    Country;

-- Step 2: Delete all rows in the original table that are duplicates
DELETE FROM ecommerce_transactions
WHERE (InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country) 
NOT IN (
    SELECT InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country 
    FROM temp_ecommerce_transactions
);

-- Step 3: Insert the distinct rows back into the original table (this will add new rows if they don't exist)
INSERT INTO ecommerce_transactions
SELECT * FROM temp_ecommerce_transactions
ON DUPLICATE KEY UPDATE
    InvoiceNo = VALUES(InvoiceNo),
    StockCode = VALUES(StockCode),
    Description = VALUES(Description),
    Quantity = VALUES(Quantity),
    InvoiceDate = VALUES(InvoiceDate),
    UnitPrice = VALUES(UnitPrice),
    CustomerID = VALUES(CustomerID),
    Country = VALUES(Country);

-- Step 4: Drop the temporary table
DROP TEMPORARY TABLE temp_ecommerce_transactions;



-- Find transactions with unusually high unit prices (above a certain threshold)
SELECT * 
FROM ecommerce_transactions 
WHERE UnitPrice > 1000;  -- Adjust the threshold based on typical product prices


-- Find customers who made multiple transactions within a 1-hour window
SELECT CustomerID, COUNT(*) AS num_transactions, MIN(InvoiceDate) AS first_transaction, MAX(InvoiceDate) AS last_transaction
FROM ecommerce_transactions
GROUP BY CustomerID
HAVING TIMESTAMPDIFF(MINUTE, MIN(InvoiceDate), MAX(InvoiceDate)) < 60
   AND COUNT(*) > 3;  -- Adjust based on typical behavior

SELECT * 
FROM ecommerce_transactions 
WHERE HEX(Country) != '556E69746564204B696E67646F6D0D';


CREATE TABLE ecommerce_transactions_snapshot (
    InvoiceNo VARCHAR(255),
    StockCode VARCHAR(255),
    Description TEXT,
    Quantity INT,
    InvoiceDate DATETIME,
    UnitPrice DECIMAL(10, 2),
    CustomerID INT,
    Country VARCHAR(255)
);

-- Capture daily snapshots into a separate table for auditing and historical analysis
INSERT INTO ecommerce_transactions_snapshot (InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country)
SELECT InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country
FROM ecommerce_transactions
WHERE DATE(InvoiceDate) = CURDATE();  -- Store transactions of the day

-- Create a summary table for daily sales insights
INSERT INTO daily_sales_summary (Date, TotalSales, TotalTransactions, TopSellingItem)
SELECT CURDATE() AS Date, 
       SUM(UnitPrice * Quantity) AS TotalSales, 
       COUNT(*) AS TotalTransactions, 
       (SELECT Description FROM ecommerce_transactions GROUP BY Description ORDER BY COUNT(*) DESC LIMIT 1) AS TopSellingItem
FROM ecommerce_transactions
WHERE DATE(InvoiceDate) = CURDATE();

