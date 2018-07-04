
capture log close rates
//clolog_attained_age_duration.do
clear
set more off
set linesize 255
use "H:\spd_mort_data_code\expand_data_122314"
log using "H:\spd_mort_data_code\content.log", name (rates) replace


gen std_wgt = .5207 if ta_age_grp ==1
replace std_wgt = .3327 if ta_age_grp ==2
replace std_wgt = .1465 if ta_age_grp ==3
/*
label define ta_age_grp_lab 
			1 "35-49 Yrs" 
			2 "50-64 Yrs" 
			3 "65-74 Yrs" 
			4= "75+" ;
label values ta_age_grp ta_age_grp_lab;

label define cigsmoke_r2x_lab   
			1 "Never"  
	        2 "Curr <1 pack/d"    
	        3 "Curr 1+ packs/d"    
            4 "Former"  ; 
label values  cigsmoke_r2x cigsmoke_r2x_lab;

*/
 
tab1 cigsmoke_r2x


gen d1000 = dead*1000
svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(missing)

svy, subpop(if age_p>=35 & age_p<=84): mean d1000, over (ta_age_grp)

*svy, subpop (if age_p>=50 & age_p<=74): mean d1000, stdize(ta_age_grp) stdweight(std_wgt) ///
  *      over (sex)
				

 *svy, subpop (if age_p>=35 & age_p<=74): mean d1000, stdize(ta_age_grp) stdweight(std_wgt) ///
  *      over (xspd2 cigsmoke_r2x)
		

  
log close rates


