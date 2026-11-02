
SELECT *
FROM vw_AdmissionData;


-- What is Total Discharges, DAMA, Expiry 
SELECT COUNT(*) AS Total_Discharges
FROM vw_AdmissionData
WHERE OUTCOME = 'DISCHARGE';

SELECT COUNT(*) AS Total_DAMA
FROM vw_AdmissionData
WHERE OUTCOME = 'DAMA';

SELECT COUNT(*) AS Total_Expiry
FROM vw_AdmissionData
WHERE OUTCOME = 'Expiry';

-- Average daily discharge rate
SELECT ROUND(
        ((SELECT COUNT(*)
             FROM vw_AdmissionData
             WHERE OUTCOME = 'DISCHARGE')/
            (SELECT SUM(DURATION_OF_STAY)
             FROM vw_AdmissionData)) * 100,2) AS Avg_Daily_Discharge_Rate;
             
-- Average length of stays
SELECT
    ROUND(SUM(DURATION_OF_STAY) / SUM(CASE WHEN OUTCOME = 'DISCHARGE' THEN 1.0 ELSE 0.0 END),2) AS Avg_Length_Of_Stay
FROM vw_AdmissionData;

-- Distribution of discharges by Age group.
-- < 16 = Paediatric
-- 16 - 65 = Adult
-- > 65 = Senior Citizen
SELECT
    CASE
        WHEN AGE < 16 THEN 'Paediatric'
        WHEN AGE < 65 THEN 'Adult'
        WHEN AGE >= 65 THEN 'Senior Citizen'
        ELSE 'Unknown'
    END AS Age_Group,
    COUNT(*) AS Age_Distribution
FROM vw_AdmissionData
WHERE OUTCOME = 'DISCHARGE'
GROUP BY Age_Group
ORDER BY Age_Distribution DESC;

-- Distribution of discharges by Gender.
SELECT GENDER, COUNT(*) AS Gender_Distribution
FROM vw_AdmissionData
WHERE OUTCOME = 'DISCHARGE'
GROUP BY GENDER
ORDER BY Gender_Distribution DESC;

-- Distribution of discharges by day of the week.

SELECT
    DAYOFWEEK(STR_TO_DATE(D_O_D, '%m/%d/%Y')) AS Day_Number,
    CASE DAYOFWEEK(STR_TO_DATE(D_O_D, '%m/%d/%Y'))
        WHEN 1 THEN 'Sun'
        WHEN 2 THEN 'Mon'
        WHEN 3 THEN 'Tues'
        WHEN 4 THEN 'Wed'
        WHEN 5 THEN 'Thur'
        WHEN 6 THEN 'Fri'
        WHEN 7 THEN 'Sat'
    END AS Day_Name,
    COUNT(*) AS Day_Distribution
FROM hdhi_admission
WHERE STR_TO_DATE(D_O_D, '%m/%d/%Y') IS NOT NULL
GROUP BY Day_Number, Day_Name
ORDER BY Day_Number;
        

