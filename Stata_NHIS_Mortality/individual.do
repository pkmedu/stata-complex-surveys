
capture log close indi
//discrete_short_data.do
clear
clear matrix
set more off
set linesize 255
use "E:\SASDATAMH\forstata.dta"

describe
log using "E:\SASDATAMH\indi.log", name (indi) replace


gen aa_age_grp=. if age_p >= 18 & age_p <=34
replace aa_age_grp=1 if age_p >=35 & age_p <=59
replace aa_age_grp=2 if age_p >=60 & age_p <=74
replace aa_age_grp=3 if age_p >=75 & age_p <=84
replace aa_age_grp=. if age_p >=85
label define  aa_age_grp_v 1 "35-59 Yrs" 2 "60-74 Yrs" 3 "75-84 Yrs" 
     label values aa_age_grp aa_age_grp_v

gen age_35_59= aa_age==1 if !missing(aa_age_grp)
gen age_60_74= aa_age==2 if !missing(aa_age_grp)
gen age_75_84= aa_age==3 if !missing(aa_age_grp)

gen curr_smk=0  if xsmoke==2 | xsmoke==3
replace curr_smk=1  if xsmoke==1

gen form_smk=0  if xsmoke==1 | xsmoke==3
replace form_smk=1  if xsmoke==2
	 
generate chronic1p = xchronic
recode   chronic1p (2/3=1) (1=0)

     label define  chronic1p_lab 1 " 1+ Condition" 2 "None"
     label values  chronic1p chronic1p_lab
	 	  
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
	
compress 

tab1 aa_age_grp xspd2 sex xsmoke curr_smk form_smk chronic1p marital racehisp educ_cat 

keep mortstat srvy_yr curr_smk form_smk ///
     age_p aa_age_grp age_35_59 age_60_74 age_75_84 ///
	 xspd2 xsmoke chronic1p marital racehisp educ_cat bmicat xchronic  ///
	 psu wt8 stratum 

save "E:\SASDATAMH\indi_data", replace
log close indi 

	
	

