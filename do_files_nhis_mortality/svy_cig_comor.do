
capture log close rates
//clolog_attained_age_duration.do
clear
clear matrix
set more off
set linesize 255

use "E:\SASDATAMH\indi_data.dta"


describe

log using "E:\SASDATAMH\tab1a.log", name (tab1a) replace

/*
gen spd_35_59 = (xspd2==1 & age_35_59==1)
gen no_spd_35_59 = (xspd2==2 & age_35_59==1) 

gen spd_60_74 = (xspd2==1 & age_60_74==1)
gen no_spd_60_74 = (xspd2==2 & age_60_74==1)

gen spd_75_84 = (xspd2==1 & age_75_84==1)
gen no_spd_75_84 = (xspd2==2 & age_75_84==1)

tab age_35_59 xspd2
tab1 spd_35_59 no_spd_35_59

tab age_60_74 xspd2
tab1 spd_60_74 no_spd_60_74

tab age_75_84 xspd2
tab1 spd_75_84 no_spd_75_84

tab1 chronic1p
*/
svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(missing)

foreach spop of varlist age_35_59 age_60_74 age_75_84 {
  foreach depvar of varlist curr_smk form_smk chronic1p   {
    svy, subpop(`spop') percent: tabulate `depvar' xspd2, col obs se format (%5.1f) stubwidth(30)
   }
   }
   
/*
 svy: mean curr_smk, over (xspd2)
 svy: mean curr_smk, over (xspd2 aa_age_grp)
 
 svy: mean form_smk, over (xspd2)
 svy: mean form_smk, over (xspd2 aa_age_grp)
 
 svy: mean chronic1p, over (xspd2)
 svy: mean chronic1p, over (xspd2 aa_age_grp)
 */
  
log close tab1a
