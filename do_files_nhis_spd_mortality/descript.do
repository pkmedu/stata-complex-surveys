
capture log close descript
clear
set more off
set linesize 255
use "H:\spd_mort_data_code\indi_data", clear
log using "H:\spd_mort_results\descript.log", name (descript) replace

describe
*Simplest is to use -svy: prop-
*svy: prop Diseased, over(Age Gender Race)
gen xaa_age_grp=. if age_p >= 18 & age_p <=34
replace xaa_age_grp=1 if age_p >=35 & age_p <=49
replace xaa_age_grp=2 if age_p >=50 & age_p <=69
replace xaa_age_grp=3 if age_p >=70 & age_p <=84
replace xaa_age_grp=. if age_p >=85

label define age_v 1 "35-49" 2 "50-69" 3 "70-84"
label values xaa_age_grp age_v	


/*
label define cigsmoke_v    ///
   1 "Never"   ///
   2 "Current <1 pack per day" ///
   3 "Current 1+ packs per day" ///
   4 "Current CIGSDAY unk" ///
   5 "Former quit 0–4 years ago"  ///
   6 "Former quit 5–9 years ago" ///
   7 "Former quit 10–19 years ago"  ///
   8 "Former quit 20–29 years ago"  ///
	 9 "Former quit 30+ years ago"  ///
	 10 "Former SMKQTY unk" ///
	 99 "Unk" 
label vlaues cigsmoke_r cigsmoke_v
*/
svyset psu [pweight=wt8], strata (stratum) singleunit(missing)



	foreach depvar of varlist cigsmoke_r  {
			 display _newline _column(30) "Crosstables by SPD Status Ages 35 to 84"
			 svy, subpop(if age_p>=35 & age_p<=84) percent: tabulate `depvar' xspd2, col obs  ///
			  ci format (%5.1f) stubwidth(30)
			  }

svy, subpop(if age_p>=35 & age_p<=84): total  cigsmoke_r, over(xaa_age_grp) 
estimates table, b(%14.3gc) se(%14.3gc)

  
  /*
  foreach depvar of varlist chronic1p xcigsmoke xalcstat pa08_3r  {
  display _newline _column(30) "Among individuals with SPD"
    svy, subpop(if age_p>=35 & age_p<=84 & xspd2==1): tabulate `depvar', format(%14.3gc) count ci 
                
}
foreach depvar of varlist chronic1p xcigsmoke xalcstat pa08_3r  {
display _newline _column(30) "Among individuals with no SPD"
    svy, subpop(if age_p>=35 & age_p<=84 & xspd2==2): tabulate `depvar', format(%14.3gc) count ci 
                 
}
  */

/*
svy, subpop(if age_p>=35 & age_p<=84): total  chronic1p, over(xaa_age_grp) 
estimates table, b(%14.3gc) se(%14.3gc)
*/
/*
foreach depvar of varlist xspd2 chronic1p xcigsmoke xalcstat pa08_3r  {
    svy, subpop(if age_p>=35 & age_p<=84): tabulate `depvar', format(%14.3gc) count ci 
                 
}

foreach depvar of varlist xspd2 chronic1p xcigsmoke xalcstat pa08_3r  {
			 display _newline _column(30) "Crosstables by Age Groups"
			 svy, subpop(if age_p>=35 & age_p<=84) percent: tabulate `depvar' xaa_age_grp,  
			   ci format (%5.1f) stubwidth(30)
			  }
	
	foreach depvar of varlist chronic1p xcigsmoke xalcstat pa08_3r  {
			 display _newline _column(30) "Crosstables by SPD Status Ages 35 to 84"
			 svy, subpop(if age_p>=35 & age_p<=84) percent: tabulate `depvar' xspd2, col obs  ///
			  ci format (%5.1f) stubwidth(30)
			  }
	foreach depvar of varlist chronic1p xcigsmoke xalcstat pa08_3r {
		display _newline _column(30) "Crosstables by SPD Status for Agr Group 35-49"
			 svy, subpop(if age_p>=35 & age_p<=49) percent: tabulate `depvar' xspd2, col obs  ///
			  ci format (%5.1f) stubwidth(30)
			  }
			  
	foreach depvar of varlist chronic1p xcigsmoke xalcstat pa08_3r {
			 display _newline _column(30) "Crosstables by SPD Status for Agr Group 50-69"
			 svy, subpop(if age_p>=50 & age_p<=69) percent: tabulate `depvar' xspd2, col obs  ///
			  ci format (%5.1f) stubwidth(30)
			  }
	foreach depvar of varlist chronic1p xcigsmoke xalcstat pa08_3r {
			 display _newline _column(30) "Crosstables by SPD Status for Agr Group 70-84"
			 svy, subpop(if age_p>=70 & age_p<=84) percent: tabulate `depvar' xspd2, col obs  ///
			  ci format (%5.1f) stubwidth(30)
			  }
*/			  
log close descript 
