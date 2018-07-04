capture log close cox
//G:\SASDATAMH\mh_model.do
clear
clear matrix
set mem 300m
set more off
set linesize 255
use "G:\SASDATAMH\forstata.dta"

compress
log using "G:\SASDATAMH\mh_model_rev.log", name (cox) replace

  replace interval =45 if interval ==0
     
  gen x_marital=marital
  replace x_marital=9 if marital ==.
  
  gen x_xsmoke=xsmoke
  replace x_xsmoke=9 if xsmoke ==. | xsmoke==4

  gen x_bmicat=bmicat
  replace x_bmicat=9 if bmicat ==.
  
   gen x_xchronic=xchronic
  replace x_xchronic=9 if xchronic ==.
  
  gen x_racehisp= racehisp
   replace x_racehisp=5 if racehisp==.

   gen x_educ_cat= educ_cat
   replace x_educ_cat=4 if educ_cat==.

  
//  tab1 interval x_marital x_xsmoke x_bmicat x_xchronic racehisp x_racehisp educ_cat x_educ_cat, m


gen a1844=0
replace a1844 = 1 if agegrp5==1

gen a4554=0
replace a4554 = 1 if  agegrp5==2

gen a5564=0
replace a5564 = 1 if  agegrp5==3

gen a6574=0
replace a6574 = 1 if agegrp5==4

gen a75p=0
replace a75p = 1 if agegrp5==5


gen time_yr=0
replace time_yr = ceil( (interval/30.5/12) )

gen xtime_yr=0
replace xtime_yr = time_yr+age_p


gen xa1844=0
replace xa1844 = 1 if xtime_yr >= 18 & xtime_yr <=44

gen xa4554=0
replace xa4554 = 1 if xtime_yr >= 45 & xtime_yr <=54

gen xa5564=0
replace xa5564 = 1 if xtime_yr >= 55 & xtime_yr <=64

gen xa6574=0
replace xa6574 = 1 if xtime_yr >= 65 & xtime_yr <=74

gen xa75p=0
replace xa75p = 1 if xtime_yr >= 75

tab1 xtime_yr

//tab1 xa1844 xa4554 xa5564 xa6574 xa75p



label define sexlab 1 "Male" 2 "Female"
label values sex sexlab



svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(missing)
stset xtime_yr [pweight=wt8], failure(mortstat==1) 
foreach spop of varlist xa1844     {
capture noisily: svy, subpop(`spop'): stcox i.sex ib2.xspd2 ib3.xsmoke i.marital ///
                                   i.racehisp i.educ_cat ib2.bmicat i.xchronic 
		
	}	

predict ch, basechazard
predict s, basesurv
summarize ch s
stcurve, hazard


log close cox       

svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(missing)
stset time_yr [pweight=wt8], failure(mortstat==1) 
foreach spop of varlist a1844 a4554 a5564 a6574 a75p {
   foreach ib1ref of varlist sex  x_marital x_racehisp x_educ_cat x_xchronic {                                  
                 capture noisily: svy, subpop(`spop'): stcox i.`ib1ref' 
	}		
}	







foreach spop of varlist a1844 a4554 a5564 a6574 a75p {
   foreach ib2ref of varlist xspd2 x_bmicat {                                  
                 capture noisily: svy, subpop(`spop'): stcox ib2.`ib2ref' 
	}		
}

foreach spop of varlist a1844 a4554 a5564 a6574 a75p {
   foreach ib3ref of varlist x_xsmoke  {                           
                 capture noisily: svy, subpop(`spop'): stcox ib3.`ib3ref' 
	}		
}

foreach spop of varlist a1844 a4554 a5564 a6574 a75p  {
capture noisily: svy, subpop(`spop'): stcox i.sex ib2.xspd2 ib3.x_xsmoke i.x_marital ///
                                   i.x_racehisp i.x_educ_cat ib2.x_bmicat i.x_xchronic 
	}	
log close cox       


