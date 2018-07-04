capture log close cox
//G:\SASDATAMH\mh_model.do
clear
clear matrix
set mem 300m
set more off
set linesize 255
use "G:\spd_no_spd_surv.dta"
describe
compress
log using "G:\SASDATAMH\surv.log", name (cox) replace

scalar drop _all

foreach var of varlist _t surv2 surv3 {
      summarize `var', detail
      scalar min_`var' = r(min)
	  scalar max_`var' = r(max)
	  	scalar list  min_`var'  max_`var'
}

scalar list 
list if surv2 >=.50 & surv2<=.51

di 1/(-(1/_t)*(ln(sum(surv2))))

di 1/(-(1/_t)*(ln(sum(surv3))))
