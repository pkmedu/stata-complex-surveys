
capture log close short
//discrete_short_data.do
clear
clear matrix
set mem 1000m
set more off
set linesize 255
use "E:\SASDATAMH\expand_data.dta"
log using "E:\SASDATAMH\short.log", name (short) replace


keep dead j cum_stime_yrs   ///
     a_age a_age_grp xa_age_grp xa_age1824 xa_age2534 xa_age3544 xa_age4554 xa_age5564  xa_age6574 xa_age7584 ///
	 xa_age85p sex xspd2 xsmoke marital racehisp educ_cat bmicat xchronic age_p dur_cat psu wt8 ///
	 stratum id yq_int yq_dox ta_age_grp ya_age_grp
	 
	 /*
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
	*/
compress 

tab1 xspd2 sex xsmoke marital racehisp educ_cat bmicat xchronic

save "E:\SASDATAMH\expand_short_data", replace
log close short 

use "E:\SASDATAMH\expand_short_data"

format yq_int yq_dox %tq

list yq_int yq_dox dead j  dur_cat age_p cum_stime_yrs a_age a_age_grp ///
    if id=="19970286710102", noobs compress

list yq_int yq_dox dead j  dur_cat age_p cum_stime_yrs a_age a_age_grp  ///
    if id=="20040167390101", noobs compress
 
 list yq_int yq_dox dead j  dur_cat age_p cum_stime_yrs a_age a_age_grp  ///
    if id =="19970305650101", noobs compress
	
	

