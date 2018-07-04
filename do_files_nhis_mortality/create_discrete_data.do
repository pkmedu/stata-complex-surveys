capture log close create_dd
//crrate_discrete_data.do
clear
clear matrix
clear
set mem 1100m
set more off
set linesize 255
use "E:\SASDATAMH\forstata.dta"
describe 
compress
log using "E:\SASDATAMH\content.log", name (create_dd) replace

describe
drop flagsub smk_cc  xsmk_cc compo indi_obs surv2yrs  interval  surv5yrs ///
     ypll ypll_75  ypll_ler prematur~l_flag prematur~5_flag prematur~r_flag ///
	 


rename publicid_2 id 


//change 'current smoking status unknown' to missing
replace xsmoke =. if xsmoke==4

//convert character into numeric variable
gen srvy_yr_n = real(srvy_yr)


gen  yq_int = qofd(intdate)
gen  yq_dth = qofd(dthdate)
gen  yq_end = qofd(enddate)
gen  yq_dox = qofd(dox)
gen  yq_dob = qofd(dob)

// create survival time

gen survtime_q = yq_dox - yq_int
recode survtime_q (0=1)

summarize survtime_q 


drop dob intdate dox dthdate enddate dox yq_dob yq_dth yq_end smoke chronic SPD2 

describe

expand survtime_q

compress

bysort id: ge j= _n
lab var j "spell quarter"

//convert j into years
gen survtime_y = j/4

bysort id: ge dead= mortstat==1 & _n==_N
lab var dead "binary dep var for discrete hazard model"
drop mortstat

//create lag for j (duration: quarter-year) & cumulate j and then express in years by id
bysort id: ge cum_j=j[_n-1]

replace cum_j = 1 if yq_int==yq_dox 

gen cum_stime_yrs = cum_j/4


//calculate attained age by adding the cumulated survival time (in years)with age at interview by id
bysort id: ge a_age = cum_stime_yrs + age_p
replace a_age = age_p if a_age ==.


// create a 8-catgory attained age variable
gen a_age_grp=1 if a_age >= 18 & a_age <=24
replace a_age_grp=2 if a_age >=25 & a_age <=34
replace a_age_grp=3 if a_age >=35 & a_age <=44
replace a_age_grp=4 if a_age >=45 & a_age <=54
replace a_age_grp=5 if a_age >=55 & a_age <=64
replace a_age_grp=6 if a_age >=65 & a_age <=74
replace a_age_grp=7 if a_age >=75 & a_age <=84
replace a_age_grp=8 if a_age >=85


//create dummy variables for attained age
gen xa_age1824 = a_age_grp==1
gen xa_age2534 = a_age_grp==2
gen xa_age3544 = a_age_grp==3
gen xa_age4554 = a_age_grp==4
gen xa_age5564 = a_age_grp==5
gen xa_age6574 = a_age_grp==6
gen xa_age7584 = a_age_grp==7
gen xa_age85p = a_age_grp==8


// define label  and label values for a_age_grp
label define ///
    a_age_grp_v 1 "18-24 Yrs" 2 "25-34 Yrs" 3 "35-44 Yrs" ///
           4 "45-54 Yrs" 5 "55-64 Yrs" 6 "65-74 Yrs" 7 "75-84 Yrs" 8 "85+ Yrs"
label values a_age_grp a_age_grp_v



//create a 6-catgory attained age variable
gen xa_age_grp=. if a_age >= 18 & a_age <=24
replace xa_age_grp=1 if a_age >=25 & a_age <=34
replace xa_age_grp=2 if a_age >=35 & a_age <=44
replace xa_age_grp=3 if a_age >=45 & a_age <=54
replace xa_age_grp=4 if a_age >=55 & a_age <=64
replace xa_age_grp=5 if a_age >=65 & a_age <=74
replace xa_age_grp=6 if a_age >=75 & a_age <=84
replace xa_age_grp=. if a_age >=85

label define ///
    xa_age_grp_v 1 "25-34 Yrs" 2 "35-44 Yrs" ///
           3 "45-54 Yrs" 4 "55-64 Yrs" 5 "65-74 Yrs" 6 "75-84 Yrs" 
label values xa_age_grp xa_age_grp_v


tab xa_age_grp

gen dur_cat=1 if survtime_y <=1.50
replace dur_cat=2 if survtime_y>=1.75 & survtime_y<=3.00
replace dur_cat=3 if survtime_y>=3.25 & survtime_y<=5.00
replace dur_cat=4 if survtime_y>=5.25 & survtime_y<=9.75


// define label  and label values for survtime_y
label define ///
    dur_cat_v 1 "<=1.50 Yrs" 2 "1.75-3.00 Yrs" 3 "3.25-5.00 Yrs" ///
           4 "5.25-9.75 Yrs"
label values dur_cat dur_cat_v
tab dur_cat
tab dur_cat dead
table a_age_grp dead
table xa_age_grp dead

//create a 3-catgory attained age variable
gen ta_age_grp=. if a_age >= 18 & a_age <=24
replace ta_age_grp=1 if a_age >=25 & a_age <=44
replace ta_age_grp=2 if a_age >=45 & a_age <=64
replace ta_age_grp=3 if a_age >=65 & a_age <=84
replace ta_age_grp=. if a_age >=85
label define  ta_age_grp_v 1 "25-44 Yrs" 2 "45-64 Yrs" 3 "65-84 Yrs" 
     label values ta_age_grp ta_age_grp_v


//create a 3-catgory attained age variable (alternative)
gen ya_age_grp=. if a_age >= 18 & a_age <=24
replace ya_age_grp=1 if a_age >=25 & a_age <=44
replace ya_age_grp=2 if a_age >=45 & a_age <=64
replace ya_age_grp=3 if a_age >=65 & a_age <=74
replace ya_age_grp=. if a_age >=75
label define  ya_age_grp_v 1 "25-44 Yrs" 2 "45-64 Yrs" 3 "65-74 Yrs" 
     label values ya_age_grp ya_age_grp_v

//create a 3-catgory second attained age variable (alternative)
gen za_age_grp=. if a_age >= 18 & a_age <=34
replace za_age_grp=1 if a_age >=35 & a_age <=44
replace za_age_grp=2 if a_age >=45 & a_age <=54
replace za_age_grp=3 if a_age >=55 & a_age <=64
replace za_age_grp=4 if a_age >=65 & a_age <=74
replace za_age_grp=5 if a_age >=75 & a_age <=84
replace za_age_grp=. if a_age >=85
label define  za_age_grp_v 1 "35-44 Yrs" 2 "45-54 Yrs" 3 "55-64 Yrs"  4 "65-74 Yrs" 3 "75-84 Yrs"
     label values za_age_grp za_age_grp_v




	 
	 
	 label define xspd2_lab 1 "Serious Psy Distress" 2 "No SPD"
     label values xspd2 xspd2_lab

	 label define sex_lab 1 "Male" 2 "Female"
     label values sex sex_lab
	 
	 label define xsmoke_lab 1 "Current Smoker" 2 "Former Smoker" 3 "Never Smoker"
     label values xsmoke xsmoke_lab
	 
	 label define marital_lab 1 "Married" 2 "Div/Sep" 3 "Widow" 4 "Never Married"
     label values marital marital_lab
	 
	 label define racehisp_lab 1 "Hispanic" 2 "NH White" 3 "NH Black" 4 "NH Other"
     label values racehisp racehisp_lab
	
	 label define educ_cat_lab 1 "Below Hi Sch" 2 "High Scool Grad." 3 "College Grad/Higher"
     label values educ_cat educ_cat_lab
	
	 label define bmicat_lab 1 "Underweight" 2 "Normal" 3 "Overweight" 4 "Obese"
     label values bmicat bmicat_lab
	 
	 label define xchronic 1 "None" 2 "1 Condition" 3 "2+ Conditions"
     label values xchronic xchronic_lab
	 
 
	 table xa_age_grp xspd2, by(dead) contents(freq)
	 table ta_age_grp xspd2, by(dead) contents(freq)
	 table ta_age_grp xspd2, by(xsmoke dead) contents(freq)
	 
	 table xa_age_grp sex xspd2, by(dead) contents(freq)
	 table ta_age_grp sex xspd2, by(dead) contents(freq)
	 table ta_age_grp sex xspd2, by(xsmoke dead) contents(freq)
	 
	 
	 table xa_age_grp xspd2, by(xspd2) contents(freq)
	 table ta_age_grp xspd2, by(xspd2) contents(freq)
	 table ta_age_grp xspd2, by(xsmoke) contents(freq)

	 table ya_age_grp sex xspd2, by(dead) contents(freq)
	 table ya_age_grp sex xspd2, by(xsmoke dead) contents(freq)
	 table ya_age_grp xspd2, by(xspd2) contents(freq)
	 table ya_age_grp xspd2, by(xsmoke) contents(freq)


compress


save "E:\SASDATAMH\expand_data", replace

log close create_dd       



