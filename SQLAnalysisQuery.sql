--Count the number of incidents reported each year

SELECT 
    REPORT_YEAR, 
    COUNT(*) AS Total_Incidents
FROM Theft_From_Motor_Vehicle_Data
GROUP BY REPORT_YEAR
ORDER BY REPORT_YEAR;

--Find the number of incidents for each month across all years:
SELECT 
    REPORT_MONTH, 
    COUNT(*) AS Total_Incidents
FROM Theft_From_Motor_Vehicle_Data
GROUP BY REPORT_MONTH
ORDER BY CASE REPORT_MONTH
        WHEN 'January' THEN 1
        WHEN 'February' THEN 2
        WHEN 'March' THEN 3
        WHEN 'April' THEN 4
        WHEN 'May' THEN 5
        WHEN 'June' THEN 6
        WHEN 'July' THEN 7
        WHEN 'August' THEN 8
        WHEN 'September' THEN 9
        WHEN 'October' THEN 10
        WHEN 'November' THEN 11
        WHEN 'December' THEN 12
        ELSE 13 -- This handles any potential NULL or unexpected values
    END;

--Which days have the most theft incidents?

SELECT 
    REPORT_DOW AS Day_of_Week, 
    COUNT(*) AS Total_Incidents
FROM Theft_From_Motor_Vehicle_Data
GROUP BY REPORT_DOW
ORDER BY Total_Incidents DESC;

--Identify neighborhoods with the highest number of incidents:

-- Use CTEs to apply TOP for each query
WITH TopNeighborhood158 AS (
    SELECT TOP 10
        NEIGHBOURHOOD_158 AS Neighborhood, 
        COUNT(*) AS Total_Incidents
    FROM Theft_From_Motor_Vehicle_Data
    GROUP BY NEIGHBOURHOOD_158
    ORDER BY Total_Incidents DESC
),
TopNeighborhood140 AS (
    SELECT TOP 10
        NEIGHBOURHOOD_140 AS Neighborhood, 
        COUNT(*) AS Total_Incidents
    FROM Theft_From_Motor_Vehicle_Data
    GROUP BY NEIGHBOURHOOD_140
    ORDER BY Total_Incidents DESC
)
-- Combine the results
SELECT 
    Neighborhood, 
    Total_Incidents, 
    'Neighborhood158' AS Source
FROM TopNeighborhood158

UNION ALL

SELECT 
    Neighborhood, 
    Total_Incidents, 
    'Neighborhood140' AS Source
FROM TopNeighborhood140;


--Analyze theft incidents above 100 based on location types (e.g., parking lots, residential areas):
SELECT 
    LOCATION_TYPE, 
    COUNT(*) AS Total_Incidents
FROM Theft_From_Motor_Vehicle_Data
GROUP BY LOCATION_TYPE
Having COUNT(*)>100
ORDER BY Total_Incidents DESC;

--Find the most frequent hours of theft occurrences
SELECT 
    OCC_HOUR AS Hour, 
    COUNT(*) AS Total_Incidents
FROM Theft_From_Motor_Vehicle_Data
GROUP BY OCC_HOUR
ORDER BY Total_Incidents DESC;

--Cumulative Crime Trends of thefts over the years to identify trends
SELECT 
    REPORT_YEAR AS Year, 
    COUNT(*) AS Yearly_Incidents,
    SUM(COUNT(*)) OVER (ORDER BY REPORT_YEAR) AS Cumulative_Incidents
FROM Theft_From_Motor_Vehicle_Data
GROUP BY REPORT_YEAR;

--Yearly Percentage Change in Incidents reported thefts year over year:
WITH YearlyData AS (
    SELECT 
        REPORT_YEAR AS Year, 
        COUNT(*) AS Total_Incidents
    FROM Theft_From_Motor_Vehicle_Data
    GROUP BY REPORT_YEAR
)
SELECT 
    Year, 
    Total_Incidents, 
    LAG(Total_Incidents) OVER (ORDER BY Year) AS Previous_Year_Incidents,
    (Total_Incidents - LAG(Total_Incidents) OVER (ORDER BY Year)) * 100.0 / 
    LAG(Total_Incidents) OVER (ORDER BY Year) AS Percentage_Change
FROM YearlyData;

--The most common combination of day and time for theft incidents:

SELECT top 1
    REPORT_DOW AS Day_of_Week, 
    OCC_HOUR AS Hour, 
    COUNT(*) AS Total_Incidents
FROM Theft_From_Motor_Vehicle_Data
GROUP BY REPORT_DOW, OCC_HOUR
ORDER BY Total_Incidents DESC;

 --Correlation Between Time and Location:
WITH NeighborhoodIncidents AS (
    -- Group incidents by neighborhood and month
    SELECT 
        NEIGHBOURHOOD_158 AS Neighborhood, 
        YEAR(OCC_DATE) AS Year, 
        MONTH(OCC_DATE) AS Month, 
        COUNT(*) AS Total_Incidents
    FROM Theft_From_Motor_Vehicle_Data
    WHERE NEIGHBOURHOOD_158 IS NOT NULL
    GROUP BY 
        NEIGHBOURHOOD_158, 
        YEAR(OCC_DATE), 
        MONTH(OCC_DATE)

    UNION ALL

    SELECT 
        NEIGHBOURHOOD_140 AS Neighborhood, 
        YEAR(OCC_DATE) AS Year, 
        MONTH(OCC_DATE) AS Month, 
        COUNT(*) AS Total_Incidents
    FROM Theft_From_Motor_Vehicle_Data
    WHERE NEIGHBOURHOOD_140 IS NOT NULL
    GROUP BY 
        NEIGHBOURHOOD_140, 
        YEAR(OCC_DATE), 
        MONTH(OCC_DATE)
)
SELECT 
    Neighborhood, 
    Year, 
    Month, 
    SUM(Total_Incidents) AS Total_Incidents
FROM NeighborhoodIncidents
GROUP BY 
    Neighborhood, 
    Year, 
    Month
ORDER BY 
    Total_Incidents DESC;

--Incident as per premises:
SELECT 
   PREMISES_TYPE, 
   COUNT(*) AS Total_Incidents
FROM Theft_From_Motor_Vehicle_Data
GROUP BY PREMISES_TYPE
ORDER BY Total_Incidents DESC;


