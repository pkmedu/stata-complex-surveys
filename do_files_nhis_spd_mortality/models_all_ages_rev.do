
capture log close all_ages_rev
clear
set more off

use "H:\SASDATAMH\expand_data_final.dta"


log using "H:\Stata_mortality\all_ages_rev.log", name (all_ages_rev) replace


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
fvset base 1  xcigsmoke  xalcstat  
//fvset base 4 poverty 

local demo i.dur_cat a_age i.sex i.racehisp i.marital
local demox i.dur_cat a_age i.racehisp i.marital
local ses  i.educ_cat  


svyset psu [pweight=wt8], strata (stratum) singleunit(missing)

foreach xaa_age_grp in 1  2 3 {
     display _newline(2) _column(40) "Model Adjusted for Demographic and All Behavioral Factors and Disease by xaa_age_grp== `xaa_age_grp'"
   		capture noisily svy,subpop(if xaa_age_grp== `xaa_age_grp'): cloglog dead `demo' `ses' i.xspd2  ///
		  i.xcigsmoke i.xalcstat i.pa08_3r i.chronic1p, eform nolog
		est store xdsf_m`xaa_age_grp'
	}


foreach xaa_age_grp in 1  2 3 {
	estout xdsf_m1 xdsf_m2 xdsf_m3 using "H:\Stata_mortality\xds_Age1_2_3.txt", replace ///
	cells("b(fmt(%5.2f) star) ci(par([  ,  ]) fmt(%6.2f))" ) eform ///
	stats(N_sub, fmt(%12.0gc) labels("PY of obs")) ///
	collabels("RR" "95% CI") drop(_cons) style(fixed)
}

/*
foreach xaa_age_grp in 1  2 3 {
     display _newline(2) _column(40) "MALE - Model Adjusted for Demographic and All Behavioral Factors and Disease by xaa_age_grp== `xaa_age_grp'"
   		capture noisily svy,subpop(if xaa_age_grp== `xaa_age_grp' & sex==1): cloglog dead `demox' `ses' i.xspd2  ///
		  i.xcigsmoke i.xalcstat i.pa08_3r i.chronic1p, eform nolog
		est store xdsf_m`xaa_age_grp'
	}


foreach xaa_age_grp in 1  2 3 {
	estout xdsf_m1 xdsf_m2 xdsf_m3 using "H:\Stata_mortality\MALE_xds_Age1_2_3.txt", replace ///
	cells("b(fmt(%5.2f) star) ci(par([  ,  ]) fmt(%6.2f))" ) eform ///
	stats(N_sub, fmt(%12.0gc) labels("PY of obs")) ///
	collabels("RR" "95% CI") drop(_cons) style(fixed)
}

foreach xaa_age_grp in 1  2 3 {
     display _newline(2) _column(40) "FEMALE - Model Adjusted for Demographic and All Behavioral Factors and Disease by xaa_age_grp== `xaa_age_grp'"
   		capture noisily svy,subpop(if xaa_age_grp== `xaa_age_grp' & sex==2): cloglog dead `demox' `ses' i.xspd2  ///
		  i.xcigsmoke i.xalcstat i.pa08_3r i.chronic1p, eform nolog
		est store xdsf_m`xaa_age_grp'
	}


foreach xaa_age_grp in 1  2 3 {
	estout xdsf_m1 xdsf_m2 xdsf_m3 using "H:\Stata_mortality\FEMALE_xds_Age1_2_3.txt", replace ///
	cells("b(fmt(%5.2f) star) ci(par([  ,  ]) fmt(%6.2f))" ) eform ///
	stats(N_sub, fmt(%12.0gc) labels("PY of obs")) ///
	collabels("RR" "95% CI") drop(_cons) style(fixed)
}
*/

/*
foreach xaa_age_grp in 1  2 3 {
     display _newline(2) _column(40) "Model Adjusted for demographics by xaa_age_grp== `xaa_age_grp'"
  	    capture noisily svy,subpop(if xaa_age_grp== `xaa_age_grp'): cloglog dead `demo' `ses' i.xspd2, eform nolog
		est store bm`xaa_age_grp'
	}

foreach xaa_age_grp in 1  2 3 {
	estout bm1 bm2 bm3 using "H:\Stata_mortality\bm_Age1_2_3.txt", replace ///
	cells("b(fmt(%5.2f) star) ci(par([  ,  ]) fmt(%6.2f))" ) eform ///
	stats(N_sub, fmt(%12.0gc) labels("PY of obs")) ///
	collabels("RR" "95% CI") drop(_cons) style(fixed)
}


    
foreach xaa_age_grp in 1  2 3 {
     display _newline(2) _column(40) "Model Adjusted for Demographic and Individual Behavioral Factor by xaa_age_grp== `xaa_age_grp'"
   foreach xvar of varlist  xcigsmoke xalcstat pa08_3r chronic1p {
	    display _newline(2) _column(40) "Model Adjusted for Demographic and Individual Behavioral Factor by xaa_age_grp== `xaa_age_grp'"
		capture noisily svy,subpop(if xaa_age_grp== `xaa_age_grp'): cloglog dead `demo' `ses' i.xspd2 i.`xvar', eform nolog
		est store `xvar'_m`xaa_age_grp'
	}
}


foreach xaa_age_grp in 1  2 3 {
foreach xvar of varlist  xcigsmoke xalcstat pa08_3r chronic1p {
	estout `xvar'_m`xaa_age_grp' using "H:\Stata_mortality\ds_`xvar'_Age1_2_3.txt", replace ///
	cells("b(fmt(%5.2f) star) ci(par([  ,  ]) fmt(%6.2f))" ) eform ///
	stats(N_sub, fmt(%12.0gc) labels("PY of obs")) ///
	collabels("RR" "95% CI") drop(_cons) style(fixed)
}
}


foreach xaa_age_grp in 1  2 3 {
     display _newline(2) _column(40) "Model Adjusted for Demographic and All Behavioral Factors by xaa_age_grp== `xaa_age_grp'"
   		capture noisily svy,subpop(if xaa_age_grp== `xaa_age_grp'): cloglog dead `demo' `ses' i.xspd2  ///
		 i.xcigsmoke i.xalcstat i.pa08_3r, eform nolog
		est store dsf_m`xaa_age_grp'
	}


foreach  xaa_age_grp in 1  2 3 {
	estout dsf_m1 dsf_m2 dsf_m3 using "H:\Stata_mortality\ds_Age1_2_3.txt", replace ///
	cells("b(fmt(%5.2f) star) ci(par([  ,  ]) fmt(%6.2f))" ) eform ///
	stats(N_sub, fmt(%12.0gc) labels("PY of obs")) ///
	collabels("RR" "95% CI") drop(_cons) style(fixed)
}

foreach xaa_age_grp in 1  2 3 {
     display _newline(2) _column(40) "Model Adjusted for Demographic and All Behavioral Factors and Disease by xaa_age_grp== `xaa_age_grp'"
   		capture noisily svy,subpop(if xaa_age_grp== `xaa_age_grp'): cloglog dead `demo' `ses' i.xspd2  ///
		  i.xcigsmoke i.xalcstat i.pa08_3r i.chronic1p, eform nolog
		est store xdsf_m`xaa_age_grp'
	}


foreach xaa_age_grp in 1  2 3 {
	estout xdsf_m1 xdsf_m2 xdsf_m3 using "H:\Stata_mortality\xds_Age1_2_3.txt", replace ///
	cells("b(fmt(%5.2f) star) ci(par([  ,  ]) fmt(%6.2f))" ) eform ///
	stats(N_sub, fmt(%12.0gc) labels("PY of obs")) ///
	collabels("RR" "95% CI") drop(_cons) style(fixed)
}
*/
/*

foreach xaa_age_grp in 1  2 3 {
     display _newline(2) _column(40) "Model to Test CIG X SPD Interaction by xaa_age_grp== `xaa_age_grp'"
   		capture noisily svy,subpop(if xaa_age_grp== `xaa_age_grp'): cloglog dead `demo' `ses' i.xspd2  ///
		  i.xcigsmoke i.xalcstat i.pa08_3r i.chronic1p i.xspd2##i.xcigsmoke, eform nolog
		est store xcig_m`xaa_age_grp'
	}


foreach xaa_age_grp in 1  2 3 {
	estout xcig_m1 xcig_m2 xcig_m3 using "H:\Stata_mortality\xcig_Age1_2_3.txt", replace ///
	cells("b(fmt(%5.2f) star) ci(par([  ,  ]) fmt(%6.2f))" ) eform ///
	stats(N_sub, fmt(%12.0gc) labels("PY of obs")) ///
	collabels("RR" "95% CI") drop(_cons) style(fixed)
}

foreach ivar of varlist  xcigsmoke xalcstat pa08_3r chronic1p {
	  display _newline(2) _column(40) "Model to Test Unhealthy Behav X SPD Interaction (Black Male Ages 35-84)'"
   		capture noisily svy,subpop(if !missing(xaa_age_grp) & black & male): cloglog dead `demox' `ses' i.xspd2  ///
		  i.xcigsmoke i.xalcstat i.pa08_3r i.chronic1p i.xspd2##i.`ivar', eform nolog
		est store m_`ivar'
	}


  foreach ivar of varlist  xcigsmoke xalcstat pa08_3r chronic1p {
	estout m_`ivar' using "H:\Stata_mortality\interaction_`ivar'_black_male.txt", replace ///
	cells("b(fmt(%5.2f) star) ci(par([  ,  ]) fmt(%6.2f))" ) eform ///
	stats(N_sub, fmt(%12.0gc) labels("PY of obs")) ///
	collabels("RR" "95% CI") drop(_cons) style(fixed)
  }




foreach xaa_age_grp in 1  2 3 {
     display _newline(2) _column(40) "Model to Test Unhealthy Behav X SPD Interaction by xaa_age_grp== `xaa_age_grp'"
	 foreach ivar of varlist  xcigsmoke xalcstat pa08_3r chronic1p {
   		capture noisily svy,subpop(if xaa_age_grp== `xaa_age_grp'): cloglog dead `demo' `ses' i.xspd2  ///
		  i.xcigsmoke i.xalcstat i.pa08_3r i.chronic1p i.xspd2##i.`ivar', eform nolog
		est store `ivar'_m`xaa_age_grp'
	}
}
foreach xaa_age_grp in 1  2 3 {
  foreach ivar of varlist  xcigsmoke xalcstat pa08_3r chronic1p {
	estout `ivar'_m`xaa_age_grp' using "H:\Stata_mortality\interaction_`ivar'_Age1_2_3.txt", replace ///
	cells("b(fmt(%5.2f) star) ci(par([  ,  ]) fmt(%6.2f))" ) eform ///
	stats(N_sub, fmt(%12.0gc) labels("PY of obs")) ///
	collabels("RR" "95% CI") drop(_cons) style(fixed)
  }
}


foreach xaa_age_grp in 1  2 3 {
     display _newline(2) _column(40) "Model to Test CIG X SPD Interaction by xaa_age_grp== `xaa_age_grp'"
   		capture noisily svy,subpop(if xaa_age_grp== `xaa_age_grp'): cloglog dead `demo' `ses' i.xspd2  ///
		  i.xcigsmoke i.xalcstat i.pa08_3r i.chronic1p i.xspd2##i.i.xcigsmoke, eform nolog
		est store xcig_m`xaa_age_grp'
	}


foreach xaa_age_grp in 1  2 3 {
	estout xcig_m1 xcig_m2 xcig_m3 using "H:\Stata_mortality\xcig_Age1_2_3.txt", replace ///
	cells("b(fmt(%5.2f) star) ci(par([  ,  ]) fmt(%6.2f))" ) eform ///
	stats(N_sub, fmt(%12.0gc) labels("PY of obs")) ///
	collabels("RR" "95% CI") drop(_cons) style(fixed)
}


*/			
log close all_ages_rev


