CREATE TRIGGER UpdateOCCYearMonth
ON Theft_From_Motor_Vehicle_Data
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE T
    SET 
        OCC_YEAR = YEAR(OCC_DATE),
        OCC_MONTH = MONTH(OCC_DATE)
    FROM TheftData T
    WHERE OCC_DATE IS NOT NULL 
    AND (OCC_YEAR IS NULL OR OCC_MONTH IS NULL);
END;
