
capture log close cloglog
//E:\SASDATAMH\mh_model.do
clear
clear matrix
set mem 1100m
set more off
set linesize 255
use "E:\SASDATAMH\expand_data.dta"
log using "E:\SASDATAMH\cloglog.log", name (cloglog) replace

//describe

//format yq_int yq_dox %tq 
//list id yq_int yq_dox survtime_q dead j cum_j age_p att_age in 1/38
//describe

//summarize j if srvy_yr_n==1997, detail
//tab dead if dead==1


//foreach x of numlist 1997 1998 1999 2000 2001 2002 2003 2004 {
 //     summarize j if srvy_yr_n ==`x', 
//	    scalar max= r(max)
//	  	scalar list  max
//}

char xspd2 [omit] 2
char xsmoke [omit] 3
char racehisp [omit] 2
char bmicat [omit] 2


svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(missing)

foreach spop of varlist a_age1844  a_age4554 a_age5564 a_age6574 a_age75p  {
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
est table a_age1844  a_age4554 a_age5564 a_age6574 a_age75p, label  b(%5.2f)  star (.05 .01 .001) stats (N) eform    

log close cloglog
