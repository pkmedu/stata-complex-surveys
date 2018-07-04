
capture log close cox
//G:\SASDATAMH\mh_model.do
clear
clear matrix
set mem 300m
set more off
set linesize 255
use "G:\SASDATAMH\forstata.dta"

compress
log using "G:\SASDATAMH\mh_model.log", name (cox) replace
tab mortstat if xsmoke==1

gen currsmk=0
replace currsmk = 1 if xsmoke==1

gen frmsmk=0
replace frmsmk = 1 if xsmoke==2

gen nevsmk=0
replace nevsmk = 1 if xsmoke==3


gen male_currsmk=0
replace male_currsmk = 1 if sex==1 & xsmoke==1
gen female_currsmk=0
replace female_currsmk = 1 if sex==2 & xsmoke==1

gen male_frmsmk=0
replace male_frmsmk = 1 if sex==1 & xsmoke==2
gen female_frmsmk=0
replace female_frmsmk = 1 if sex==2 & xsmoke==2


gen male_nevsmk=0
replace male_nevsmk = 1 if sex==2 & xsmoke==3
gen female_nevsmk=0
replace female_nevsmk = 1 if sex==2 & xsmoke==3

table xspd2

foreach gvar of varlist currsmk frmsmk nevsmk male_currsmk female_currsmk ///
 male_frmsmk female_frmsmk male_nevsmk female_nevsmk {
table `gvar' mortstat, contents(freq)
}



svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(missing)
  stset interval [pweight=wt8], failure(mortstat==1)  
    capture noisily: svy: stcox ib2.xspd2 ib4.xsmoke i.agegrp5
	                            ib2.xspd2#ib4.xsmoke
								ib2.xspd2#i.agegrp5
								ib2.xsmoke#i.agegrp5
	                            ib2.xspd2#ib4.xsmoke#i.agegrp5
	                   
					  // i.marital i.racehisp i.educ_cat ib2.bmicat i.xchronic 
									 
								margins xspd2 ib4.xsmoke i.agegrp5, vce(unconditional) 
								margins, vce(unconditional) dydx(xspd2) 
								 
								
								 
								
		 
// estimates store results
// capture estout results								  
                            	
log close cox       


