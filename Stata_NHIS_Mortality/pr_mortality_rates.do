
capture log close rates
//clolog_attained_age_duration.do
clear
clear matrix
set mem 1100m
set more off
set linesize 255
use "E:\SASDATAMH\expand_data.dta"
log using "E:\SASDATAMH\rates.log", name (rates) replace


gen d100k = dead*100000
svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(missing)
 svy: mean d100k, over (ta_age_grp)
 svy: mean d100k, over (xspd2 ta_age_grp)
 svy: mean d100k, over (xspd2 xsmoke ta_age_grp)
 
 svy: mean d100k, over (sex ta_age_grp)
 svy: mean d100k, over (sex xspd2 ta_age_grp)
 svy: mean d100k, over (sex xspd2 xsmoke ta_age_grp)
 
 	 
  
log close rates


