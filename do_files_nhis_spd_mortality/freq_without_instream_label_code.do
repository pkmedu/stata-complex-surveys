

capture log close freq
clear
set more off
set linesize 255
use "H:\spd_mort_data_code\causes_added_data_rev", clear

*log using "H:\spd_mort_data_code\freq.log", name (freq) replace

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

svyset psu [pweight=wt8], strata (stratum) singleunit(missing)
*cig_dis cig_dis3 cig_dis2 xcigsmoke
foreach depvar of varlist cigsmoke_9c  {
 display _newline _column(30) "Crosstables by SPD Status Ages 50 to 74 among those with No SPD"
 svy, subpop(if age_p>=35 & age_p<=50) percent: tabulate `depvar' xspd2 , col obs  ///
  ci format (%5.1f) stubwidth(30)
			  }



foreach x of varlist  mortstat xspd2 mdd cigsmoke_r cigsmoke_r2 cig_dis  {
            tab syear `x' if age_p>=35 & age_p<=74
}
 
 foreach x of varlist  mortstat xspd2 mdd cigsmoke_r cigsmoke_r2 cig_dis  {
            tab syear `x' if age_p>=35 & age_p<=74
}

foreach x of varlist  mortstat xspd2 mdd cigsmoke_r cigsmoke_r2 cig_dis  {
            tab syear `x' if age_p>=35 & age_p<=74
}
 
 
 
 keep if mortstat==1
 

tabulate sex syear 
 
tabulate f_age_grp syear  
tabulate f_age_grp syear  if mortstat==1

tabulate x_age_grp syear  
tabulate x_age_grp syear  if mortstat==1

 
tabulate y_age_grp cigsmoke_3c  if mortstat==1
tabulate x_age_grp cigsmoke_3c  if mortstat==1
tabulate f_age_grp cigsmoke_3c  if mortstat==1

tabulate y_age_grp cigsmoke_r2  if mortstat==1
tabulate x_age_grp cigsmoke_r2  if mortstat==1
tabulate f_age_grp cigsmoke_r2  if mortstat==1

tabulate y_age_grp syear  if mortstat==1
tabulate y_age_grp cig_dis  if mortstat==1
table cig_dis sex xspd2, by(cigsmoke_3c ) content(freq) row col sc
table cig_dis2 sex xspd2, by(cigsmoke_3c ) content(freq) row col sc
table cig_dis3 sex xspd2, by(cigsmoke_3c ) content(freq) row col sc



 
 table cig_dis sex xspd2, by(xcigsmoke ) content(freq) row col sc
 table cig_dis sex xspd2, by(cigsmoke_r ) content(freq) row col sc 
 table cig_dis sex xspd2, by(cigsmoke_r2 ) content(freq) row col sc
 table cig_dis sex xmdd, by(cigsmoke_r2 ) content(freq) row col sc
 
 table cig_dis2 sex xspd2 , by(xcigsmoke) content(freq ) row col sc
 table cig_dis2 sex xspd2 , by(cigsmoke_r ) content(freq ) row col sc
 table cig_dis2 sex xspd2, by(cigsmoke_r2 ) content(freq) row col sc
 table cig_dis2 sex xmdd, by(cigsmoke_r2 ) content(freq) row col sc
 
 table cig_dis3 sex xspd2 , by(xcigsmoke) content(freq ) row col sc
 table cig_dis3 sex xspd2 , by(cigsmoke_r ) content(freq ) row col sc
 table cig_dis3 sex xspd2, by(cigsmoke_r2 ) content(freq) row col sc
 table cig_dis3 sex xmdd, by(cigsmoke_r2 ) content(freq) row col sc

 table f_age_grp sex xspd2 , by(cigsmoke_r2) content(freq ) row col sc
 table x_age_grp sex xspd2 , by(cigsmoke_r2) content(freq ) row col sc
 table y_age_grp sex xspd2 , by(cigsmoke_3c) content(freq ) row col sc
 
 table f_age_grp sex , by(cigsmoke_r2) content(freq ) row col sc
 table x_age_grp sex , by(cigsmoke_r2) content(freq ) row col sc
 table y_age_grp sex , by(cigsmoke_3c) content(freq ) row col sc
 
 
 
 
 
log close freq 

 

