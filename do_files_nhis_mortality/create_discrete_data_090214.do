capture log close create_dd
//crrate_discrete_data.do
clear
clear matrix
clear
set mem 1100m
set more off
set linesize 255
use "E:\SASDATAMH\forstata_rev"
describe 
compress
log using "E:\SASDATAMH\content.log", name (create_dd) replace

describe
 
 gen id = publicid_2
 
//convert character into numeric variable
gen srvy_yr_n = real(srvy_yr)

gen xdthdate=.
replace xdthdate=dthdate if dthdate >intdate
replace xdthdate=dthdate+45 if dthdate ==intdate


gen  yq_int = qofd(intdate)
gen  yq_dth = qofd(dthdate)
gen  yq_end = qofd(enddate)
gen  yq_dox = qofd(dox)
gen  yq_dob = qofd(dob)

// create survival time

gen survtime_q = yq_dox - yq_int
recode survtime_q (0=1)

summarize survtime_q 

*drop dob intdate dox dthdate enddate dox yq_dob yq_dth yq_end smoke chronic SPD2 

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
label define  za_age_grp_v 1 "35-44 Yrs" 2 "45-54 Yrs" 3 "55-64 Yrs"  4 "65-74 Yrs" 5 "75-84 Yrs"
     label values za_age_grp za_age_grp_v


recode   chronic (1/2=1) (0=2), gen(chronic1p)


gen under_wt = 0 if bmicat==2 | bmicat==3 | bmicat==4
replace  under_wt =1 if bmicat==1

gen over_wt = 0 if bmicat==1 | bmicat==2 | bmicat==4
replace   over_wt =1 if bmicat==3 

gen obese = 0 if bmicat==1 | bmicat==2 | bmicat==3
replace   obese =1 if bmicat==4

gen over_obese = 0 if bmicat==1 | bmicat==2 
replace   over_obese =1 if bmicat==3 | bmicat==4

 *cigarette use - current use unknown, former cig use quantity unknown, and cig use status unknown overall => 99
 recode cigsmoke (4 10 99 = 99) , gen(cigsmoke_r)
 
 *cigarette use - former intensity combined => 4, current use unknown & current cig use status unknown => 99
 recode cigsmoke   (5 6 7 8 9 10=4) (4 99 = 99), gen(cigsmoke_r2)
 
 
 *current alc use freq unknown, former alc use freq unknown, and alc use status unknown overall => 99
 recode alcstat (4 9 10 = 99), gen(alcstat_r)

 *former status => combined; current alc use freq unknown, and alc use status unknown overall => 99
 recode alcstat (2 3 4=2) (9 10 = 99) , gen(alcstat_r2)


     label define alcstat_lab   1 "Lifetime Abstainer:<12 life"  ///  
	                           2 "Former infrequent: <12 1yr"  ///
							   3  "Former regular: >=12 1 yr" ///
	                           4  "Former, frequency unknown"  ///
					           5  "Current infrequent: <12 pst yr"  ///
							   6  "Current Light: <=3/wk" ///
                               7  "Current Moderate: F>3-7wk/M>3-14wk" ///
							   8 "Current Heavy: F>7wk/M>14wk"   ///
							   9 "Current, frequency unknown"  ///
							   10 "Drinking status unknown" 
     label values alcstat alcstat_lab


	 label define alcstat_r_lab   1 "Lifetime Abstainer:<12 life"  ///
	                             2 "Former infrequent: <12 1yr" ///
	                             3  "Former regular: >=12 1 yr" ///
	                             5  "Current infrequent: <12 pst yr" /// 
						         6  "Current Light: <=3/wk" ///
                                 7  "Current Moderate: F>3-7wk/M>3-14wk"  ///
					             8 "Current Heavy: F>7wk/M>14wk"   ///
					            99 "Unknown (curr former overall)" 
     label values alcstat_r alcstat_r_lab
	 
	 label define alcstat_r2_lab   1 "Lifetime Abstainer:<12 life" ///
	                              2 "Former" ///
	                              5  "Current infrequent: <12 pst yr" ///
					   	          6  "Current Light: <=3/wk" ///
                                  7  "Current Moderate: F>3-7wk/M>3-14wk"  ///
					              8 "Current Heavy: F>7wk/M>14wk"  ///
					             99 "Unknown (curr former overall)" 
     label values alcstat_r2 alcstat_r2_lab
   
   
     label define cigsmoke_lab   1 "Never"  ///
	                             2 "Current <1 pack per day"   ///
	                           3 "Current 1+ packs per day"  ///
	                         4 "Current CIGSDAY unk" ///
                            5 "Former quit 0–4 years ago" ///
							6 "Former quit 5–9 years ago" ///
							7 "Former quit 10–19 years ago"  ///
                            8 "Former quit 20–29 years ago" ///
							9 "Former quit 30+ years ago" ///
							10 "Former SMKQTY unk" ///
							99 "Unk"
     label values  cigsmoke cigsmoke_lab

	 label define cigsmoke_r_lab   1 "Never"  ///
	                               2 "Current <1 pack per day"  ///
	                               3 "Current 1+ packs per day"   ///
                                   5 "Former quit 0–4 years ago"  ///
					        	   6 "Former quit 5–9 years ago"  /// 
					      		   7 "Former quit 10–19 years ago"  ///
                                   8 "Former quit 20–29 years ago" ///
							       9 "Former quit 30+ years ago"  ///
							       99 "Unknown (curr former oveall)"
     label values  cigsmoke_r cigsmoke_r_lab
	 
	 label define cigsmoke_r2_lab   1 "Never" ///
	                                2 "Current <1 pack per day"   ///
	                                3 "Current 1+ packs per day"   ///
                                    4 "Former"  ///
							        99 "Unknown (curr oveall)"
     label values  cigsmoke_r2 cigsmoke_r2_lab
	 
 
     label define pa08_3r_lab    1 "Inactive (No Activity)"  ///
	                            2 "Insufficiently Aactive (<150 Min/Wk)" ///
	                            3 "Sufficiently Active (150+ Min/Wk)"  
     label values pa08_3r pa08_3r_lab

     label define pa08_4r_lab   1 "Inactive (None)" ///	 	 
	                            2 "Insufficiently Active (<150 Min/Wk)"  ///
	                            3 "Sufficiently Active (150<=Min/Wk<=300)"  ///
	                            4 "Highly Active (>300 Min/Wk)" 
     label values pa08_4r pa08_4r_lab
 
     label define  chronic1p_lab 1 " 1+ Condition" 2 "None"
     label values  chronic1p chronic1p_lab
	 	  
	 label define xspd2_lab 1 "Serious Psy Distress" 2 "No SPD"
     label values xspd2 xspd2_lab

	 label define sex_lab 1 "Male" 2 "Female"
     label values sex sex_lab
	 
	 
	 label define marital_lab 1 "Married" 2 "Div/Sep" 3 "Widow" 4 "Never Married"
     label values marital marital_lab
	 
	 label define racehisp_lab 1 "Hispanic" 2 "NH White" 3 "NH Black" 4 "NH Other"
     label values racehisp racehisp_lab
	
	 label define educ_cat_lab 1 "Below Hi Sch" 2 "High Scool Grad." 3 "College Grad/Higher"
     label values educ_cat educ_cat_lab
	
	 label define bmicat_lab 1 "Underweight" 2 "Normal" 3 "Overweight" 4 "Obese"
     label values bmicat bmicat_lab
	 
     
  label define smoke_lab ///
    1  "Current every day smoker" ///
    2  "Current some day smoker"  ///
    3  "Former smoker"  ///
    4  "Never smoker"  ///
    5  "Smoker current status unknown"  
    
	label values smoke smoke_lab	 
	 
 
	 table xa_age_grp xspd2, by(dead) contents(freq)
	 table ta_age_grp xspd2, by(dead) contents(freq)
	 table ta_age_grp xspd2, by(cigsmoke_r2 dead) contents(freq)
	 
	 table xa_age_grp sex xspd2, by(dead) contents(freq)
	 table ta_age_grp sex xspd2, by(dead) contents(freq)
	 table ta_age_grp sex xspd2, by(cigsmoke_r2 dead) contents(freq)
	 
	 
	 table xa_age_grp xspd2, by(xspd2) contents(freq)
	 table ta_age_grp xspd2, by(xspd2) contents(freq)
	 table ta_age_grp xspd2, by(cigsmoke_r2) contents(freq)

	 table ya_age_grp sex xspd2, by(dead) contents(freq)
	 table ya_age_grp sex xspd2, by(cigsmoke_r2 dead) contents(freq)	 
	 table ya_age_grp xspd2, by(xspd2) contents(freq)
	 table ya_age_grp xspd2, by(cigsmoke_r2) contents(freq)
	 
	 
	 table za_age_grp sex xspd2, by(dead) contents(freq)
	 table za_age_grp sex xspd2, by(cigsmoke_r2 dead) contents(freq)	 
	 table za_age_grp xspd2, by(xspd2) contents(freq)
	 table za_age_grp xspd2, by(cigsmoke_r2) contents(freq)

compress

tab1 smoke cigsmoke, missing

save "E:\SASDATAMH\expand_data_final", replace

log close create_dd       



