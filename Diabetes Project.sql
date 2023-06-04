-- What is the distribution of time spent in the hospital?

Select time_in_hospital as Days,
Count(*) as Count,
REPLICATE('|',(Count(*)/100)) as Bar
From Diabetes
Group by time_in_hospital
order by 1 asc

-- Which medical specialties have an average number of procedures > 2.5 and total patient count > 50?

Select medical_specialty as Medical,
Round(Avg(num_procedures),1) as 'Avg Procedures',
Count(*) as Count
From Diabetes
Group by medical_specialty
Having Round(Avg(num_procedures),1) > 2.5 and 
Count(*) > 50
order by Medical asc

-- Are races being treated differently subconsciously?

select replace(race,'?','Unknown') as Race,
Count(*) as Count,
Round(Avg(num_lab_procedures),1) as 'Avg Lab Procedures',
replicate('\\',(Avg(num_lab_procedures))) as Visualize
From Diabetes
Group by race
order by 2 desc

-- What is the relationship between number of lab procedures and time spent in the hospital?

Select round(Avg(time_in_hospital),1) as 'Average Time',
Case 
 when num_lab_procedures < 25 then 'Few'
 When num_lab_procedures >= 55 then 'Average'
 Else 'Many'
 End as Procedure_Frequency
From Diabetes
Group by 
num_lab_procedures
Order by 1 asc


-- Who are the patients that are African American or have an “Up” to metformin?


Select patient_nbr
From Diabetes
Where race = 'AfricanAmerican'
and metformin = 'Up'

-- Counts
Select Count(patient_nbr) as 'AfricanAmerican with Metformin Up'
From Diabetes
Where race = 'AfricanAmerican'
and metformin = 'Up'

-- Who are the patients that had an emergency but left the hospital faster than average?

With avg_time (timer) as (Select avg(time_in_hospital) from Diabetes)

Select encounter_id,
patient_nbr
From Diabetes
where time_in_hospital < (Select * From avg_time)

-- Who are the top 50 medication patients?

Select Top 50 CONCAT_WS(' ','Patient', cast(patient_nbr as int),'was',race, 'race and', (Case when readmitted = 'No' then 'was not admitted. They had ' else 'was admitted. They had ' end),
num_medications, 'medications and ', num_lab_procedures, 'lab procedures') as 'Top 50 medication patients'
From Diabetes
Where race <> '?'
order by num_medications