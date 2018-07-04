
capture log close freq
capture log close svy_freq
clear
set more off
set linesize 255
use "H:\spd_mort_data_code\causes_added_data_rev", clear

*log using "H:\spd_mort_data_code\svy_freq.log", name (svy_freq) replace

recode cigsmoke_r2 (2 3 =2)  (4=3) (99=.), gen(cigsmoke_3c)



    label define cigsmoke_3c_lab ///  
			1 "Never"  ///
	        2 "Current" ///   
	        3 "Former"  
	 label values  cigsmoke_3c cigsmoke_3c_lab
	  
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



 gen model_obs = !missing(y_age_grp, sex, racehisp, educ_cat, marital, ///
                          xcigsmoke,  xalcstat, chronic1p, pa08_3r, xspd2)

						  
table  model_obs mortstat xspd2, by (cigsmoke_3c chronic1p ) content(freq) row col sc

table  model_obs mortstat xspd2 , by (cigsmoke_3c pa08_3r) content(freq) row col sc						  
						  
						  
						  
tabulate xspd2  if model_obs==1	


tab1 mortstat cig_dis3
tabulate model_obs
tabulate mortstat if model_obs==1
tabulate cig_dis3  if model_obs==1

table  model_obs cigsmoke_3c sex, by (mortstat) content(freq) row col sc

table  model_obs cigsmoke_3c sex, by (mortstat xspd2)  content(freq) row col sc
table  model_obs cigsmoke_3c sex, by (cig_dis3 xspd2)  content(freq) row col sc

table  model_obs cigsmoke_3c sex, by (cig_dis3) content(freq) row col sc
 
 
 tabulate y_age_grp cigsmoke_3c  if y_age_grp >=1 & y_age_grp <=5
  tabulate y_age_grp cigsmoke_3c  if ( y_age_grp >=1 & y_age_grp <=5) & mortstat==1
 




log close svy_freq 

 

