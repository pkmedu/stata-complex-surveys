
capture log close cloglog
//G:\SASDATAMH\mh_model.do
clear
clear matrix
set mem 1100m
set matsize 2000
set more off
set linesize 255
use "G:\SASDATAMH\expand_data.dta"
log using "G:\SASDATAMH\cloglog.log", name (cloglog) replace





char xspd2 [omit] 2
char xsmoke [omit] 3
char racehisp [omit] 2
char bmicat [omit] 2



svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(missing)
capture noisily xi: svy: cloglog dead i.sex i.xspd2 i.xsmoke i.marital ///
                           i.racehisp i.educ_cat i.bmicat i.xchronic, eform nolog
 
capture la var _Isex_2 "Female"	
capture la var _Ixspd2_1 "Serious Psy Distress"
capture la var _Ixsmoke_1 "Current Smoker"
capture la var _Ixsmoke_2 "Former Smoker"
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

est store m1


svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(missing)
capture noisily xi: svy: cloglog dead j2 i.sex i.xspd2 i.xsmoke i.marital ///
                                   i.racehisp i.educ_cat i.bmicat i.xchronic , eform nolog
 capture la var lnj "j2"	
 capture la var _Isex_2 "Female"	
capture la var _Ixspd2_1 "Serious Psy Distress"
capture la var _Ixsmoke_1 "Current Smoker"
capture la var _Ixsmoke_2 "Former Smoker"
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

est store m3 

est table m1 m2 m3, label  b(%5.2f)  star (.05 .01 .001) stats (N) eform 

 
log close cloglog
