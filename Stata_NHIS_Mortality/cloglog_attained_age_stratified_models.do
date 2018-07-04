
capture log close cloglog
//clolog_attained_age_duration.do
clear
clear matrix
set mem 1100m
set more off
set linesize 255
use "E:\SASDATAMH\expand_short_data.dta"
log using "E:\SASDATAMH\cloglog.log", name (cloglog) replace

tab dur_cat
char xspd2 [omit] 2
char xsmoke [omit] 3
char racehisp [omit] 2
char bmicat [omit] 2

svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(missing)
foreach x of numlist 1  2 3  {
capture noisily xi: svy,subpop(if ya_age_grp ==`x' & xsmoke==3): cloglog dead i.sex i.xspd2 i.marital ///
                           i.racehisp i.educ_cat i.bmicat i.xchronic /// 
						    i.dur_cat ,eform nolog

							   
capture la var _Isex_2 "Female"	
capture la var _Ixspd2_1 "Serious Psy Distress"
//capture la var _Ixsmoke_1 "Current Smoker"
//capture la var _Ixsmoke_2 "Former Smoker"
capture la var _Imarital_2 "Div/Sep" 
capture la var _Imarital_3 "Widow" 
capture la var _Imarital_4 "Never Married" 
capture la var _Iracehisp_1 "Hispanic"
capture la var _Iracehisp_3 "NH Black" 
capture la var _Iracehisp_4 "NH Other"
capture la var _Ieduc_cat_2 "Hi Sch Grad"                                                                              
capture la var _Ieduc_cat_3 "College Grad"                                                                              
capture la var _Ibmicat_1 "Underweight"
capture la var _Ibmicat_3 "Overweight"
capture la var _Ibmicat_4 "Obese"
capture la var _Ixchronic_2 "1 Condition"
capture la var _Ixchronic_3 "2+ Conditions"
capture la var _Ixchronic_3 "2+ Conditions"
capture la var _Idur_cat_2 "SurvDur 1.75-3.00 Yrs"
capture la var _Idur_cat_3 "SurvDur 3.25-5.00 Yrs"
capture la var _Idur_cat_4 "SurvDur 5.25-9.75 Yrs"
est store m`x'
} 
est table m1 m2 m3, label  b(%5.2f) ///
  star (.05 .01 .001) stats (N_sub) stfmt (%11.0gc) eform   

log close cloglog


