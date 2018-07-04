
capture log close inter_ages50_74
clear
set more off

use "H:\spd_mort_data_code\py_working_file2.dta"

*log using "H:\spd_mort_results\inter_ages50_74.log", name (inter_ages50_74) replace

generate XSPD4 = SPD4+1


  label define spd4_lab ///  
			1 "K6 0"  ///
	        2 "K6 1-5" ///   
	        3 "K6 6-10" ///   
	        4 "K6 11-24" 
	 label values  XSPD4 spd4_lab

 tab XSPD4

 

gen y_age_grp=. if age_p >= 18 & age_p <=49
replace y_age_grp=1 if age_p >=50 & age_p <=54
replace y_age_grp=2 if age_p >=55 & age_p <=59
replace y_age_grp=3 if age_p >=60 & age_p <=64
replace y_age_grp=4 if age_p >=65 & age_p <=69
replace y_age_grp=5 if age_p >=70 & age_p <=74
replace y_age_grp=. if age_p >=75



label define y_age_lab 1 "50-54 Yrs"  2 "55-59 Yrs" 3 "60-64 Yrs" ///
                       4 "65-69 Yrs" 5 "70-74 Yrs"
label values y_age_grp y_age_lab

tab y_age_grp dead

tab1 y_age_grp, missing

log close inter_ages50_74


