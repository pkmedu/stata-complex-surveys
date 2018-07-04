
capture log close cloglog
//clolog_attained_age_duration.do
clear
clear matrix
set mem 1100m
set more off
set linesize 255
use "E:\SASDATAMH\expand_short_data.dta"
log using "E:\SASDATAMH\cloglog.log", name (cloglog) replace

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

local smk_control i.xsmoke
local dis_control i.chronic1p 
local ses_control i.marital i.racehisp i.educ_cat

svyset psu [pweight=wt8], strata (stratum) singleunit(missing)


foreach spop of varlist age_35_59 age_60_74 age_75_84 {
foreach indvar of varlist xspd2 xsmoke chronic1p sex marital racehisp educ_cat dur_cat {
capture noisily svy,subpop(`spop'): cloglog dead i.`indvar', eform nolog
margins `indvar' 
margins `indvar', atmeans
margins, dydx(`indvar')
                       }                                                    
                     }
					
log close cloglog


