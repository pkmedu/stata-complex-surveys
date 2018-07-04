
capture log close freq
capture log close svy_freq
clear
set more off
set linesize 255
use "H:\spd_mort_data_code\causes_added_data_rev", clear
describe
generate XSPD4 = SPD4+1


  label define spd4_lab ///  
			1 "K6 0"  ///
	        2 "K6 1-5" ///   
	        3 "K6 6-10" ///   
	        4 "K6 11-24" 
	 label values  XSPD4 spd4_lab

 
 
*log using "H:\spd_mort_data_code\svy_freq.log", name (svy_freq) replace

 label define spd5_lab ///  
			0 "K6 0"  ///
	        1 "K6 1-2" ///   
	        2 "K6 3-5"  ///
			3 "K6 6-10" ///   
	        4 "K6 11-24" 
	 label values  SPD5 spd5_lab

recode cigsmoke_r2 (2 3 =2)  (4=3) (99=.), gen(cigsmoke_3c)

recode cigsmoke_3c (2 3 =2), gen(cig_never_ever)


    label define cigsmoke_3c_lab ///  
			1 "Never"  ///
	        2 "Current" ///   
	        3 "Former"  
	 label values  cigsmoke_3c cigsmoke_3c_lab
	 
	 label define cig_never_ever_lab ///  
			1 "Never"  ///
	        2 "Ever"   
	 label values  cig_never_ever cig_never_ever_lab
	  
	 
	 
	  
	 recode cigsmoke_r (99=.), gen(cigsmoke_9c)
	 
	 label define cigsmoke_9c_lab  ///
	        1 "Never"   ///
	        2 "Curr <1 pack/d"   ///
	        3 "Curr 1+ packs/d"  ///
			5 "FQ_0–4 yrs ago"  ///
	        6 "FQ_5–9 yrs ago"  ///
			7 "FQ_10–19 yrs ago" ///  
            8 "FQ_20–29 yrs ago"  ///
			9 "FQ_30+ yrs ago" 
            
     label values  cigsmoke_9c cigsmoke_9c_lab
	 
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


gen ystd_wgt = 0.2904 if y_age_grp ==1
replace ystd_wgt = 0.2243 if y_age_grp ==2
replace ystd_wgt = 0.1796 if y_age_grp ==3
replace ystd_wgt = 0.1586 if y_age_grp ==4
replace ystd_wgt = 0.1471 if y_age_grp ==5

 gen d_curr_smk = 0
 replace d_curr_smk=1 if cigsmoke_3c==2
 
 gen d_chronic = 0
 replace d_chronic=1 if chronic1p_r==1
 
 gen d_cig_ever=0
 replace d_cig_ever =1 if cig_never_ever==2
 
 gen d_cig_former=0
 replace d_cig_former =1 if  cigsmoke_3c==3
 

 
 gen d_heavy_alc=0
 replace d_heavy_alc=1 if xalcstat==5
 
 gen d_no_acti=0
 replace d_no_acti=1 if pa08_3r==1
 

 gen model_obs = !missing(y_age_grp, sex, racehisp, educ_cat, marital, ///
                          xcigsmoke,  xalcstat, chronic1p, pa08_3r, xspd2)
						  
egen composite = group(xspd2 chronic1p cigsmoke_3c ), l

egen composite4 = group(xspd2 chronic1p cig_never_ever), l

egen composite2 = group(xspd2 cigsmoke_3c ), l

egen composite3 = group(xspd2 cig_never_ever ), l
/*
foreach depvar of varlist d_chronic d_curr_smk d_cig_ever d_cig_former d_heavy_alc d_no_acti  {
  gen x`depvar' = `depvar'*100
}

foreach depvar of varlist d_chronic d_cig_ever d_heavy_alc d_no_acti  {tab  y_age_grp `depvar' if model_obs==1
}



tabulate XSPD4 cig_never_ever if model_obs==1	
tabulate XSPD4 chronic1p if model_obs==1

tabulate XSPD4 cig_never_ever if model_obs==1 & mortstat==1	
tabulate XSPD4 chronic1p if model_obs==1 & mortstat==1	

tabulate cigsmoke_3c  if model_obs==1
tabulate cig_never_ever  if model_obs==1
tabulate composite3  if model_obs==1	

tabulate composite4  if model_obs==1

table  model_obs mortstat xspd2, by (cig_never_ever chronic1p ) content(freq) row col sc
*/

svyset psu [pweight=wt8], strata (stratum) singleunit(missing)

* prevalence;


foreach depvar of varlist xspd2 xalcstat chronic1p_r pa08_3r_r {
 display _newline _column(30) "Crosstables by SPD Status - Ages 50 to 74"
 svy, subpop(if model_obs==1) percent: tabulate `depvar' cig_never_ever  , col obs  ///
  ci format (%5.1f) stubwidth(30)
			  } 
 





svy, subpop(if model_obs==1) percent: tabulate cig_never_ever, col obs  ///
  ci format (%5.2f) stubwidth(30)
 

 svy, subpop(if model_obs==1) percent: tabulate XSPD4, col obs  ///
  ci format (%5.2f) stubwidth(30)
 
 svy, subpop(if model_obs==1) percent: tabulate xspd2, col obs  ///
  ci format (%5.2f) stubwidth(30)

svy, subpop(if model_obs==1 & cig_never_ever==1) percent: tabulate XSPD4, col obs  ///
  ci format (%5.2f) stubwidth(30)
 
 svy, subpop(if model_obs==1 & cig_never_ever==2) percent: tabulate XSPD4, col obs  ///
  ci format (%5.2f) stubwidth(30)
 
  svy, subpop(if model_obs==1 & cig_never_ever==1) percent: tabulate xspd2, col obs  ///
  ci format (%5.2f) stubwidth(30)

 svy, subpop(if model_obs==1 & cig_never_ever==2) percent: tabulate xspd2, col obs  ///
  ci format (%5.2f) stubwidth(30)




svy, subpop(if model_obs==1): tab xspd2 cig_never_ever, row per obs format(%9.3f) 



foreach depvar of varlist   xd_chronic xd_curr_smk xd_cig_ever xd_cig_former xd_heavy_alc xd_no_acti {
svy, subpop(if model_obs==1 ): mean `depvar', over(xspd2 y_age_grp) 
 }

foreach depvar of varlist  xd_chronic xd_curr_smk xd_cig_ever xd_heavy_alc xd_no_acti {
svy, subpop(if model_obs==1 ): mean `depvar', over(xspd2) 
 }


foreach depvar of varlist xhypten xrespill  xheart  xdiabetes  xcancer xstroke  {
svy, subpop(if model_obs==1 ): mean `depvar', over(xspd2) 
 }



foreach indvar of varlist hypten respill  heart  diabetes  cancer stroke {
 generate x`indvar'= `indvar'*100
 }
 
 foreach depvar of varlist xhypten xrespill  xheart  xdiabetes  xcancer xstroke  {
svy, subpop(if model_obs==1 ): mean `depvar', over(xspd2) 
 }

 foreach depvar of varlist y_age_grp sex racehisp educ_cat marital {
 svy, subpop(if model_obs==1) percent: tabulate `depvar' xspd2, col obs  ///
  ci format (%5.1f) stubwidth(30) 
 }
 
 
 svy, subpop(if model_obs==1) percent: tabulate XSPD4, col obs  ///
  ci format (%5.2f) stubwidth(30)
 
 svy, subpop(if model_obs==1) percent: tabulate xspd2, col obs  ///
  ci format (%5.2f) stubwidth(30)


foreach indvar of varlist y_age_grp  {
display _newline _column(30) "Weighted Count - Ages 50 to 74"
svy, subpop(if model_obs==1 ): mean xd1000, over(`indvar') 
 }

foreach depvar of varlist cig_never_ever cigsmoke_3c cigsmoke_9c xalcstat chronic1p_r pa08_3r_r {
 display _newline _column(30) "Crosstables by SPD Status - Ages 50 to 74"
 svy, subpop(if model_obs==1) percent: tabulate `depvar' SPD5 , col obs  ///
  ci format (%5.1f) stubwidth(30)
			  }

svy, subpop(if model_obs==1 & sex==1) percent: tabulate SPD5 y_age_grp, col obs  ///
  ci format (%5.2f) stubwidth(30)
  
svy, subpop(if model_obs==1 & sex==2) percent: tabulate SPD5 y_age_grp, col obs  ///
  ci format (%5.2f) stubwidth(30)

svy, subpop(if model_obs==1) percent: tabulate SPD5 , col obs  ///
  ci format (%5.2f) stubwidth(30)

svy, subpop(if model_obs==1) percent: tabulate cig_never_ever , col obs  ///
  ci format (%5.2f) stubwidth(30)

svy, subpop(if model_obs==1) percent: tabulate composite3 , col obs  ///
  ci format (%5.2f) stubwidth(30)

svy, subpop(if model_obs==1) percent: tabulate cig_never_ever , col obs  ///
  ci format (%5.2f) stubwidth(30)

svy, subpop(if model_obs==1) percent: tabulate composite3 , col obs  ///
  ci format (%5.2f) stubwidth(30)

svy, subpop(if model_obs==1) percent: tabulate xspd2 , col obs  ///
  ci format (%5.2f) stubwidth(30)
  
  svy, subpop(if model_obs==1) percent: tabulate composite4 , col obs  ///
  ci format (%5.2f) stubwidth(30)



 svy, subpop(if model_obs==1) percent: tabulate composite , col obs  ///
  ci format (%5.2f) stubwidth(30)

  tabulate composite2  if model_obs==1
svy, subpop(if model_obs==1) percent: tabulate composite2 , col obs  ///
  ci format (%5.2f) stubwidth(30)


svy, subpop(if age_p>=50 & age_p<=74): tab xspd2 cigsmoke_3c, row per obs format(%9.3f) 


* for estimated N's (Table 1)
 
*svy: tabulate race, format(%11.3g) count ci deff deft



svy, subpop(if model_obs==1 ): tabulate xspd2, ///
 count ci deff deft format(%9.0f)
tabulate xspd2  if model_obs==1	


 * prevalence;


foreach depvar of varlist cigsmoke_3c cigsmoke_9c xcigsmoke xalcstat chronic1p_r pa08_3r_r {
 display _newline _column(30) "Crosstables by SPD Status - Ages 50 to 74"
 svy, subpop(if model_obs==1) percent: tabulate `depvar' xspd2 , col obs  ///
  ci format (%5.1f) stubwidth(30)
			  } 
 
foreach depvar of varlist cigsmoke_3c cigsmoke_9c xcigsmoke xalcstat chronic1p_r pa08_3r_r {
display _newline _column(30) "Weighted Count - Ages 50 to 74"
svy, subpop(if model_obs==1 ): tabulate `depvar', ///
    count ci deff deft format(%9.0f)
 }



/*
 foreach depvar of varlist d_curr_smk d_chronic {
 display _newline _column(30) "Mean indicator variable by age group and SPD Status - Ages 50 to 74"
 svy, subpop(if age_p>=50 & age_p<=74): mean `depvar', over  (xspd2 y_age_grp ) 
 estat size
			  }
foreach depvar of varlist d_curr_smk d_chronic {
	 display _newline(2) _column(35) " Dependent variable = `depvar' "  
	svy, subpop (if age_p>=50 & age_p<=74): mean `depvar', stdize(y_age_grp) stdweight(ystd_wgt) ///
      over (xspd2)
	 	 }
*/
 
log close svy_freq 

 

