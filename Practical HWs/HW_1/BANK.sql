use database_hw2
/*1*/
Select *
From final F
Where F.Cars_Count < (Select AVG(Convert(float, F2.Cars_Count)) From final F2)

/*2*/
select f.Gender, f.Id
from final as f
where (f.Sood96 >= f.Sood95 and f.Sood97 >= f.Sood96)

/*3*/
Select F.SenfName
From final F
Where F.SenfName LIKE '%ä%'

/*4*/
select F.Id
from final F
where(YEAR(GETDATE())- YEAR(F.BirthDate)=50 and F.ProvinceName = N'ÊåÑÇä')
Order by (F.Daramad_Total_Rials)

/*5*/
select F.Id
from final as F
where (F.Gender = N'ãÑÏ' and parse(F.Bardasht97 as bigint) > 30000000)