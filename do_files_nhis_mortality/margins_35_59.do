
capture log close margins35_59
//clolog_attained_age_duration.do
clear
clear matrix
set more off
set linesize 255
use "E:\SASDATAMH\expand_short_data.dta"
log using "E:\Stata_mortality\margins35_59.log", name (margins35_59) replace

gen aa_age_grp=. if a_age >= 18 & a_age <=34
replace aa_age_grp=1 if a_age >=35 & a_age <=59
replace aa_age_grp=2 if a_age >=60 & a_age <=74
replace aa_age_grp=3 if a_age >=75 & a_age <=84
replace aa_age_grp=. if a_age >=85
label define  aa_age_grp_v 1 "35-59 Yrs" 2 "60-74 Yrs" 3 "75-84 Yrs" 
     label values aa_age_grp aa_age_grp_v
	 

	 
generate chronic1p = xchronic
recode   chronic1p (2/3=1) (1=2)

label define  chronic1p_lab 1 " 1+ Condition" 2 "None"
label values  chronic1p chronic1p_lab
//tab1 xchronic chronic1p	 
	 
gen age_35_59= aa_age==1 if !missing(aa_age_grp)
gen age_60_74= aa_age==2 if !missing(aa_age_grp)
gen age_75_84= aa_age==3 if !missing(aa_age_grp)

gen mage_35_59= aa_age==1 & sex==1 if !missing(aa_age_grp)
gen mage_60_74= aa_age==2 & sex==1 if !missing(aa_age_grp)
gen mage_75_84= aa_age==3 & sex==1 if !missing(aa_age_grp)

gen fage_35_59= aa_age==1 & sex==2 if !missing(aa_age_grp)
gen fage_60_74= aa_age==2 & sex==2 if !missing(aa_age_grp)
gen fage_75_84= aa_age==3 & sex==2 if !missing(aa_age_grp)

//table aa_age xspd2, by(xsmoke dead) contents(freq)
//table aa_age xspd2, by(chronic1p dead) contents(freq)


fvset base 2 xspd2 chronic1p racehisp bmicat
fvset base 3 xsmoke

local base_vars i.dur_cat i.sex i.xspd2
local base_smk i.dur_cat i.sex i.xspd2 i.xsmoke
local base_dis i.dur_cat i.sex i.xspd2 i.chronic1p 

local base_s_d i.dur_cat i.sex i.xspd2 i.xsmoke i.chronic1p 
local base_s_d_s  i.dur_cat i.sex i.xspd2 i.xsmoke i.chronic1p i.marital  i.educ_cat i.racehisp

local base_bmi i.dur_cat i.sex i.xspd2 i.bmi 
local base_s_dbmi i.dur_cat i.sex i.xspd2 i.xsmoke i.chronic1p i.bmi
local base_s_d_sb  i.dur_cat i.sex i.xspd2 i.xsmoke i.chronic1p i.bmi i.marital  i.educ_cat i.racehisp

svyset psu [pweight=wt8], strata (stratum) singleunit(missing)

capture noisily svy,subpop(age_35_59): cloglog dead `base_s_d_s', eform nolog
est store mm5

margins, at(xsmoke= (1 2 3) xspd2= (1 2))
margins, at(chronic1p= (1 2) xspd2= (1 2))


    
//estout m1 m2  m3 m4 m5 using "E:\Stata_mortality\models_ages35_59.txt", replace ///
//cells("b(fmt(%5.2f) star) ci(par([  ,  ]) fmt(%6.2f))" ) eform ///
//stats(N_sub, fmt(%12.0gc) labels("PY of obs")) ///
//collabels("RR" "95% CI") drop(_cons) style(fixed)


log close margins35_59

