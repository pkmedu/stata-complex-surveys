
capture log close age35_59
//clolog_attained_age_duration.do
clear
clear matrix
set more off
set linesize 255
use "E:\SASDATAMH\expand_short_data.dta"
log using "E:\Stata_mortality\age35_59.log", name (age35_59) replace

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


gen spd=0 if xspd2==2
replace spd=1 if xspd2==1

gen female=0 if sex==1
replace female=1 if sex==2

gen curr_smk=0  if xsmoke==2 | xsmoke==3
replace curr_smk=1  if xsmoke==1

gen form_smk=0  if xsmoke==1 | xsmoke==3
replace form_smk=1  if xsmoke==2

gen con=0 if chronic1p==2
replace con=1 if chronic1p==1


tab1 xspd2 spd  xsmoke curr_smk form_smk sex female ///
  chronic1p con 

svyset psu [pweight=wt8], strata (stratum) singleunit(missing)


capture noisily svy,subpop(age_60_74): cloglog dead ///
i.dur_cat female spd curr_smk form_smk spd##curr_smk, eform nolog
est store xm60_74_1

capture noisily svy,subpop(age_60_74): cloglog dead ///
i.dur_cat female spd curr_smk form_smk spd##sex, eform nolog
est store xm60_74_2

capture noisily svy,subpop(age_75_84): cloglog dead ///
i.dur_cat female spd curr_smk form_smk spd##curr_smk, eform nolog
est store xm75_84_1

capture noisily svy,subpop(age_75_84): cloglog dead ///
i.dur_cat female spd curr_smk form_smk spd##sex, eform nolog
est store xm75_84_2


local base_vars i.dur_cat i.sex i.xspd2
local base_smk i.dur_cat i.sex i.xspd2 i.xsmoke
local base_dis i.dur_cat i.sex i.xspd2 i.chronic1p 

local base_s_d i.dur_cat i.sex i.xspd2 i.xsmoke i.chronic1p 
local base_s_d_s  i.dur_cat i.sex i.xspd2 i.xsmoke i.chronic1p i.marital  i.educ_cat i.racehisp

local base_bmi i.dur_cat i.sex i.xspd2 i.bmi 
local base_s_dbmi i.dur_cat i.sex i.xspd2 i.xsmoke i.chronic1p i.bmi
local base_s_d_sb  i.dur_cat i.sex i.xspd2 i.xsmoke i.chronic1p i.bmi i.marital  i.educ_cat i.racehisp

svyset psu [pweight=wt8], strata (stratum) singleunit(missing)


capture noisily svy,subpop(age_35_59): cloglog dead `base_vars', eform nolog
est store m1 

capture noisily svy,subpop(age_35_59): cloglog dead `base_smk', eform nolog
est store m2

capture noisily svy,subpop(age_35_59): cloglog dead `base_dis', eform nolog
est store m3 

capture noisily svy,subpop(age_35_59): cloglog dead `base_s_d', eform nolog
est store m4
 
capture noisily svy,subpop(age_35_59): cloglog dead `base_s_d_s', eform nolog
est store m5
    
estout m1 m2  m3 m4 m5 using "E:\Stata_mortality\models_ages35_59.txt", replace ///
cells("b(fmt(%5.2f) star) ci(par([  ,  ]) fmt(%6.2f))" ) eform ///
stats(N_sub, fmt(%12.0gc) labels("PY of obs")) ///
collabels("RR" "95% CI") drop(_cons) style(fixed)

capture noisily svy,subpop(age_35_59): cloglog dead `base_bmi', eform nolog
est store m6

capture noisily svy,subpop(age_35_59): cloglog dead `base_s_dbmi', eform nolog
est store m7

capture noisily svy,subpop(age_35_59): cloglog dead `base_s_d_sb', eform nolog
est store m8

estout m6 m7 m8 using "E:\Stata_mortality\m6_7_8_ages35_59.txt", replace ///
cells("b(fmt(%5.2f) star) ci(par([  ,  ]) fmt(%6.2f))" ) eform ///
stats(N_sub, fmt(%12.0gc) labels("PY of obs")) ///
collabels("RR" "95% CI") drop(_cons) style(fixed)
			
log close age35_59

