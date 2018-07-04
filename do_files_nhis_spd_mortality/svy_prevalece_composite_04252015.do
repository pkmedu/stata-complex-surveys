
capture log close freq
capture log close svy_freq
clear
set more off
set linesize 255
use "H:\spd_mort_data_code\causes_added_data_rev", clear

*log using "H:\spd_mort_data_code\svy_freq.log", name (svy_freq) replace

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
	  
  label define lead_c7_lab ///
    1 "1 Malignant neoplasms"  ///
    2 "2 Dieases of heart" ///
    3 "3 HIV diseases" ///
    4 "4 Motor vehicle crash" ///
    5 "5 Suicide" ///
    6 "6 Assault/Accident" ///
    7 "7 Other causes"
	label values lead_c7 lead_c7_lab 
	
	
	label define lead_c5_lab ///
    1 "1 Malignant neoplasms"  ///
    2 "2 Dieases of heart" ///
    3 "3 HIV diseases" ///
    4 "4 Accidents" ///
	5 "5 Sui/Assault/Acci Poisoning" ///
    6 "6 Other causes"
	label values lead_c5 lead_c5_lab 

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

 gen model_obs = !missing(y_age_grp, sex, racehisp, educ_cat, marital, ///
                          xcigsmoke,  xalcstat, chronic1p, pa08_3r, xspd2)
						  
egen spd_chr_cig3c = group(xspd2 chronic1p cigsmoke_3c ), l

egen spd_chr_cig2c = group(xspd2 chronic1p cig_never_ever), l

egen spd_chr = group(xspd2 chronic1p ), l

egen spd_cig2c = group(xspd2 cig_never_ever ), l


tabulate  lead_c5 spd_cig2c if model_obs==1 & mortstat==1
tabulate  lead_c5 xspd2 if model_obs==1 & mortstat==1

svyset psu [pweight=wt8], strata (stratum) singleunit(missing)
foreach indvar of varlist xspd2 spd_cig2c  {
display _newline _column(30) "Weighted Count - Ages 50 to 74"
svy, subpop(if model_obs==1 & mortstat==1 ) percent: tabulate lead_c5 `indvar', col obs ///
      ci format (%5.2f) stubwidth(30)
 }
 



tabulate xspd2 if model_obs==1	
tabulate chronic1p if model_obs==1	
tabulate spd_chr_cig3c  if model_obs==1	
tabulate cigsmoke_3c  if model_obs==1
tabulate cig_never_ever  if model_obs==1
tabulate spd_cig2c  if model_obs==1	
tabulate spd_chr_cig2c  if model_obs==1
tabulate spd_chr  if model_obs==1


tabulate xspd2 if model_obs==1	& mortstat==1
tabulate chronic1p if model_obs==1	& mortstat==1
tabulate spd_chr_cig3c  if model_obs==1	& mortstat==1
tabulate cigsmoke_3c  if model_obs==1 & mortstat==1
tabulate cig_never_ever  if model_obs==1 & mortstat==1
tabulate spd_cig2c  if model_obs==1	& mortstat==1
tabulate spd_chr_cig2c  if model_obs==1  & mortstat==1
tabulate spd_chr  if model_obs==1  & mortstat==1



svyset psu [pweight=wt8], strata (stratum) singleunit(missing)

foreach depvar of varlist xspd2 cig_never_ever chronic1p  spd_cig2c spd_chr spd_chr_cig2c {
display _newline _column(30) "Weighted Count - Ages 50 to 74"
svy, subpop(if model_obs==1 ) percent: tabulate `depvar', col obs ///
      ci format (%5.2f) stubwidth(30)
 }
 
 



 
log close svy_freq 

 

