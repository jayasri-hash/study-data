# study-data

#  Medicare_inpatient_2017 Data exploration/descriptive analysis

-> Exploring the Data set Medicare_inpatient_2017 to analyse the Medicare market in different states for services(DRG Definitions) provided to the patients by providers(hospitals).

     Note: The state governmnet is the one who fixes the charge for particular service and hospital should accept that charge/price irrespective of how costly the service/treatment procedures are.

-> Analysing the medicare market effect on hospialfinancial status.



# what is this data set all about

Medicare_inpatient_2017:

Medicare - Health insurance program by government in united states to get free treatment in medicare certified hospitals.

inpatient - patient who stay in hospital while going through treatment
until discharged by doctor.

so,this data set is all about DRG's available under medicare program and its charges.

   hospitals certified by medicare to provide services given by medicare and their address,no of discharges,their charge per service,their total payment.

# Description of variables in data set

Data  file contains the following variables in 2 tables from medicare schema stored in mysql server:

Table1: Providers contains 3182rows X 7columns.

1.Provider Id(Primary key): The CMS Certification Number (CCN) assigned to the Medicare-certified hospital facility.

2.Provider Name: The name of the provider.(Hospitl name)

3.Provider Street Address: The provider’s street address.

4.Provider City: The city where the provider is located.

5.Provider State: The state where the provider is located.

6.Provider Zip Code: The provider’s zip code.

7.Provider HRR: The Hospital Referral Region (HRR) where the provider is located.

Table2: medicare_inpatient  contains 196325rows X 6columns 

1.DRG Definition:  DRGs are a classification system that groups similar clinical conditions (diagnoses) and the procedures furnished by the hospital during the stay.

2.Total Discharges: The number of discharges billed by the provider(hospital) for inpatient hospital services. 

3.Provider id(Foreign key): CNN number of a hospital given by medicare.

4.Average Covered Charges: The provider's average charge asked to pay by medicare for services covered by Medicare for all discharges in the DRG. These will vary from hospital to hospital because of differences in hospital charge structures.

5.Average Total Payments: total payment hospital collects from medicare for provided services ,other charges patient may responsible for.

6.Average Medicare Payments: The average amount that Medicare pays to the provider for Medicare's share of the DRG.

# Used technologies

sql language

Mysql server 8.0 
Download for windows- https://dev.mysql.com/downloads/mysql/

Mysql workbench 8.0 C E
Download for windows-https://downloads.mysql.com/archives/workbench/


## Note: Data exploration is like fetching answers by posing questions to database in the language which is understandable by the mysql server and that is sql language here.so questioning data what i want to know.

   Q-question
   
   A-answer&observation

# Questioning providers table

   Q-> no of hospitals in each state?

      using "group by" and aggregation function "count()"
      to find count of hospitals in each state

      group by Provider_State  
      count(Provider_Name) 

      A-> CA with 292 hospitals & state DE with 6
         so state with less no of hospitals have to
         improve medical facilities.

   Q ->which is most popular hospital with big count?

      group by Provider_Name 
      count(*)

      A->MEMORIAL HOSPITAL is the popular hospital
         with highest count.so the remaining hospitals
         can increase branches.
      
# Questioning medicare_inpatient table

   Q->no of Discharges per each DRG_Definition
  
     To know to which disease group more people are getting affected.

     group by DRG_Definition 
     count(Total_Discharges)
     limit 10   #to get top 10 most used DRG's

     A->
        DRG_definition                                                            count_of_discharges

        871 - SEPTICEMIA OR SEVERE SEPSIS W/O MV >96 HOURS W MCC                  2838
        291 - HEART FAILURE & SHOCK W MCC                                         2742
        190 - CHRONIC OBSTRUCTIVE PULMONARY DISEASE W MCC                         2687
        470 - MAJOR JOINT REPLACEMENT OR REATTACHMENT OF LOWER EXTREMITY W/O MCC  2666
        872 - SEPTICEMIA OR SEVERE SEPSIS W/O MV >96 HOURS W/O MCC                2632
        392 - ESOPHAGITIS, GASTROENT & MISC DIGEST DISORDERS W/O MCC              2586
        690 - KIDNEY & URINARY TRACT INFECTIONS W/O MCC                           2584
        194 - SIMPLE PNEUMONIA & PLEURISY W CC                                    2517
        189 - PULMONARY EDEMA & RESPIRATORY FAILURE                               2465
        603 - CELLULITIS W/O MCC                                                  2464

      "871 - SEPTICEMIA OR SEVERE SEPSIS W/O MV >96 HOURS W MCC" is the top 1 DRG_Definiton.so better to 
      keep an eye on material required for this treatment like earlier importing by checking shortage.

   Q->Maximum Average_Medicare_Payments of each top 10 DRG's
     
       "inner join" both medicare_inpatient data and top 10 Drg's data.
       MAX(m.Average_Medicare_Payments) # aggregation to find maximum medicare value of each top 10 DRG.

      A->
      Drg_Definition                                                            Average_Medicare_Payments

      189 - PULMONARY EDEMA & RESPIRATORY FAILURE                               79844.3
      190 - CHRONIC OBSTRUCTIVE PULMONARY DISEASE W MCC                         28406.1
      194 - SIMPLE PNEUMONIA & PLEURISY W CC                                    24004.8
      291 - HEART FAILURE & SHOCK W MCC                                         43072.8
      392 - ESOPHAGITIS, GASTROENT & MISC DIGEST DISORDERS W/O MCC              21646.8
      470 - MAJOR JOINT REPLACEMENT OR REATTACHMENT OF LOWER EXTREMITY W/O MCC  47995.6
      603 - CELLULITIS W/O MCC                                                  23268.8
      690 - KIDNEY & URINARY TRACT INFECTIONS W/O MCC                           23124.5
      871 - SEPTICEMIA OR SEVERE SEPSIS W/O MV >96 HOURS W MCC                  47487.9
      872 - SEPTICEMIA OR SEVERE SEPSIS W/O MV >96 HOURS W/O MCC                32076.7
 
      Mostly used top 1 DRG  "871 - SEPTICEMIA OR SEVERE SEPSIS W/O MV >96 HOURS W MCC"
      max medicare payment is 47487.9 which is less than pulmonary payment 79844.3.
      
      since top1 is most used government may reduced
      its price to make it easy for each common person.

      to find which government paying Average_Medicare_Payments
      47487.9/where maximum value occuring and what are rest of states paying to hospitals 
      for the top1 service, we need to join both tables.

# Questioning after joining both tables

   medicare market of 871 - SEPTICEMIA OR SEVERE SEPSIS W/O MV >96 HOURS W MCC
   
   Q->what are the states where maximum of Average_Medicare_Payments
     occured for each top 10 DRG.

       JOINING both top 10 drg's data with providers data
       using inner join.


       A->

          Provider_State  DRG_Definition                                                           Average_Medicare_Payments

          CA              194 - SIMPLE PNEUMONIA & PLEURISY W CC                                    24004.8
          CA              603 - CELLULITIS W/O MCC                                                  23268.8
          CA              190 - CHRONIC OBSTRUCTIVE PULMONARY DISEASE W MCC                         28406.1
          CA              291 - HEART FAILURE & SHOCK W MCC                                         43072.8
          CA              392 - ESOPHAGITIS, GASTROENT & MISC DIGEST DISORDERS W/O MCC              21646.8
          CA              690 - KIDNEY & URINARY TRACT INFECTIONS W/O MCC                           23124.5
          CA              872 - SEPTICEMIA OR SEVERE SEPSIS W/O MV >96 HOURS W/O MCC                32076.7
          IN              470 - MAJOR JOINT REPLACEMENT OR REATTACHMENT OF LOWER EXTREMITY W/O MCC  47995.6
          MD              871 - SEPTICEMIA OR SEVERE SEPSIS W/O MV >96 HOURS W MCC                  47487.9
          MD              189 - PULMONARY EDEMA & RESPIRATORY FAILURE                               79844.3
          
          so the state is MD for drg 871 - SEPTICEMIA OR SEVERE SEPSIS W/O MV >96 HOURS W MCC with  medicare_payment 47487.9
          
          MD fixes the price 47487.9 for top1 treatment.

   Q-> what is the Average_Covered_Charges of top 10 drg's where the maximums occured?


         JOINING the maximum average_medicare_payments of top 10 drg's data
          with medicare_inpatient table to get the Average_Covered_Charges.

         A->
         DRG_Definition                                                   Average_Covered_Charges    Average_Medicare_Payments

         194 - SIMPLE PNEUMONIA & PLEURISY W CC                                    44007.7                    24004.8
         603 - CELLULITIS W/O MCC                                                  59837.1                    23268.8
         190 - CHRONIC OBSTRUCTIVE PULMONARY DISEASE W MCC                         54924.6                    28406.1
         291 - HEART FAILURE & SHOCK W MCC                                         94295.6                    43072.8
         392 - ESOPHAGITIS, GASTROENT & MISC DIGEST DISORDERS W/O MCC              38437.1                    21646.8
         690 - KIDNEY & URINARY TRACT INFECTIONS W/O MCC                           44758.3                    23124.5
         872 - SEPTICEMIA OR SEVERE SEPSIS W/O MV >96 HOURS W/O MCC                64350.2                    32076.7
         470 - MAJOR JOINT REPLACEMENT OR REATTACHMENT OF LOWER EXTREMITY W/O MCC  158807                     47995.6
         871 - SEPTICEMIA OR SEVERE SEPSIS W/O MV >96 HOURS W MCC                  53820                      47487.9
         189 - PULMONARY EDEMA & RESPIRATORY FAILURE                               95823.5                    79844.3
       

       Average_Covered_Charges are charges hospitals asks medicare 
       to pay for provideing services freely under medicare insurance
       program.


       top1 service 871 - SEPTICEMIA OR SEVERE SEPSIS W/O MV >96 HOURS W MCC   Average_Medicare_Payments is 47487.9 which is fixed by government,
       where as Average_Covered_Charges hospital asks is 53820.


# Conclusion

       Average_Covered_Charges(53820)  >  Average_Medicare_Payments(47487.9)

       53820-47487.9=6332.1 
       so hospital losses 6332.1 Average_Covered_Charges
       for top1 service in state MD where medicare payment is 47487.9
       But this program helps poor to get costly treatment easly.

   


               

       

## Lessons Learned

Adding columns like

-> Population of each state
-> state budget for healthcare
-> total no of patient per each hospital in each day,month,year

   will be more useful to find reasons behind
   change in medicare_payments from state to state. 


         Thank u



