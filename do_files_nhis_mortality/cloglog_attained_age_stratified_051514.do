
capture log close cloglog
//clolog_attained_age_duration.do
clear
clear matrix
set mem 1100m
set more off
set linesize 255
use "E:\SASDATAMH\expand_short_data.dta"
log using "E:\SASDATAMH\cloglog.log", name (cloglog) replace

describe
tab1 xchronic

gen aa_age_grp=. if a_age >= 18 & a_age <=34
replace aa_age_grp=1 if a_age >=35 & a_age <=59
replace aa_age_grp=2 if a_age >=60 & a_age <=74
replace aa_age_grp=3 if a_age >=75 & a_age <=84
replace aa_age_grp=. if a_age >=85
label define  aa_age_grp_v 1 "35-59 Yrs" 2 "60-74 Yrs" 3 "75-84 Yrs" 
     label values aa_age_grp aa_age_grp_v
	 

drop chronic1p	 
generate chronic1p = xchronic
recode   chronic1p (2/3=1) (1=2)

label define  chronic1p_lab 1 " 1+ Condition" 2 "None"
label values  chronic1p chronic1p_lab
tab1 xchronic chronic1p	 
	 
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


char xspd2 [omit] 2
char chronic1p [omit] 2
char xsmoke [omit] 3
char racehisp [omit] 2
char bmicat [omit] 2


local smk_control i.xsmoke
local dis_control i.chronic1p 
local ses_control i.marital i.racehisp i.educ_cat

svyset psu [pweight=wt8], strata (stratum) singleunit(missing)

foreach spop of varlist mage_35_59 mage_60_74 mage_75_84 fage_35_59 fage_60_74 fage_75_84 {
capture noisily xi: svy,subpop(`spop'): cloglog dead i.dur_cat i.xspd2 ///
                         `smk_control' `dis_control' i.marital	i.educ_cat i.racehisp ///
						 ,eform nolog
						 
						 
						 
						   
//capture la var _Isex_2 "Female"	
capture la var _Ixspd2_1 "Serious Psy Distress"
capture la var _Ixsmoke_1 "Current Smoker"
capture la var _Ixsmoke_2 "Former Smoker"
capture la var _Ibmicat_1 "Underweight"
capture la var _Ibmicat_3 "Overweight"
capture la var _Ibmicat_4 "Obese"
capture la var _Ichronic1p "1+ Condition"
capture la var _Ichronic1p "None"
capture la var _Ixchronic_3 "2+ Conditions"
capture la var _Imarital_2 "Div/Sep" 
capture la var _Imarital_3 "Widow" 
capture la var _Imarital_4 "Never Married" 
capture la var _Iracehisp_1 "Hispanic"
capture la var _Iracehisp_3 "NH Black" 
capture la var _Iracehisp_4 "NH Other"
capture la var _Ieduc_cat_2 "Hi Sch Grad"                                                                              
capture la var _Ieduc_cat_3 "College Grad"                                                                              
capture la var _Idur_cat_2 "SurvDur 1.75-3.00 Yrs"
capture la var _Idur_cat_3 "SurvDur 3.25-5.00 Yrs"
capture la var _Idur_cat_4 "SurvDur 5.25-9.75 Yrs"

est store `spop'
} 
est table mage_35_59 mage_60_74 mage_75_84 fage_35_59 fage_60_74 fage_75_84, b(%5.2f) ///
  star (.05 .01 .001) stats (N_sub) stfmt (%11.0gc) eform   
log close cloglog


