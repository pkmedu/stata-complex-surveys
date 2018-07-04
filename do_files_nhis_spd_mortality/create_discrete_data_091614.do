capture log close create_dd
clear
set mem 1100m
set more off
set linesize 255
use "E:\SASDATAMH\indi_data", clear
describe 
compress
log using "E:\SASDATAMH\content.log", name (create_dd) replace
describe
gen id = publicid_2

//convert character into numeric variable
gen srvy_yr_n = real(srvy_yr)
gen xdthdate=.
replace xdthdate=dthdate if dthdate >intdate
replace xdthdate=dthdate+45 if dthdate ==intdate
gen  yq_int = qofd(intdate)
gen  yq_dth = qofd(dthdate)
gen  yq_end = qofd(enddate)
gen  yq_dox = qofd(dox)
gen  yq_dob = qofd(dob)

// create survival time
gen survtime_q = yq_dox - yq_int
recode survtime_q (0=1)
summarize survtime_q 
describe
expand survtime_q
compress
bysort id: ge j= _n
lab var j "spell quarter"

//convert j into years
gen survtime_y = j/4
bysort id: ge dead= mortstat==1 & _n==_N
lab var dead "binary dep var for discrete hazard model"
drop mortstat

//create lag for j (duration: quarter-year) & cumulate j and then express in years by id
bysort id: ge cum_j=j[_n-1]
replace cum_j = 1 if yq_int==yq_dox 
gen cum_stime_yrs = cum_j/4
//calculate attained age by adding the cumulated survival time (in years)with age at interview by id
bysort id: ge a_age = cum_stime_yrs + age_p
replace a_age = age_p if a_age ==.

gen dur_cat=1 if survtime_y <=1.50
replace dur_cat=2 if survtime_y>=1.75 & survtime_y<=3.00
replace dur_cat=3 if survtime_y>=3.25 & survtime_y<=5.00
replace dur_cat=4 if survtime_y>=5.25 & survtime_y<=9.75

run E:\Stata_mortality\py_labels.do

#delimit cr
save "E:\SASDATAMH\expand_data_final", replace
log close create_dd       



