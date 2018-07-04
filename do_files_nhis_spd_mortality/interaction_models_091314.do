capture log close x23interaction
clear
clear matrix
set more off
set linesize 255
use "E:\SASDATAMH\expand_data_final.dta", clear
log using "E:\Stata_mortality\xinteraction.log", name (xinteraction) replace

gen xaa_age_grp=. if a_age >= 18 & a_age <=34
replace xaa_age_grp=1 if a_age >=35 & a_age <=49
replace xaa_age_grp=2 if a_age >=50 & a_age <=69
replace xaa_age_grp=3 if a_age >=70 & a_age <=84
replace xaa_age_grp=. if a_age >=85

label define  xaa_age_grp_v 1 "35-49 Yrs" 2 "50-69 Yrs" 3 "70-84 Yrs" 
     label values xaa_age_grp xaa_age_grp_v


								 
fvset base 2 xspd2 chronic1p  racehisp bmicat 
fvset base 3 pa08_3r educ_cat
fvset base 1  xcigsmoke  xalcstat  xaa_age_grp
fvset base 4 poverty 

local demo i.dur_cat a_age i.sex i.racehisp i.marital
local ses  i.educ_cat  i.poverty 

svyset psu [pweight=wt8], strata (stratum) singleunit(missing)


foreach xaa_age_grp in 1  2 3 {
     display _newline(2) _column(30) "Interaction Model (SPD and Selected Vars) for Age Group `xaa_age_grp'"
   foreach var of varlist sex chronic1p xcigsmoke xalcstat bmicat {
        display _newline(2) _column(30) "Interaction Model (SPD and Selected Vars) for Age Group `xaa_age_grp'"
		capture noisily svy,subpop(if xaa_age_grp== `xaa_age_grp'): cloglog dead xspd2##i.`var', eform nolog
		est store `var'Xspd_`xaa_age_grp'
	}
}

foreach var of varlist sex chronic1p xcigsmoke xalcstat bmicat {
	estout `var'Xspd_1 `var'Xspd_2 `var'Xspd_3 using "E:\Stata_mortality\Xmodels2.txt", replace ///
	cells("b(fmt(%5.2f) star) ci(par([  ,  ]) fmt(%6.2f))" ) eform ///
	stats(N_sub, fmt(%12.0gc) labels("PY of obs")) ///
	collabels("RR" "95% CI") drop(_cons) style(fixed)
}


 //foreach var of varlist xspd2 chronic1p xcigsmoke xalcstat bmicat {
	//    display _newline(2) _column(30) "Interaction Model (Age and Selected Vars)"
	//	capture noisily svy: cloglog dead i.xaa_age_grp##i.`var', eform nolog
		est store `var'Xage
	//}


//foreach var of varlist xspd2 chronic1p xcigsmoke xalcstat bmicat {
//	estout `var'Xage `var'Xage `var'Xage `var'Xage `var'Xage using "E:\Stata_mortality\Xmodels1.txt", replace ///
//	cells("b(fmt(%5.2f) star) ci(par([  ,  ]) fmt(%6.2f))" ) eform ///
//	stats(N_sub, fmt(%12.0gc) labels("PY of obs")) ///
//	collabels("RR" "95% CI") drop(_cons) style(fixed)
//}





	
log close xinteraction


