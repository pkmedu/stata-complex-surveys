
capture log close cloglog
//E:\SASDATAMH\mh_model.do
clear
clear matrix
set mem 1100m
set more off
set linesize 255
use "E:\SASDATAMH\expand_data.dta"
log using "E:\SASDATAMH\cloglog.log", name (cloglog) replace

describe

char xspd2 [omit] 2
char xsmoke [omit] 3
char racehisp [omit] 2
char bmicat [omit] 2


svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(missing)

//foreach spop of varlist a_age1844  a_age4554 a_age5564 a_age6574 a_age75p  {
foreach spop of varlist xa_age3544 xa_age4554 xa_age5564 xa_age6574 {
                        xa_age7584 {
capture noisily xi: svy: cloglog dead i.sex i.xspd2 i.xsmoke i.marital ///
                           i.racehisp i.educ_cat i.bmicat i.xchronic ///
				   dur1 dur2 dur3 dur4 dur5 dur6 dur7 dur8 dur9, eform nolog
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
capture la var dur1 "1-4 quarters"
capture la var dur2 "5-8 quarters"
capture la var dur3 "9-12 quarters"
capture la var dur4 "13-16 quarters"
capture la var dur5 "17-20 quarters"
capture la var dur6 "21-24 quarters"
capture la var dur7 "25-28 quarters"
capture la var dur8 "29-32 quarters"
capture la var dur9 "33-36 quarters"

est store `spop' 
}
//est table a_age1844  a_age4554 a_age5564 a_age6574 a_age75p, label  b(%5.2f)  star (.05 .01 .001) stats (N) eform    

est table xa_age3544 xa_age4554 xa_age5564 xa_age6574 xa_age7584,label  b(%5.2f)  star (.05 .01 .001) stats (N) eform
log close cloglog
