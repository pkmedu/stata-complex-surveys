
capture log close age35_84
//clolog_attained_age_duration.do
clear
clear matrix
set more off
set linesize 255
use "E:\SASDATAMH\expand_short_data.dta"
log using "E:\Stata_mortality\age35_84.log", name (age35_84) replace

gen f_age_grp=. if a_age >= 18 & a_age <=34
replace f_age_grp=1 if a_age >=35 & a_age <=44
replace f_age_grp=2 if a_age >=45 & a_age <=54
replace f_age_grp=3 if a_age >=55 & a_age <=64
replace f_age_grp=4 if a_age >=65 & a_age <=74
replace f_age_grp=5 if a_age >=75 & a_age <=84
replace f_age_grp=. if a_age >=85

label define  f_age_grp_v 1 "35-44 Yrs" 2 "45-54 Yrs" 3 "55-64 Yrs" ///
                           4 "65-74 Yrs" 5 "75-84 Yrs"
     label values f_age_grp f_age_grp_v 


gen age_35_84=1 if f_age_grp >= 1 & f_age_grp <=5

tab1 f_age_grp a_age_grp  age_35_84 bmicat
	 
	 
generate chronic1p = xchronic
recode   chronic1p (2/3=1) (1=2)

label define  chronic1p_lab 1 " 1+ Condition" 2 "None"
label values  chronic1p chronic1p_lab
//tab1 xchronic chronic1p	 


//table aa_age xspd2, by(xsmoke dead) contents(freq)
//table aa_age xspd2, by(chronic1p dead) contents(freq)


fvset base 2 xspd2 chronic1p racehisp bmicat
fvset base 3 xsmoke

local base_vars i.dur_cat i.f_age_grp i.sex i.xspd2
local base_smk i.dur_cat i.f_age_grp i.sex i.xspd2 i.xsmoke
local base_dis i.dur_cat i.f_age_grp i.sex i.xspd2 i.chronic1p 
local base_s_d i.dur_cat i.f_age_grp i.sex i.xspd2 i.xsmoke i.chronic1p 
local base_s_db i.dur_cat i.f_age_grp i.sex i.xspd2 i.xsmoke i.chronic1p i.bmicat
local base_s_d_s  i.dur_cat i.f_age_grp i.sex i.xspd2 i.xsmoke i.chronic1p i.marital  i.educ_cat i.racehisp

svyset psu [pweight=wt8], strata (stratum) singleunit(missing)


capture noisily svy,subpop(age_35_84): cloglog dead `base_vars', eform nolog
est store m1 

capture noisily svy,subpop(age_35_84): cloglog dead `base_smk', eform nolog
est store m2

capture noisily svy,subpop(age_35_84): cloglog dead `base_dis', eform nolog
est store m3 

capture noisily svy,subpop(age_35_84): cloglog dead `base_s_d', eform nolog
est store m4
 
capture noisily svy,subpop(age_35_84): cloglog dead `base_s_db', eform nolog
est store m5 

capture noisily svy,subpop(age_35_84): cloglog dead `base_s_d_s', eform nolog
est store m6
    
estout m1 m2  m3 m4 m5 using "E:\Stata_mortality\models_ages35_84.txt", replace ///
cells("b(fmt(%5.2f) star) ci(par([  ,  ]) fmt(%6.2f))" ) eform ///
stats(N_sub, fmt(%12.0gc) labels("PY of obs")) ///
collabels("RR" "95% CI") drop(_cons) style(fixed)

estout m6 using "E:\Stata_mortality\m6_ages35_84.txt", replace ///
cells("b(fmt(%5.2f) star) ci(par([  ,  ]) fmt(%6.2f))" ) eform ///
stats(N_sub, fmt(%12.0gc) labels("PY of obs")) ///
collabels("RR" "95% CI") drop(_cons) style(fixed)


			
log close age35_84

