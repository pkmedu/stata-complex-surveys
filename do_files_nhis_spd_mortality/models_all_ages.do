
capture log close all_ages
clear
clear matrix
set more off
set linesize 255
use "E:\SASDATAMH\expand_data_final.dta"
log using "E:\Stata_mortality\all_ages.log", name (all_ages) replace

gen xaa_age_grp=. if a_age >= 18 & a_age <=34
replace xaa_age_grp=1 if a_age >=35 & a_age <=49
replace xaa_age_grp=2 if a_age >=50 & a_age <=69
replace xaa_age_grp=3 if a_age >=70 & a_age <=84
replace xaa_age_grp=. if a_age >=85

label define  xaa_age_grp_v 1 "35-49 Yrs" 2 "50-69 Yrs" 3 "70-84 Yrs" 
     label values xaa_age_grp xaa_age_grp_v

// list of key variables
//dur_cat a_age xaa_age_grp sex racehisp marital i.educ_cat  i.poverty
//xspd2 chronic1p  racehisp bmicat pa08_3r xcigsmoke  xalcstat
								 
fvset base 2 xspd2 chronic1p  racehisp bmicat 
fvset base 3 pa08_3r educ_cat
fvset base 1  xcigsmoke  xalcstat  
fvset base 4 poverty 

local demo i.dur_cat a_age i.sex i.racehisp i.marital
local ses  i.educ_cat  i.poverty 

svyset psu [pweight=wt8], strata (stratum) singleunit(missing)

foreach xaa_age_grp in 1  2 3 {
     display _newline(2) _column(40) "Behavioral Model for xaa_age_grp== `xaa_age_grp'"
   foreach var of varlist xspd2 chronic1p xcigsmoke xalcstat bmicat pa08_3r {
	    display _newline(2) _column(40) "Behavioral Model for xaa_age_grp== `xaa_age_grp'"
		capture noisily svy,subpop(if xaa_age_grp== `xaa_age_grp'): cloglog dead i.`var', eform nolog
		est store `var'_m`xaa_age_grp'
	}
}

foreach var of varlist xspd2 chronic1p xcigsmoke xalcstat bmicat pa08_3r {
	estout `var'_m1 `var'_m2 `var'_m3 using "E:\Stata_mortality\`var'_Age1_2_3.txt", replace ///
	cells("b(fmt(%5.2f) star) ci(par([  ,  ]) fmt(%6.2f))" ) eform ///
	stats(N_sub, fmt(%12.0gc) labels("PY of obs")) ///
	collabels("RR" "95% CI") drop(_cons) style(fixed)
}


foreach xaa_age_grp in 1  2 3 {
     display _newline(2) _column(40) "Demographic and Behavioral Model for xaa_age_grp== `xaa_age_grp'"
   foreach var of varlist xspd2 chronic1p xcigsmoke xalcstat bmicat pa08_3r {
        display _newline(2) _column(40) "Demographic and Behavioral Model for xaa_age_grp== `xaa_age_grp'"
		capture noisily svy,subpop(if xaa_age_grp== `xaa_age_grp'): cloglog dead `demo' i.`var', eform nolog
		est store demo_`var'_m`xaa_age_grp'
	}
}

foreach var of varlist xspd2 chronic1p xcigsmoke xalcstat bmicat pa08_3r {
	estout demo_`var'_m1 demo_`var'_m2 demo_`var'_m3 using "E:\Stata_mortality\dem_`var'_Age1_2_3.txt", replace ///
	cells("b(fmt(%5.2f) star) ci(par([  ,  ]) fmt(%6.2f))" ) eform ///
	stats(N_sub, fmt(%12.0gc) labels("PY of obs")) ///
	collabels("RR" "95% CI") drop(_cons) style(fixed)
}


foreach xaa_age_grp in 1  2 3 {
     display _newline(2) _column(40) "Demographic-SES-Behavioral Model for xaa_age_grp== `xaa_age_grp'"
   foreach xvar of varlist chronic1p xcigsmoke xalcstat bmicat pa08_3r {
	    display _newline(2) _column(40) "Demographic-SES-Behavioral Model for xaa_age_grp== `xaa_age_grp'"
		capture noisily svy,subpop(if xaa_age_grp== `xaa_age_grp'): cloglog dead `demo' `ses' i.xspd2 i.`xvar', eform nolog
		est store ds_`xvar'_m`xaa_age_grp'
	}
}

foreach xvar of varlist chronic1p xcigsmoke xalcstat bmicat  pa08_3r {
	estout ds_`xvar'_m1 ds_`xvar'_m2 ds_`xvar'_m3 using "E:\Stata_mortality\ds_`xvar'_Age1_2_3.txt", replace ///
	cells("b(fmt(%5.2f) star) ci(par([  ,  ]) fmt(%6.2f))" ) eform ///
	stats(N_sub, fmt(%12.0gc) labels("PY of obs")) ///
	collabels("RR" "95% CI") drop(_cons) style(fixed)
}

foreach xaa_age_grp in 1  2 3 {
     display _newline(2) _column(40) "Final Model for xaa_age_grp== `xaa_age_grp'"
   		capture noisily svy,subpop(if xaa_age_grp== `xaa_age_grp'): cloglog dead `demo' `ses' i.xspd2  ///
		              i.chronic1p i.xcigsmoke i.xalcstat i.bmicat pa08_3r, eform nolog
		est store dsf_m`xaa_age_grp'
	}


foreach xvar of varlist chronic1p xcigsmoke xalcstat bmicat pa08_3r {
	estout dsf_m1 dsf_m2 dsf_m3 using "E:\Stata_mortality\ds_`xvar'_Age1_2_3.txt", replace ///
	cells("b(fmt(%5.2f) star) ci(par([  ,  ]) fmt(%6.2f))" ) eform ///
	stats(N_sub, fmt(%12.0gc) labels("PY of obs")) ///
	collabels("RR" "95% CI") drop(_cons) style(fixed)
}
			
log close all_ages


