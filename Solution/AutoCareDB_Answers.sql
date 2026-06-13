--Q1 Total Discharges
SELECT COUNT(*) As Total_Discharges
FROM vw_AdmissionData
WHERE OUTCOME = 'DISCHARGE'


--Q2 Average Daily Dischage Rate 
--total discharges / total length of stay
SELECT
(SELECT COUNT(*) As Total_Discharges
FROM vw_AdmissionData
WHERE OUTCOME = 'DISCHARGE') / (SELECT SUM(DURATION_OF_STAY) AS Total_length_of_stay
FROM vw_AdmissionData)

--Casting this
SELECT
	CAST(
		CAST ((SELECT COUNT(*) As Total_Discharges
		FROM vw_AdmissionData
		WHERE OUTCOME = 'DISCHARGE') AS FLOAT) / 
		CAST ((SELECT SUM(DURATION_OF_STAY) AS Total_length_of_stay
		FROM vw_AdmissionData) AS FLOAT)
	AS DECIMAL (10,2)) * 100 AS Avg_DailyDischargeRate

--Avoiding Subsquery
SELECT
	ROUND(SUM(CASE WHEN OUTCOME = 'DISCHARGE' THEN 1.0 ELSE 0.0 END)/
	SUM(DURATION_OF_STAY),2) *100 AS Avg_DischargeRate
FROM vw_AdmissionData


--Q3 Average of Length of Stay (ALOS) 
--total length of stay / total discharges
--Reverse of Q2
SELECT ROUND(SUM(DURATION_OF_STAY) / SUM(CASE WHEN OUTCOME = 'DISCHARGE' THEN 1.0 ELSE 0.0 END),0) AS Avg_length_of_stay
FROM vw_AdmissionData


--Q4 Distribution of discharges by Age Group
--<16 Paediatric, 16 < 64 Adult, >= Senior Citizen
SELECT CASE 
		WHEN AGE < 16 THEN 'Paediatric'
		WHEN AGE < 65 THEN 'Adult'
		WHEN AGE >= 65 THEN 'Senior Citizen'
		ELSE 'Unknown'
	END AS Age_Group, COUNT(*) Age_Distribution
FROM vw_AdmissionData
WHERE OUTCOME = 'DISCHARGE'
GROUP BY CASE 
		WHEN AGE < 16 THEN 'Paediatric'
		WHEN AGE < 65 THEN 'Adult'
		WHEN AGE >= 65 THEN 'Senior Citizen'
		ELSE 'Unknown'
	END
ORDER BY 2 DESC;

--Q5 Distribution of discharges by Gender
SELECT GENDER, COUNT(*) AS Gender_Distribution
FROM vw_AdmissionData
WHERE OUTCOME = 'DISCHARGE'
GROUP BY GENDER
ORDER BY COUNT(*) DESC;


--Q6 Distribution of discharge by day of the week
SELECT DATEPART(WEEKDAY, D_O_D) AS Day_of_week, COUNT(*) AS Day_Distribution
FROM vw_AdmissionData
WHERE OUTCOME = 'DISCHARGE'
GROUP BY DATEPART(WEEKDAY, D_O_D)
ORDER BY 2 DESC;

--Get Date Name
SELECT FORMAT(D_O_D, 'ddd') AS Day_of_week, COUNT(*) AS Day_Distribution
FROM vw_AdmissionData
WHERE OUTCOME = 'DISCHARGE' AND D_O_D IS NOT NULL
GROUP BY FORMAT(D_O_D, 'ddd') 
ORDER BY 2 DESC;