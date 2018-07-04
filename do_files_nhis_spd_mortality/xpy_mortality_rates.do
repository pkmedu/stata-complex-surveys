
capture log close xrates
//clolog_attained_age_duration.do
clear
set more off
set linesize 255
use "H:\spd_mort_data_code\py_working_file"
log using "H:\spd_mort_data_code\xcontent.log", name (xrates) replace



gen std_wgt = .5207 if aa_age_grp ==1
replace std_wgt = .3327 if aa_age_grp ==2
replace std_wgt = .1465 if aa_age_grp ==3

 gen xaa_age_grp=. if age_p >= 18 & age_p <=49
replace xaa_age_grp=1 if age_p >=50 & age_p <=64
replace xaa_age_grp=2 if age_p >=65 & age_p <=74
replace xaa_age_grp=. if age_p >=85
 
 gen xstd_wgt = 0.694 if aa_age_grp ==1
replace xstd_wgt = 0.306 if aa_age_grp ==2

 
 
recode dead (.=0), gen(xdead) 

tab1 xdead
gen xd1000 = xdead*1000

svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(centered)

svy, subpop(if age_p>=35 & age_p<=74): mean xd1000

svy, subpop(if age_p>=35 & age_p<=74): mean xd1000, over (aa_age_grp)


svy, subpop (if age_p>=35 & age_p<=74): mean xd1000, stdize(aa_age_grp) stdweight(std_wgt) ///
      over (sex)
		
svy, subpop (if age_p>=50 & age_p<=74): mean xd1000, stdize(xaa_age_grp) stdweight(xstd_wgt) ///
      over (sex)
	  
log close xrates


