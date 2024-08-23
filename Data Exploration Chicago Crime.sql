SELECT * FROM chicago_crime.chicago_crime;




SELECT * FROM chicago_public_schools;

SELECT * FROM chicago_socioeconomic_data;

-- IDENTIFYING MISSING DATA 

SELECT * FROM chicago_crime.chicago_crime
WHERE WARD IS NULL OR COMMUNITY_AREA_NUMBER IS NULL ;





-- WRITE AND EXECUTE A SQL query to list the school names, community names and averaqge attendance for communities  with a hardship index of 98


SELECT  CPS.NAME_OF_SCHOOL, CSD.COMMUNITY_AREA_NAME, CPS.AVERAGE_STUDENT_ATTENDANCE
FROM  chicago_public_schools AS CPS
LEFT JOIN chicago_socioeconomic_data AS CSD
  on CSD.COMMUNITY_AREA_NUMBER = CPS.COMMUNITY_AREA_NUMBER
WHERE HARDSHIP_INDEX=98;

-- Q2 Write an execute a SQL query to list all crimes that took place at a school. Include case number ,crime type and community name

SELECT CCC.CASE_NUMBER, CCC.PRIMARY_TYPE, CSD.COMMUNITY_AREA_NAME 
  FROM   chicago_crime.chicago_crime AS CCC
 LEFT OUTER JOIN  chicago_socioeconomic_data AS CSD
   ON CCC.COMMUNITY_AREA_NUMBER = CSD.COMMUNITY_AREA_NUMBER
   WHERE CCC.LOCATION_DESCRIPTION LIKE '%SCHOOL%';
   
   
   -- CREATING A VIEW
   -- For privacy reasons, you have been asked to create a view that enables users to select just the school name and the icon fields from the CHICAGO_PUBLIC_SCHOOLS table. 
   -- By providing a view, you can ensure that users cannot see the actual scores given to a school, just the icon associated with their score.
   -- You should define new names for the view columns to obscure the use of scores and icons in the original table.
   
    -- Q3-1 Write an execute SQL Statement that returns all of the column from from the view
    -- Q3-1 Write an execute a SQL Statement that returns just school name and leaders rating from the view
   
   CREATE VIEW Chicago_p_schools_v (
  School_Name,Safety_Rating,
  Family_Rating,Environment_Rating,
  Instruction_Rating,Leaders_Rating,
  Teachers_Rating ) AS
SELECT NAME_OF_SCHOOL,Safety_Icon,
Family_Involvement_Icon,Environment_Icon,
Instruction_Icon,Leaders_Icon,
Teachers_Icon FROM chicago_public_schools;

SELECT School_Name,Leaders_Rating FROM Chicago_p_schools_v;

-- Q4 Creating a Stored Procedure
# The icon fields are calculated based on the value in the corresponding score field. You need to make sure that when a
# score field is updated,the icon field is updated too. To do this, you will write a stored procedure that receives the
# school id and a leaders score as input parameters, calculates the icon setting and updates the fields appropriately.

# Inside your stored procedure, write a SQL statement to update
# the Leaders_Score field in the CHICAGO_PUBLIC_SCHOOLS table for the school
# identified by in_School_ID to the value in the in_Leader_Score parameter.

DELIMITER $$
CREATE PROCEDURE UPDATE_LEADERS_SCORE(IN in_School_ID INT , IN in_Leader_Score INT )
BEGIN
UPDATE CHICAGO_PUBLIC_SCHOOLS
SET Leaders_Score = in_Leader_Score
WHERE School_ID = in_School_ID;
END $$
DELIMITER ;

 -- Question 3
# Inside your stored procedure, write a SQL IF statement to update the Leaders_Icon field in
# the CHICAGO_PUBLIC_SCHOOLS table for the school identified by in_School_ID using
# the following information:

# Score lower limit Score upper limit Icon
# 80 99 Very strong
# 60 79 Strong
# 40 59 Average
# 20 39 Weak
# 0 19 Very weak


DELIMITER $$
CREATE PROCEDURE UPDATE_Leaders_Icon(IN in_School_ID INT , IN in_Leader_Score INT )
BEGIN

IF in_Leader_Score >= 0 AND in_Leader_Score <= 19 THEN
UPDATE chicago_public_schools
SET Leaders_Icon = "Very weak"
WHERE School_ID = in_School_ID ;

ELSEIF  in_Leader_Score <= 39 THEN
UPDATE chicago_public_schools
SET Leaders_Icon = "Weak"
WHERE School_ID = in_School_ID ;

ELSEIF in_Leader_Score <= 59 THEN
UPDATE chicago_public_schools
SET Leaders_Icon = "Average"
WHERE School_ID = in_School_ID ;

ELSEIF in_Leader_Score <= 79 THEN
UPDATE chicago_public_schools
SET Leaders_Icon = "Strong"
WHERE School_ID = in_School_ID ;

ELSEIF in_Leader_Score <= 99 THEN
UPDATE chicago_public_schools
SET Leaders_Icon = "Very weak"
WHERE School_ID = in_School_ID ;
END IF;
END $$
DELIMITER ;


  
  
