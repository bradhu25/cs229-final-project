/*
These SQL queries are copied from BigQuery and were not run in this way. They are included in the repo for reference.
*/


/*
This query selects only businesses with a certain number of early round deals
*/

SELECT *
FROM `cs229finalproject-389205.pitchbook2.cleaned_data` 
WHERE Business_Entity_ID IN 
(
  SELECT DISTINCT Business_Entity_ID
  FROM `cs229finalproject-389205.pitchbook2.cleaned_data`
  WHERE Deal_Type = 'Seed Round' OR (Deal_Type = 'Early Stage VC' AND Deal_Type_2 = 'Stage A')
  GROUP BY Business_Entity_ID
  HAVING COUNT(*) >= 2
) 
AND Business_Entity_ID IN
(
  SELECT DISTINCT Business_Entity_ID
  FROM `cs229finalproject-389205.pitchbook2.cleaned_data`
  GROUP BY Business_Entity_ID
  HAVING COUNT(*) >= 3
)


/*
Flattens the 2 rounds of early data into one row to create Dataset 1
*/
WITH round_1 AS
(
  SELECT *
  FROM `cs229finalproject-389205.pitchbook2.three_or_more`
  WHERE VC_Deal_Number = 1
)

SELECT *
FROM round_1 r1
INNER JOIN (
  SELECT Business_Entity_ID, Close_Date, Close_Quarter, _Deal_Size__millions__, Mega_Deal_, Pre_Value__millions_, Post_Value__millions_, Traditional_VC_Investor_Count, Non_Traditional_VC_Investor_Count, US_Investor_Count, Europe_Investor_Count, Female_Founder_Count, Investor_Count, CVC_Investor_Involvement, PE_Investor_Involvement, Hedge_Fund_Investor_Involvement, Asset_Manager_Investor_Involvement, Government_SWF_Investor_Involvement, Number_of_Lead_Investors_on_Deal, Number_of_Non_Lead_Investors_on_Deal, Number_of_New_Investors, Number_of_New_Lead_Investors, Number_of_Follow_On_Investors, Number_of_Lead_Follow_On_Investors, At_Least_One_Lead_Investor_is_New_and_Got_Board_Seat, Crossover_Investor_was_a_Lead_Investor, Notable_Investor_Count, Notable_Investor_Involvement, VC_Raised_to_Date
  FROM `cs229finalproject-389205.pitchbook2.three_or_more`
  WHERE VC_Deal_Number = 2
) r2 ON (r1.Business_Entity_ID = r2.Business_Entity_ID)


/*
Strips the excessive rounds of early data to leave one row to create Dataset 2
*/
SELECT *
FROM `cs229finalproject-389205.pitchbook2.two_or_more`
WHERE VC_Deal_Number = 1