-- DATABASE NAME
use medicare;


-- providers table have data relating to hospitals and its address like state,city,state

-- data in providers/hospital s table
select * from medicare.Providers;

select count(Provider_Id) from medicare.Providers;

-- count of unique/different hospitals
select count(distinct Provider_Name) from medicare.Providers;

-- hospital names which are repeated more than once
-- no of hospitals per street
select Provider_Street_Address,count(Provider_Name) as hospitals
from medicare.Providers
group by Provider_Street_Address
order by hospitals  desc;

-- no of hospitals per each city
select Provider_City,count(Provider_Name) as hospitals
from medicare.Providers
group by Provider_City
order by hospitals  desc;

-- no of cities per each state
select Provider_State,count(Provider_city) as cities
from medicare.Providers
group by Provider_State
order by cities desc;

-- no of hospitals per state
select Provider_State,Provider_City,count(Provider_Name) as hospitals
from medicare.Providers
group by Provider_State,Provider_City
order by Provider_State,hospitals desc;

-- hospitals which have branches/hospital column which have duplicate values
select Provider_Name,count(*)
from medicare.Providers
group by Provider_Name
having count(*)>1;


-- selecting records of duplicate values/hospital records which have branches
select * from medicare.Providers
		where Provider_Name IN (select Provider_Name from(select Provider_Name,count(*)
														  from medicare.Providers
														  group by Provider_Name
														  having count(*)>1)
								as sec)order by Provider_Name;
                                
 -- another way to print records having duplicate values/records of hospitals having branches
 select a.* from medicare.Providers as a
 join (select Provider_Name,count(*)
	   from medicare.Providers
	   group by Provider_Name
	   having count(*)>1)as b
       on a.Provider_Name=b.Provider_Name
       order by a.Provider_Name;

-- analysing providers data no of hospitals in each state tells which state have enough medical facilities with more hospitals and which state to improve 

create view hospitals_states as
select Provider_State,count(Provider_Name) as hospitals
from medicare.Providers
group by Provider_State
order by Provider_State,hospitals desc;



-- table medicare_inpatient

-- first 3  rows in medicare_inpatient
select * from medicare.medicare_inpatient limit 3;
-- no of unique or different data rows
select distinct * from medicare.medicare_inpatient;
-- count of all data rows
select count(*) from medicare.medicare_inpatient;
-- count of different data rows
select distinct count(*) from medicare.medicare_inpatient;
-- no of drg's(DRG_Definitions) available in medicare
select count(distinct DRG_Definition) from medicare.medicare_inpatient;
-- count of column Provider_Id
select count(Provider_Id) from medicare.medicare_inpatient;
-- count of unique entries of column provider_Id
select count( distinct Provider_Id) from medicare.medicare_inpatient;
-- no of drg's involved with each provider
select Provider_Id,count(DRG_Definition) from medicare.medicare_inpatient 
group by Provider_Id
order by Provider_Id;
-- list of drg's involved in each particular provider 10001
select DRG_Definition from medicare.medicare_inpatient where Provider_Id=10001;

-- count of discharges per each drg
select DRG_definition,count(Total_Discharges) as count_of_discharges from medicare.medicare_inpatient 
group by DRG_Definition 
order by count_of_discharges desc;

-- accorging to the total no of discharges per drg(DRG_Definition),drg with maximum discharges is most coomom or top drg in usuage.
-- top 10 drg's /10 common drg's
select DRG_definition,count(Total_Discharges) as count_of_discharges from medicare.medicare_inpatient 
group by DRG_Definition 
order by count_of_discharges desc
limit 10;
-- top 10 drg's names
select DRG_Definition
from(select DRG_definition,count(Total_Discharges) as count_of_discharges from medicare.medicare_inpatient 
group by DRG_Definition 
order by count_of_discharges desc
limit 10) as sec;

-- medicare payment and average covered charges of top 10 drg's in each provider_Id( ids of medicare certified hopitals)
select m.Drg_Definition,m.Provider_Id,m.Average_Medicare_Payments,m.Average_Covered_Charges
from medicare.medicare_inpatient as m inner join (select DRG_definition,count(Total_Discharges) as count_of_discharges 
												from medicare.medicare_inpatient 
												group by DRG_Definition 
												order by count_of_discharges desc
												limit 10) as sec
                                                on m.DRG_Definition=sec.DRG_Definition;
 
 -- medicare payement and average covered charges of top 1 drg('871 - SEPTICEMIA OR SEVERE SEPSIS W/O MV >96 HOURS W MCC' in state CA
 select m.DRG_Definition,a.Provider_State,a.Provider_Name,m.Average_Covered_Charges,m.Average_Medicare_Payments
 from medicare.Providers as a inner join medicare.medicare_inpatient as m on a.Provider_Id=m.Provider_Id
 where Drg_Definition="871 - SEPTICEMIA OR SEVERE SEPSIS W/O MV >96 HOURS W MCC" and Provider_State="CA";
 
-- maximum medicare payment of each drg in top 10 drg's 
                                      
select m.Drg_Definition,max(m.Average_Medicare_Payments) as Average_Medicare_Payments
from medicare.medicare_inpatient as m inner join (select DRG_definition,count(Total_Discharges) as count_of_discharges 
												from medicare.medicare_inpatient 
												group by DRG_Definition 
												order by count_of_discharges desc
												limit 10) as sec
                                                on m.DRG_Definition=sec.DRG_Definition
                                                group by m.DRG_Definition;
                                                
-- after knowing maximum medicare payment of top 10 drg's 
 
-- the provider_id's of maximum medicare payments of each top 10 drg's(medicare_inpatient inner join maxs on average_medicare_payment &drg)

select e.DRG_Definition,e.Provider_Id,e.Average_Medicare_Payments 
from medicare.medicare_inpatient e
inner join(select m.DRG_Definition,max(m.Average_Medicare_Payments) as Average_Medicare_Payments
from medicare.medicare_inpatient as m inner join (select DRG_definition,count(Total_Discharges) as count_of_discharges 
												from medicare.medicare_inpatient 
												group by DRG_Definition 
												order by count_of_discharges desc
												limit 10) as sec
                                                on m.DRG_Definition=sec.DRG_Definition
                                                group by m.DRG_Definition
                                                order by Average_Medicare_Payments)as maxs
on e.Average_Medicare_Payments=maxs.Average_Medicare_Payments and e.DRG_Definition=maxs.DRG_Definition;

-- now i want to know  hosptial or state  where maximum medicare payment of top 10 occured 
                                          
select a.Provider_Id,a.Provider_Name,a.Provider_State,max1.DRG_Definition,max1.Average_Medicare_Payments
from medicare.Providers as a 
inner join(select e.DRG_Definition,e.Provider_Id,e.Average_Medicare_Payments 
from medicare.medicare_inpatient e
inner join(select m.DRG_Definition,max(m.Average_Medicare_Payments) as Average_Medicare_Payments
from medicare.medicare_inpatient as m inner join (select DRG_definition,count(Total_Discharges) as count_of_discharges 
												from medicare.medicare_inpatient 
												group by DRG_Definition 
												order by count_of_discharges desc
												limit 10) as sec
                                                on m.DRG_Definition=sec.DRG_Definition
                                                group by m.DRG_Definition
                                                order by Average_Medicare_Payments)as maxs
on e.Average_Medicare_Payments=maxs.Average_Medicare_Payments and e.DRG_Definition=maxs.DRG_Definition)as max1
on a.Provider_Id=max1.Provider_Id;
                                           


-- state vs average_medicare_payments
 
 -- what are medicare payments of top 10 drg's in state wise(since medicare payment decided by state's government)
 
-- top 10 drg's medicare_payment in each state and each hospital

select Provider_State,Provider_Name,DRG_Definition,Average_Medicare_Payments from medicare.Providers inner join medicare.medicare_inpatient
on Providers.provider_Id=medicare_inpatient.Provider_Id
where DRG_Definition IN(select DRG_Definition from(select DRG_definition,count(Total_Discharges) as count_of_discharges from medicare.medicare_inpatient 
													group by DRG_Definition 
													order by count_of_discharges desc
													limit 10)as sec)order by DRG_Definition desc;

-- what is the maximum medicare charges of each top 10 drg

-- maximum average_medicare_payment of each top 10 drg in each state
select DRG_Definition,Provider_State,max(Average_Medicare_Payments)from
(select Provider_State,Provider_Name,DRG_Definition,Average_Medicare_Payments from medicare.Providers inner join medicare.medicare_inpatient
on Providers.provider_Id=medicare_inpatient.Provider_Id
where DRG_Definition IN(select DRG_Definition from(select DRG_definition,count(Total_Discharges) as count_of_discharges from medicare.medicare_inpatient 
group by DRG_Definition 
order by count_of_discharges desc
limit 10)as sec)) as sec1 group by DRG_Definition,Provider_State
                          order by DRG_Definition;


-- after analysing medicare_inpatient data top 10 drg's ,its highest medicare payments,in which state highests and lowests occured are the information needed for further improvements

-- top 10 drg's
create view discharges as
select DRG_definition,count(Total_Discharges) as count_of_discharges from medicare.medicare_inpatient 
group by DRG_Definition 
order by count_of_discharges desc
limit 10;

-- maximum medicare payment of top 10 drg's 
create view highest_medicare_payments as
select m.Drg_Definition,max(m.Average_Medicare_Payments) as Average_Medicare_Payments
from medicare.medicare_inpatient as m inner join (select DRG_definition,count(Total_Discharges) as count_of_discharges 
												from medicare.medicare_inpatient 
												group by DRG_Definition 
												order by count_of_discharges desc
												limit 10) as sec
                                                on m.DRG_Definition=sec.DRG_Definition
                                                group by m.DRG_Definition;
                                                
-- finding average covered charges where highest medicare payments of top 10 drg's occured											
select b.DRG_Definition,a.Average_Covered_Charges,b.Average_Medicare_Payments
from medicare.medicare_inpatient as a inner join highest_medicare_payments as b
on a.Average_Medicare_Payments=b.Average_Medicare_Payments
and a.DRG_Definition=b.DRG_Definition;


-- provider names/hospital vs  average_covered_charges(since average_overed_charges different from hospital to hospital)

-- join provider and medicare tables to get state and average_medicare_pyment together
select Providers.Provider_Id,Provider_State,Provider_Name,DRG_Definition,Average_Covered_Charges from medicare.Providers inner join medicare.medicare_inpatient
 on Providers.provider_Id=medicare_inpatient.Provider_Id;
 
 -- what are the covered charges of top 10 drg's in each hospital/provider_name
create view covered_charges_of_top10 as
select Providers.Provider_Id,
Provider_State,
Provider_Name,
DRG_Definition,
Average_Covered_Charges 
from medicare.Providers inner join medicare.medicare_inpatient
on Providers.provider_Id=medicare_inpatient.Provider_Id
where DRG_Definition IN(select DRG_Definition from(select DRG_definition,count(Total_Discharges) as count_of_discharges from medicare.medicare_inpatient 
						   group by DRG_Definition 
						   order by count_of_discharges desc
						   limit 10)as sec);

select DRG_Definition,Provider_Name,Average_Covered_Charges from medicare.Providers inner join medicare.medicare_inpatient
on Providers.provider_Id=medicare_inpatient.Provider_Id
where DRG_Definition IN(select DRG_Definition from(select DRG_definition,count(Total_Discharges) as count_of_discharges from medicare.medicare_inpatient 
						   group by DRG_Definition 
						   order by count_of_discharges desc
						   limit 10)as sec) order by DRG_Definition;
                           
-- which hospital bills maximum covered charges(highest means costly hospital among all hospital) per each drg in top 10 drg's
select Drg_Definition,max(Average_Covered_Charges) as highest_covered_charges
from covered_charges_of_top10
group by Drg_Definition
order by highest_covered_charges desc;





