
SELECT *
FROM hdhi_admission;

USE AutoCareDB;

CREATE OR REPLACE VIEW vw_AdmissionData AS
WITH CleanData AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY MRD_No, D_O_A, D_O_D
               ORDER BY MRD_No
           ) AS Dup_No
    FROM hdhi_admission
)
SELECT *
FROM CleanData
WHERE Dup_No = 1
  AND MRD_No IS NOT NULL;
  

