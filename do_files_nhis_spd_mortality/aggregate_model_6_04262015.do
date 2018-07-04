
capture log close inter_ages50_74
clear
set more off

use "H:\spd_mort_data_code\py_working_file2.dta"
/*
foreach depvar of varlist  lp_death lpc_death dead cig_dis2 cig_dis3 {
tab1 `depvar'
tab1 `depvar' if age_p >=50 & age_p<=74
}
*/
*log using "H:\spd_mort_results\inter_ages50_74.log", name (inter_ages50_74) replace

generate XSPD4 = SPD4+1


  label define spd4_lab ///  
			1 "K6 0"  ///
	        2 "K6 1-5" ///   
	        3 "K6 6-10" ///   
	        4 "K6 11-24" 
	 label values  XSPD4 spd4_lab

 tab XSPD4


recode sex (1=1)(2=0), gen(male)
recode racehisp (1=1)(2/4=0), gen(white)
recode racehisp (3=1)(1 2 4=0), gen(black)

recode xcigsmoke (2/4=2) (1=1), gen(cig_s)
recode xalcstat (1=1) (2 5 = 2) (3 4 =3), gen(alc_s)
recode pa08_3r (3=1) (1 2 =2), gen(phy_s)

label define  cig_s_v  1 "Never Smoker" 2 "Smoker(C/F)"
     label values cig_s cig_s_v

label define phy_s_v  1 "Active" 2 "Lack_phy_acti(2/3)" 
   label values phy_s phy_s_v


label define  alc_s_v 1 "Never Drinker" 2 "Former/Heavy"  3 "Light/Moderate"
     label values alc_s alc_s_v	 

	 

gen y_age_grp=. if age_p >= 18 & age_p <=49
replace y_age_grp=1 if age_p >=50 & age_p <=54
replace y_age_grp=2 if age_p >=55 & age_p <=59
replace y_age_grp=3 if age_p >=60 & age_p <=64
replace y_age_grp=4 if age_p >=65 & age_p <=69
replace y_age_grp=5 if age_p >=70 & age_p <=74
replace y_age_grp=. if age_p >=75


label define y_age_lab 1 "50-54 Yrs"  2 "55-59 Yrs" 3 "60-64 Yrs" ///
                       4 "65-69 Yrs" 5 "70-74 Yrs"
label values y_age_grp y_age_lab

recode cigsmoke_r2 (2 3 =2)  (4=3) (99=.), gen(cigsmoke_3c)
label define cigsmoke_3c_lab ///  
			1 "Never"  ///
	        2 "Current" ///   
	        3 "Former"  
	 label values  cigsmoke_3c cigsmoke_3c_lab

 
 recode cigsmoke_3c (2 3 =2), gen(cig_never_ever)

	 
	 label define cig_never_ever_lab ///  
			1 "Never"  ///
	        2 "Ever"   
	 label values  cig_never_ever cig_never_ever_lab
 
 
 
 gen model_obs = !missing(y_age_grp, sex, racehisp, educ_cat, marital, ///
                          dur_cat, phy_s, alc_s,cigsmoke_3c, chronic1p, xspd2)

						  
 
 		 
 ***********************************************
 
local demo i.dur_cat i.y_age_grp i.sex i.racehisp i.marital
local demox i.dur_cat i.aa_age_grp i.racehisp i.marital
local ses  i.educ_cat  

 
fvset base 1  y_age_grp xcigsmoke  xalcstat  phy_s alc_s y_age_grp cigsmoke_3c cig_never_ever XSPD4
fvset base 2 xspd2 chronic1p sex  racehisp 
fvset base 3 pa08_3r educ_cat

	
********************;
svyset psu [pweight=wt8], strata (stratum) singleunit(missing)
foreach depvar of varlist  dead {
   		capture noisily svy,subpop(if model_obs==1): cloglog `depvar' `demo' `ses' ///
		i.XSPD4 i.cig_never_ever i.alc_s i.phy_s, eform nolog
	}		
	

foreach depvar of varlist  dead {
   		capture noisily svy,subpop(if model_obs==1): cloglog `depvar' `demo' `ses' ///
		i.xspd2, eform nolog
	}
	


foreach depvar of varlist  dead {
   		capture noisily svy,subpop(if model_obs==1): cloglog `depvar' `demo' `ses' ///
		i.XSPD4 i.cig_never_ever, eform nolog
	}		
	


foreach depvar of varlist  dead {
   		capture noisily svy,subpop(if model_obs==1): cloglog `depvar' `demo' ///
		i.XSPD4 i.cig_never_ever , eform nolog
	}		


foreach depvar of varlist  dead {
   		capture noisily svy,subpop(if model_obs==1): cloglog `depvar' `demo' ///
		i.xspd2, eform nolog
	}
		

	foreach depvar of varlist  dead {
   		capture noisily svy,subpop(if model_obs==1): cloglog `depvar' `demo' ///
		i.XSPD4 , eform nolog
	}	
foreach depvar of varlist  dead {
   		capture noisily svy,subpop(if model_obs==1): cloglog `depvar' `demo' ///
		i.XSPD4 i.cig_never_ever i.chronic1p, eform nolog
	}		
	
		
foreach depvar of varlist  dead {
   		capture noisily svy,subpop(if model_obs==1): cloglog `depvar' ///
		i.xspd2 , eform nolog
	}

foreach depvar of varlist  dead {
   		capture noisily svy,subpop(if model_obs==1): cloglog `depvar' ///
		i.XSPD4 , eform nolog
	}
	
foreach depvar of varlist  dead {
   		capture noisily svy,subpop(if model_obs==1): cloglog `depvar' `demo' `ses' ///
		i.XSPD4 , eform nolog
	}
	

foreach depvar of varlist  dead {
   		capture noisily svy,subpop(if model_obs==1): cloglog `depvar' `demo' `ses' ///
		i.XSPD4 i.cig_never_ever i.alc_s i.phy_s i.chronic1p, eform nolog
	}
	

foreach depvar of varlist  dead {
   		capture noisily svy,subpop(if model_obs==1): cloglog `depvar' `demo' `ses' ///
		i.XSPD4 i.cig_never_ever i.alc_s i.phy_s i.chronic1p ///
		i.XSPD4##i.cig_never_ever , eform nolog
	}
	




foreach depvar of varlist  dead {
   		capture noisily svy,subpop(if model_obs==1): cloglog `depvar' ///
		i.xspd2 i.cig_never_ever  ///
		i.xspd2##i.cig_never_ever , eform nolog
	}
foreach depvar of varlist  dead {
   		capture noisily svy,subpop(if model_obs==1): cloglog `depvar' `demo' `ses' ///
		i.xspd2 i.cig_never_ever i.alc_s i.phy_s  ///
		i.xspd2##i.cig_never_ever , eform nolog
	}

foreach depvar of varlist  dead {
   		capture noisily svy,subpop(if model_obs==1): cloglog `depvar' `demo' `ses' ///
		i.xspd2 i.cig_never_ever i.alc_s i.phy_s i.chronic1p ///
		i.xspd2##i.cig_never_ever , eform nolog
	}
	
	/*
	
	foreach depvar of varlist  dead {
   		capture noisily svy,subpop(if model_obs==1): cloglog `depvar' `demo' `ses' ///
		i.xspd2 i.cig_never_ever i.alc_s i.phy_s i.chronic1p ///
		i.xspd2##i.chronic1p, eform nolog
	}
	
foreach depvar of varlist  dead {
   		capture noisily svy,subpop(if model_obs==1): cloglog `depvar' `demo' `ses' ///
		i.xspd2 i.cig_never_ever i.alc_s i.phy_s i.chronic1p ///
		i.xspd2##i.cig_never_ever i.xspd2##i.chronic1p, eform nolog
	}

	foreach depvar of varlist  dead {
   		capture noisily svy,subpop(if model_obs==1): cloglog `depvar' `demo' `ses' ///
		i.xspd2 i.cig_never_ever i.alc_s i.phy_s i.chronic1p i.xspd2##i.cig_never_ever ///
		i.xspd2##i.chronic1p i.xspd2##i.cig_never_ever##i.chronic1p	, eform nolog
	}

*/
	

log close inter_ages50_74


