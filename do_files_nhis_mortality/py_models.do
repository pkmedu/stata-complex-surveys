
capture log close cloglog
//clolog_attained_age_duration.do
clear
clear matrix
set mem 1100m
set more off
set linesize 255
use "E:\SASDATAMH\py_expand_data.dta"
log using "E:\SASDATAMH\cloglog.log", name (cloglog) replace

/*
gen dead100k = dead*100000
svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(missing)
     svy, subpop(`spop'): mean dead100k, over (a_age_grp)
	 svy, subpop(xa_age2534): mean dead, over (sex)  
     svy, subpop(xa_age2534): mean dead, over (xspd2) 
	 svy, subpop(xa_age2534): mean dead, over (xsmoke) 
     svy, subpop(xa_age2534): mean dead, over (xspd2 sex xsmoke)  
  
*run the model for the 25-34 years agr group
capture noisily svy,subpop(xa_age2534): cloglog dead i.sex ib2.xspd2 ib3.xsmoke, eform nolog
  est store test

margins sex xspd2 xsmoke 
margins sex, atmeans
margins sex, at(xspd2=1 xsmoke=1) 
margins sex, at(xspd2=1 xsmoke=3) 
margins sex, at(xspd2=2 xsmoke=1) 
margins sex, at(xspd2=2 xsmoke=3)
*/
svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(missing)
capture noisily svy: cloglog dead i.sex ib2.xspd2 ib3.xsmoke  ///
             ib2.racehisp i.educ_cat i.bmicat i.xchronic i.dur_cat i.a_age_grp , eform nolog

  est store m1
  
  est table m1, label  b(%5.2f) star (.05 .01 .001) stats (N_sub) stfmt (%11.0gc) eform 		



svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(missing)	 
char xspd2 [omit] 2
char xsmoke [omit] 3
char racehisp [omit] 2
char bmicat [omit] 2
capture noisily xi: svy,subpop( if a_age>=25 & a_age<=84): cloglog dead i.sex i.xspd2 i.xsmoke i.marital ///
                           i.racehisp i.educ_cat i.bmicat i.xchronic i.xa_age_grp i.dur_cat, nolog
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
capture la var _Ixchronic_3 "2+ Conditions"
capture la var _Ixa_age_grp_2 "Att Age 35-44 Yrs"
capture la var _Ixa_age_grp_3 "Att Age 45-54 Yrs"
capture la var _Ixa_age_grp_4 "Att Age 55-64 Yrs"
capture la var _Ixa_age_grp_5 "Att Age 65-74 Yrs"
capture la var _Ixa_age_grp_6 "Att Age 75-84 Yrs"
capture la var _Idur_cat_2 "SurvDur 1-5 Yrs"
capture la var _Idur_cat_3 "SurvDur 6-7 Yrs"
capture la var _Idur_cat_4 "SurvDur 8-9 Yrs"
capture la var _Idur_cat_5 "SurvDur 10 Yrs"

 est store py						   
  
*/
svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(missing)
 capture noisily xi: svy,subpop( if a_age>=25 & a_age<=84): cloglog dead i.sex ib2.xspd2 ib3.xsmoke i.marital ///
                           ib2.racehisp i.educ_cat ib2.bmicat i.xchronic i.xa_age_grp i.dur_cat, nolog
 est store xtest
  
  est table xtest, label  b(%5.2f) star (.05 .01 .001) stats (N_sub) stfmt (%11.0gc) eform 
  
  margins, at( xsmoke= (1 3) xspd2= (1 2) )
  
  margins  xspd2 xsmoke, atmeans
  
  //margins xspd2 , at(xa_age_grp=(1 2 3 4 5 6))
						   
/*
preserve
drop _all
set obs 1
gen byte sex = 2
expand 2
gen byte xspd2 = _n
//label value xspd2 xspd2_lab
predict pr
list xspd2 pr
restore
*/
 
 *run models for the remaining years agr group - with one additional covariate i.marital
foreach spop of varlist xa_age2534 xa_age3544 xa_age4554 xa_age5564  xa_age6574 xa_age7584  {
capture noisily xi: svy,subpop(`spop'): cloglog dead i.sex i.xspd2 i.xsmoke i.marital ///
                           i.racehisp i.educ_cat i.bmicat i.xchronic i.dur_cat, eform nolog
						   
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
capture la var _Ixchronic_3 "2+ Conditions"
capture la var _Idur_cat_2 "SurvDur 1.75-3.00 Yrs"
capture la var _Idur_cat_3 "SurvDur 3.25-5.00 Yrs"
capture la var _Idur_cat_4 "SurvDur 5.25-9.75 Yrs"
est store `spop'
} 
est table xa_age2534 xa_age3544 xa_age4554 xa_age5564  xa_age6574 xa_age7584, label  b(%5.2f) ///
  star (.05 .01 .001) stats (N_sub) stfmt (%11.0gc) eform   

log close cloglog


