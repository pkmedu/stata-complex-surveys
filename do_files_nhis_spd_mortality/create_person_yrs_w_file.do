
capture log close xpy
clear
set more off
set linesize 255
use "H:\spd_mort_data_code\tpp", clear
drop spd2_r xcigsmoke
*describe
log using "H:\spd_mort_data_code\xpy.log", name (xpy) replace

gen aa_age_grp=. if age_p >= 18 & age_p <=34
replace aa_age_grp=1 if age_p >=35 & age_p <=49
replace aa_age_grp=2 if age_p >=50 & age_p <=64
replace aa_age_grp=3 if age_p >=65 & age_p <=74
replace aa_age_grp=. if age_p >=85

gen a35_84=0 
replace a35_84=1 if age_p >= 35 & age_p <=84
	
 recode chronic (1/2=1) (0=2), gen(chronic1p)
 recode cigsmoke (4 10 99 = 99) , gen(cigsmoke_r)
 recode cigsmoke   (5 6 7 8 9 10=4) (4 99 = 99), gen(cigsmoke_r2)
 recode alcstat (4 9 10 = 99), gen(alcstat_r)
 recode alcstat (2 3 4=2) (9 10 = 99) , gen(alcstat_r2)
 recode alcstat_r2 (5/6=3) (7=4) (8=5) (99=.), gen(xalcstat)
 recode cigsmoke_r2 (99=.), gen(xcigsmoke)
 recode SPD2 (0=2), gen(xspd2)
 recode mdd (0=2), gen(xmdd)
 
 recode cig_dis(1 3=1) (2=2) (4=3), gen(cig_dis3)
 recode cig_dis(1 2 3=1) (4=2), gen(cig_dis2)
 
gen dur_cat=1 if studyyrs <=1 & studyyrs<=2
replace dur_cat=2 if studyyrs>=3 & studyyrs<=4
replace dur_cat=3 if studyyrs>=5 & studyyrs<=6
replace dur_cat=4 if studyyrs>=7 & studyyrs<=8


 recode cigsmoke_r2 (99=.), gen(cigsmoke_r2x)

gen lung_death =0
replace lung_death=1 if dead==1 & cig_dis==1  

gen m_cvd_death =0
replace m_cvd_death=1 if dead==1 & cig_dis==2  

gen pulmo_death =0
replace pulmo_death=1 if dead==1 & cig_dis==3 

gen other_death =0
replace other_death=1 if dead==1 & cig_dis==4 

gen lp_death =0
replace lp_death=1 if dead==1 & (cig_dis==1 | cig_dis==3)

gen lpc_death =0
replace lpc_death=1 if dead==1 & (cig_dis==1 | cig_dis==2 | cig_dis==3)

 
 
 foreach i of varlist marital educ_cat poverty bmicat pa08_3r pa08_4r chronic chronic1p {
	 	 recode `i' (.=9), gen(`i'_r) 
	 	 }


		 
 *run H:\spd_mort_data_code\py_labels.do
 /*
 keep if a35_84==1
 

 foreach x of varlist  mortstat xspd2 mdd cigsmoke_r cigsmoke_r2 cig_dis  {
            tab syear `x' if age_p>=35 & age_p<=84
}
 
 
 */
 #delimit cr
 compress 
 save "H:\spd_mort_data_code\py_working_file2", replace


log close xpy 

	
	

