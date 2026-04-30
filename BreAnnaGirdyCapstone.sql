##Creating the database:
CREATE DATABASE IF NOT EXISTS capstone_db;
USE capstone_db;

##Checking and Addressing Null Values:

##No Null Values in SCHOOL_ID:
SELECT *
FROM report_card_25
WHERE SCHOOL_ID IS NULL;

##No Null Values in SCHOOL_NAME:
SELECT *
FROM report_card_25
WHERE SCHOOL_NAME IS NULL;

##No Null Values in DISTRICT:
SELECT *
FROM report_card_25
WHERE DISTRICT IS NULL;

##No Null Values in CITY:
SELECT *
FROM report_card_25
WHERE CITY IS NULL;

##No Null Values in COUNTY:
SELECT *
FROM report_card_25
WHERE COUNTY IS NULL;

##No Null Values in DISTRICT_TYPE:
SELECT *
FROM report_card_25
WHERE DISTRICT_TYPE IS NULL;

##No Null Values in SCHOOL_TYPE:
SELECT *
FROM report_card_25
WHERE SCHOOL_TYPE IS NULL;

##No Null Values in GRADES_SERVED:
SELECT *
FROM report_card_25
WHERE GRADES_SERVED IS NULL;

##There are null values in ELA_Proficiency:
SELECT *
FROM report_card_25
WHERE ELA_PROFICIENCY IS NULL;

##There are null values in ELA_Participation:
SELECT *
FROM report_card_25
WHERE ELA_PARTICIPATION IS NULL;

##There are null values in Math_Proficiency:
SELECT *
FROM report_card_25
WHERE MATH_PROFICIENCY IS NULL;

##There are null values in Math_Participation:
SELECT *
FROM report_card_25
WHERE MATH_PARTICIPATION IS NULL;

## (1) Adding a REPORTED column and marking all schools in the report_card dataset with y, (2) creating a final dataset containing all relevant school information, and (3) updating the table so that schools that did not appear in the report_card dataset have an 'n' in the REPORTED column.
ALTER TABLE report_card
ADD REPORTED varchar(1);

UPDATE report_card
SET REPORTED = 'y'; 

SELECT *
FROM report_card;

CREATE TABLE schools AS
SELECT
	a.SCHOOL_ID,
    b.REPORTED,
    a.ZIP,
    a.STUDENT_COUNT_TOTAL,
    a.GRADUATION_RATE_SCHOOL,
    a.GRADUATION_RATE_MEAN,
    b.ELA_PROFICIENCY,
	b.ELA_PARTICIPATION,
	b.MATH_PROFICIENCY,
    b.MATH_PARTICIPATION
FROM school_information a
LEFT JOIN report_card b on a.SCHOOL_ID = b.SCHOOL_ID;

UPDATE schools
SET REPORTED = 'n'
WHERE REPORTED IS NULL;

SELECT *
FROM schools;

##Creating a CTE with temporary rates information so that we can pull the average in a later table that contains all relevant park and schools information, as well as a count of schools and students that are not included the reported rates due to the fact that some schools did not have information listed in the report card dataset.

WITH rates AS (
	SELECT
		ZIP,
		sum(case WHEN GRADUATION_RATE_SCHOOL IS NOT NULL then 1 ELSE 0 END) as GRAD_Provided,
		ROUND(sum(case WHEN GRADUATION_RATE_MEAN IS NOT NULL then GRADUATION_RATE_MEAN ELSE 0 END), 2) as GRAD_Total,
		sum(case WHEN ELA_PROFICIENCY IS NOT NULL then 1 ELSE 0 END) as ELA_prof_provided,
		ROUND(sum(case WHEN ELA_PROFICIENCY IS NOT NULL then ELA_PROFICIENCY ELSE 0 end),2) as ELA_Total,
		sum(case WHEN ELA_PARTICIPATION IS NOT NULL then 1 ELSE 0 END) as ELA_Part_provided,
		ROUND(sum(case WHEN ELA_PARTICIPATION IS NOT NULL then ELA_PARTICIPATION ELSE 0 end),2) as ELA_Part_Total,
		sum(case WHEN MATH_PROFICIENCY IS NOT NULL then 1 ELSE 0 END) as MATH_prof_provided,
		ROUND(sum(case WHEN MATH_PROFICIENCY IS NOT NULL then MATH_PROFICIENCY ELSE 0 end),2) as MATH_Total,
		sum(case WHEN MATH_PARTICIPATION IS NOT NULL then 1 ELSE 0 END) as MATH_Part_provided,
		ROUND(sum(case WHEN MATH_PARTICIPATION IS NOT NULL then MATH_PARTICIPATION ELSE 0 end),2) as MATH_Part_Total
        FROM schools
        GROUP BY ZIP)
	SELECT
	a.ZIP,
	count(b.PARK) as Total_Parks,
    ROUND(sum(b.ACRES), 2) as Total_Acres,
	count(a.SCHOOL_ID) as Total_Schools,
    sum(case WHEN a.REPORTED = 'y' then 1 ELSE 0 END) as Total_Schools_Reported,
    sum(a.STUDENT_COUNT_TOTAL) as Total_Students,
    sum(case WHEN a.REPORTED = 'y' then STUDENT_COUNT_TOTAL ELSE 0 END) as Total_Students_Reported,
    ROUND((c.GRAD_Total / c.GRAD_Provided), 2) AS Grad_Avg,
    ROUND((c.ELA_Total / c.ELA_prof_provided), 2) AS ELA_Avg,
    ROUND((c.ELA_Part_Total / c.ELA_Part_provided), 2) AS ELA_Part_Avg,
    ROUND((c.MATH_Total / c.MATH_prof_provided), 2) AS MATH_Avg,
    ROUND((c.MATH_Part_Total / c.MATH_Part_provided), 2) AS MATH_Part_Avg
FROM schools a
LEFT JOIN parks b on a.ZIP = b.ZIP
INNER JOIN rates c on a.ZIP = c.ZIP
GROUP BY ZIP;

##Export this dataset to be imported into Tableau.
