
capture log close ages35_84
clear
set more off

use "E:\spd_mort_data_code\expand_data_final.dta"


log using "E:\spd_mort_results\ages35_84.log", name (ages35_84) replace


gen xaa_age_grp=. if a_age >= 18 & a_age <=34
replace xaa_age_grp=1 if a_age >=35 & a_age <=49
replace xaa_age_grp=2 if a_age >=50 & a_age <=69
replace xaa_age_grp=3 if a_age >=70 & a_age <=84
replace xaa_age_grp=. if a_age >=85

label define  xaa_age_grp_v 1 "35-49 Yrs" 2 "50-69 Yrs" 3 "70-84 Yrs" 
     label values xaa_age_grp xaa_age_grp_v

recode sex (1=1)(2=0), gen(male)
recode racehisp (1=1)(2/4=0), gen(white)
recode racehisp (3=1)(1 2 4=0), gen(black)


// list of key variables
//dur_cat a_age xaa_age_grp sex racehisp marital i.educ_cat  i.poverty
//xspd2 chronic1p  racehisp bmicat pa08_3r xcigsmoke  xalcstat

								 
fvset base 2 xspd2 chronic1p  racehisp bmicat 
fvset base 3 pa08_3r educ_cat
fvset base 1  xaa_age_grp xcigsmoke  xalcstat  
//fvset base 4 poverty 

local demo i.dur_cat i.aa_age_grp i.sex i.racehisp i.marital
local demox i.dur_cat i.aa_age_grp i.racehisp i.marital
local ses  i.educ_cat  


svyset psu [pweight=wt8], strata (stratum) singleunit(missing)


     display _newline(2) _column(40) "Model Adjusted for Demographic and All Behavioral Factors and Disease by xaa_age_grp== `xaa_age_grp'"
   		capture noisily svy,subpop(if a_age>= 35 & a_age<=84): cloglog dead `demo' `ses' i.xspd2  ///
		  i.xcigsmoke i.xalcstat i.pa08_3r i.chronic1p, eform nolog
		est store ages35_84_final
		margins, at (xspd2 = (1 2) )
		margins, at (xcigsmoke = (1 2 3 4) )
		margins, at (chronic1p = (1 2) )
		margins, at (pa08_3r = (1 2 3) )
		margins, at (xalcstat = (1 2 3 4 5) )


	estout xdsf_m1 xdsf_m2 xdsf_m3 using "E:\spd_mort_results\ages35_84.txt", replace ///
	cells("b(fmt(%5.2f) star) ci(par([  ,  ]) fmt(%6.2f))" ) eform ///
	stats(N_sub, fmt(%12.0gc) labels("PY of obs")) ///
	collabels("RR" "95% CI") drop(_cons) style(fixed)



log close ages35_84


