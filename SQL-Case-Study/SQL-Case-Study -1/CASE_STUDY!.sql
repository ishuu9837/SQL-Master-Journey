CREATE DATABASE CAS1
USE CAS1
--Verification
SELECT * FROM ProductTable;
SELECT * FROM LocationTable;
SELECT * FROM FactTable;

-- Queries

-- 1. Display the number of states present in the LocationTable.
SELECT COUNT(DISTINCT State) AS Number_Of_States FROM LocationTable;

-- 2. Count the number of regular type products.
SELECT COUNT(*) AS Regular_Products_Count FROM ProductTable WHERE Type = 'Regular';

-- 3. Total marketing spending for Product ID 1.
SELECT SUM(Marketing) AS Total_Marketing_Spend FROM FactTable WHERE ProductID = 1;

-- 4. Minimum sales of a product.
SELECT MIN(Sales) AS Minimum_Sales FROM FactTable;

-- 5. Maximum Cost of Goods Sold (COGS).
SELECT MAX(COGS) AS Max_COGS FROM FactTable;

-- 6. Display product details where product type is coffee.
SELECT * FROM ProductTable WHERE Product_Type = 'Coffee';

-- 7. Display details where total expenses > 40.
SELECT * FROM FactTable WHERE Total_Expenses > 40;

-- 8. Average sales in area code 719.
SELECT AVG(Sales) AS Average_Sales FROM FactTable WHERE Area_Code = 719;

-- 9. Total profit generated by Colorado state.
SELECT SUM(Profit) AS Total_Profit FROM FactTable
JOIN LocationTable ON FactTable.Area_Code = LocationTable.Area_Code
WHERE State = 'Colorado';

-- 10. Average inventory for each product ID.
SELECT ProductID, AVG(Inventory) AS Average_Inventory FROM FactTable GROUP BY ProductID;

-- 11. Display states in sequential order.
SELECT DISTINCT State FROM LocationTable ORDER BY State;

-- 12. Average budget of products where budget margin > 100.
SELECT ProductID, AVG(Budget_Profit) AS Average_Budget FROM FactTable
GROUP BY ProductID HAVING AVG(Budget_Margin) > 100;

-- 13. Total sales on 2010-01-01.
SELECT SUM(Sales) AS Total_Sales FROM FactTable WHERE Date = '2010-01-01';

-- 14. Average total expense of each product ID on an individual date.
SELECT Date, ProductID, AVG(Total_Expenses) AS Average_Expense FROM FactTable GROUP BY Date, ProductID;

-- 15. Display the table with specific attributes.
SELECT f.Date, f.ProductID, p.Product_Type, p.Product, f.Sales, f.Profit, l.State, f.Area_Code
FROM FactTable f
JOIN ProductTable p ON f.ProductID = p.ProductID
JOIN LocationTable l ON f.Area_Code = l.Area_Code;

-- 16. Sales-wise rank without gaps.
SELECT *, DENSE_RANK() OVER (ORDER BY Sales DESC) AS Sales_Rank FROM FactTable;

-- 17. State-wise profit and sales.
SELECT l.State, SUM(f.Profit) AS Total_Profit, SUM(f.Sales) AS Total_Sales
FROM FactTable f JOIN LocationTable l ON f.Area_Code = l.Area_Code
GROUP BY l.State;

-- 18. State-wise profit and sales along with product name.
SELECT l.State, p.Product, SUM(f.Profit) AS Total_Profit, SUM(f.Sales) AS Total_Sales
FROM FactTable f JOIN ProductTable p ON f.ProductID = p.ProductID
JOIN LocationTable l ON f.Area_Code = l.Area_Code
GROUP BY l.State, p.Product;

-- 19. Increased sales by 5%.
SELECT ProductID, Sales, Sales * 1.05 AS Increased_Sales FROM FactTable;

-- 20. Maximum profit along with product ID and product type.
SELECT 
    P.ProductID, 
    P.Product_Type, 
    F.Profit AS Max_Profit
FROM FactTable F
JOIN ProductTable P ON F.ProductID = P.ProductID
WHERE F.Profit = (
    SELECT MAX(Profit) 
    FROM FactTable F2 
    WHERE F2.ProductID = F.ProductID
);


-- 21. Stored procedure to fetch products by type.
CREATE PROCEDURE GetProductsByType(@Type VARCHAR(50))
AS BEGIN SELECT * FROM ProductTable WHERE Product_Type = @Type; END;

-- 22. Classify total expenses as profit or loss.
SELECT *, CASE WHEN Total_Expenses < 60 THEN 'Profit' ELSE 'Loss' END AS Profit_Loss_Status FROM FactTable;

-- 23. Total weekly sales using roll-up.
SELECT DATEPART(WEEK, Date) AS Week, ProductID, SUM(Sales) AS Weekly_Sales
FROM FactTable GROUP BY ROLLUP (DATEPART(WEEK, Date), ProductID);

-- 24. Apply UNION and INTERSECT on Area Code.
(SELECT Area_Code FROM FactTable) UNION (SELECT Area_Code FROM LocationTable);
(SELECT Area_Code FROM FactTable) INTERSECT (SELECT Area_Code FROM LocationTable);

-- 25. User-defined function to fetch products by type.
CREATE FUNCTION GetProductByType(@Type VARCHAR(50))
RETURNS TABLE AS RETURN (SELECT * FROM ProductTable WHERE Product_Type = @Type);

-- 26. Change product type from coffee to tea and undo it.
UPDATE ProductTable SET Product_Type = 'Tea' WHERE ProductID = 1;

-- 27. Display date, product ID, and sales where total expenses are between 100-200.
SELECT Date, ProductID, Sales FROM FactTable WHERE Total_Expenses BETWEEN 100 AND 200;

-- 28. Delete records for regular type.
DELETE FROM ProductTable WHERE Type = 'Regular';

-- 29. Display ASCII value of the fifth character from the Product column.
SELECT Product, ASCII(SUBSTRING(Product, 5, 1)) AS Fifth_Char_ASCII FROM ProductTable;
