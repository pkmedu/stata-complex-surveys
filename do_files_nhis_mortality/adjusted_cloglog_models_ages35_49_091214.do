
capture log close age35_49
//clolog_attained_age_duration.do
clear
clear matrix
set more off
set linesize 255
use "E:\SASDATAMH\expand_data_final.dta"
log using "E:\Stata_mortality\age35_49.log", name (age35_49) replace

gen xaa_age_grp=. if a_age >= 18 & a_age <=34
replace xaa_age_grp=1 if a_age >=35 & a_age <=49
replace xaa_age_grp=2 if a_age >=50 & a_age <=69
replace xaa_age_grp=3 if a_age >=70 & a_age <=84
replace xaa_age_grp=. if a_age >=85
label define  xaa_age_grp_v 1 "35-49 Yrs" 2 "50-69 Yrs" 3 "70-84 Yrs" 
     label values xaa_age_grp xaa_age_grp_v
gen age_35_49= xaa_age==1 if !missing(xaa_age_grp)
gen age_50_69= xaa_age==2 if !missing(xaa_age_grp)
gen age_70_84= xaa_age==3 if !missing(xaa_age_grp)


gen age_5yr=a_age
replace age_5yr=. if a_age >= 18 & a_age <35  | a_age >=85
replace age_5yr=1 if a_age >=35 & a_age <40
replace age_5yr=2 if a_age >=40 & a_age <45
replace age_5yr=3 if a_age >=45 & a_age <50
replace age_5yr=4 if a_age >=50 & a_age <55
replace age_5yr=5 if a_age >=55 & a_age <60
replace age_5yr=6 if a_age >=60 & a_age <65
replace age_5yr=7 if a_age >=65 & a_age <70
replace age_5yr=8 if a_age >=70 & a_age <75
replace age_5yr=9 if a_age >=75 & a_age <80
replace age_5yr=10 if a_age >=80 & a_age <85

label define  age_5yr_vx 1 "35-39 Yrs" 2 "40-44 Yrs" 3 "45-49 Yrs" ///
             4 "50-54 Yrs" 5 "55-59 Yrs" 6 "60-64 Yrs"  ///
			 7 "65-69 Yrs" 8 "70-74 Yrs" 9 "75-79 Yrs" 10 "80-84 Yrs"
label values age_5yr age_5yr_vx


								 
//generate chronic1p  = xchronic
//recode   chronic1p  (2/3=1) (1=2)

//label define  chronic1p _lab 1 " 1+ Condition" 2 "None"
//label values  chronic1p  chronic1p _lab

//table age_5yr xspd2, by( xcigsmoke dead) contents(freq)
//table age_5yr xspd2, by(chronic1p  dead) contents(freq)
	 

fvset base 2 xspd2 chronic1p  racehisp bmicat 
fvset base 3 pa08_3r educ_cat
fvset base 1  xcigsmoke  xalcstat  
fvset base 4 poverty 

local demo i.dur_cat a_age i.sex i.racehisp i.marital
local ses  i.educ_cat  i.poverty 


svyset psu [pweight=wt8], strata (stratum) singleunit(missing)


capture noisily svy,subpop(age_35_49): cloglog dead `demo' i.xspd2, eform nolog
est store m1

capture noisily svy,subpop(age_35_49): cloglog dead `demo' `ses' i.xspd2 i.chronic1p, eform nolog
est store m2

capture noisily svy,subpop(age_35_49): cloglog dead `demo' `ses' i.xspd2 i.chronic1p i.xcigsmoke  i.xalcstat , eform nolog
est store m3

capture noisily svy,subpop(age_35_49): cloglog dead `demo' `ses' i.xspd2 i.chronic1p i.xcigsmoke  i.xalcstat i.bmicat, eform nolog
est store m4

estout m1 m2  m3 m4 using "E:\Stata_mortality\m1_2_3_4_ages35_49.txt", replace ///
cells("b(fmt(%5.2f) star) ci(par([  ,  ]) fmt(%6.2f))" ) eform ///
stats(N_sub, fmt(%12.0gc) labels("PY of obs")) ///
collabels("RR" "95% CI") drop(_cons) style(fixed)

capture noisily svy,subpop(age_35_49): cloglog dead `demo' `ses'  i.chronic1p, eform nolog
est store m5

capture noisily svy,subpop(age_35_49): cloglog dead `demo' `ses'  i.xcigsmoke, eform nolog
est store m6

capture noisily svy,subpop(age_35_49): cloglog dead `demo' `ses' i.xalcstat , eform nolog
est store m7

capture noisily svy,subpop(age_35_49): cloglog dead `demo' `ses' i.bmicat, eform nolog
est store m8

estout m5 m6  m7 m8 using "E:\Stata_mortality\m5_6_7_8_ages35_49.txt", replace ///
cells("b(fmt(%5.2f) star) ci(par([  ,  ]) fmt(%6.2f))" ) eform ///
stats(N_sub, fmt(%12.0gc) labels("PY of obs")) ///
collabels("RR" "95% CI") drop(_cons) style(fixed)


capture noisily svy,subpop(age_35_49): cloglog dead  i.xspd2, eform nolog
est store m9

capture noisily svy,subpop(age_35_49): cloglog dead  i.chronic1p, eform nolog
est store m10

capture noisily svy,subpop(age_35_49): cloglog dead  i.xcigsmoke, eform nolog
est store m11

capture noisily svy,subpop(age_35_49): cloglog dead  i.xalcstat , eform nolog
est store m12

capture noisily svy,subpop(age_35_49): cloglog dead  i.bmicat, eform nolog
est store m13

estout m9 m10 m11 m12 m13 using "E:\Stata_mortality\m9_thru_13_ages35_49.txt", replace ///
cells("b(fmt(%5.2f) star) ci(par([  ,  ]) fmt(%6.2f))" ) eform ///
stats(N_sub, fmt(%12.0gc) labels("PY of obs")) ///
collabels("RR" "95% CI") drop(_cons) style(fixed)

			
log close age35_49


