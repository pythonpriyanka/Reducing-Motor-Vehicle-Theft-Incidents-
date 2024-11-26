
-- Preview the first few rows
Select top 10 * from  Theft_From_Motor_Vehicle_Data  ;

-- Check for missing Data
SELECT 
    COUNT(*) AS TotalRows,
    COUNT(OCC_YEAR) AS OCC_YEAR_Count,
    COUNT(OCC_MONTH) AS OCC_MONTH_Count
FROM Theft_From_Motor_Vehicle_Data;
-- Display missing rows
SELECT * 
FROM Theft_From_Motor_Vehicle_Data
WHERE OCC_YEAR IS NULL OR OCC_MONTH IS NULL;

-- Update the null value
UPDATE Theft_From_Motor_Vehicle_Data
SET OCC_YEAR = YEAR(OCC_DATE)
WHERE OCC_YEAR IS NULL;

UPDATE Theft_From_Motor_Vehicle_Data
SET OCC_MONTH = MONTH(OCC_DATE)
WHERE OCC_MONTH IS NULL;


SELECT 
    COUNT(*) AS TotalRows,
    COUNT(REPORT_DOW) AS REPORT_DOW_Count,
    COUNT(REPORT_MONTH) AS REPORT_MONTH_Count
FROM Theft_From_Motor_Vehicle_Data;