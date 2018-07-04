
capture log close strata_confound2
clear
set more off

use "H:\spd_mort_data_code\expand_data_final.dta"


log using "H:\spd_mort_results\strata_confound2.log", name (strata_confound2) replace


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

recode xcigsmoke (2/4=2) (1=1), gen(cig_s)
recode xalcstat (1=1) (2 5 = 2) (3 4 =3), gen(alc_s)
recode pa08_3r (1=1) (2 3 =2), gen(phy_s)

label define  cig_s_v  1 "Never Smoker" 2 "Smoker(C/F)"
     label values cig_s cig_s_v

label define phy_s_v  1 "Active" 2 "Lack_phy_acti(2/3)" 
     label values phy_s phy_s_v


label define  alc_s_v 1 "Never Drinker" 2 "Former/Heavy"  3 "Light/Moderate"
     label values alc_s alc_s_v	 
	 
 		 
local demo i.dur_cat a_age i.sex i.racehisp i.marital
local demox i.dur_cat i.aa_age_grp i.racehisp i.marital
local ses  i.educ_cat  

 
fvset base 1  xcigsmoke  xalcstat cig_s phy_s alc_s
fvset base 2 xspd2 chronic1p   racehisp bmicat 
fvset base 3 pa08_3r educ_cat
/*
foreach xvar of varlist chronic1p cig_s alc_s phy_s {
  table `xvar'   xspd2  xaa_age_grp, by(dead) contents(freq)
}
*/

svyset psu [pweight=wt8], strata (stratum) singleunit(missing)
/*
foreach xaa_age_grp in 1  2 3 {
foreach chronic1p in 1 2 {
     display _newline(2) _column(40) "Stratified on age group and chroinc conditions - age group = `xaa_age_grp' & chronic1p= `chronic1p'  "
   		capture noisily svy,subpop(if xaa_age_grp== `xaa_age_grp'  &  chronic1p== `chronic1p'): cloglog dead `demo' `ses' i.xspd2, eform nolog
   		 }
}
  
foreach xaa_age_grp in 1  2 3 {
foreach cig_s in 1 2 {
     display _newline(2) _column(40) "Stratified on age group and cigarette smoking - age group = `xaa_age_grp' & cig_s= `cig_s'  "
   		capture noisily svy,subpop(if xaa_age_grp== `xaa_age_grp'  &  cig_s== `cig_s'): cloglog dead `demo' `ses' i.xspd2, eform nolog
   		 }
}

foreach xaa_age_grp in 1  2 3 {
foreach alc_s in 1 2 3 {
     display _newline(2) _column(40) "Stratified on age group and alcohol use - age group = `xaa_age_grp' & alc_s= `alc_s'  "
   		capture noisily svy,subpop(if xaa_age_grp== `xaa_age_grp'  &  alc_s== `alc_s'): cloglog dead `demo' `ses' i.xspd2, eform nolog
   		 }
}	 
*/
 foreach xaa_age_grp in 1  2 3 {
foreach phy_s in 1 2 {
     display _newline(2) _column(40) "Stratified on age group and phy inactivity - age group = `xaa_age_grp' & phy_s= `phy_s'  "
   		capture noisily svy,subpop(if xaa_age_grp== `xaa_age_grp'  &  phy_s== `phy_s'): cloglog dead `demo' `ses' i.xspd2, eform nolog
   		 } 
 }


  
  
  
log close strata_confound2


