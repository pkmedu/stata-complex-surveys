capture log close create_dd
clear
set mem 1100m
set more off
set linesize 255
use "H:\spd_mort_data_code\causes_added_data", clear
describe 
compress
log using "H:\spd_mort_data_code\content.log", name (create_dd) replace
describe
gen id = PUBLICID_2 

//convert character into numeric variable
gen srvy_yr_n = real(SRVY_YR)

gen xdthdate=.
replace xdthdate=dthdate if dthdate >intdate
replace xdthdate=dthdate+45 if dthdate ==intdate

gen dox=.
replace dox=xdthdate if mortstat==1
replace dox=enddate if mortstat==0


gen  yq_int = qofd(intdate)
gen  yq_dth = qofd(dthdate)
gen  yq_end = qofd(enddate)
gen  yq_dox = qofd(dox)
*gen  yq_dob = qofd(dob)

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


gen ta_age_grp=. if age_p >= 18 & age_p <=34
replace ta_age_grp=1 if age_p >=35 & age_p <=49
replace ta_age_grp=2 if age_p >=50 & age_p <=64
replace ta_age_grp=3 if age_p >=65 & age_p <=74
replace ta_age_grp=. if age_p >=75

recode cigsmoke_r2 (99=.), gen(cigsmoke_r2x)

gen lung_death =0
replace lung_death=1 if dead==1 & cig_dis==1  

gen m_cvd_death =0
replace m_cvd_death=1 if dead==1 & cig_dis==2  

gen pulmo_death =0
replace pulmo_death=1 if dead==1 & cig_dis==3 

gen other_death =0
replace other_death=1 if dead==1 & cig_dis==4 

gen lp_death =0
replace lp_death=1 if dead==1 & (cig_dis==1 | cig_dis==3)

gen lpc_death =0
replace lpc_death=1 if dead==1 & (cig_dis==1 | cig_dis==2 | cig_dis==3)


*run H:\spd_mort_data_code\xlabels.do
*run H:\spd_mort_data_code\du_cat_lab.do


#delimit cr
save "H:\spd_mort_data_code\expand_data_122314", replace
log close create_dd       



