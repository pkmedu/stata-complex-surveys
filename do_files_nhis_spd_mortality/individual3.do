
capture log close indi
clear
set more off
set linesize 255
use "H:\spd_mort_data_code\indi12112014", clear
drop spd2_r
describe
log using "H:\spd_mort_data_code\indi.log", name (indi) replace

gen aa_age_grp=. if age_p >= 18 & age_p <=34
replace aa_age_grp=1 if age_p >=35 & age_p <=59
replace aa_age_grp=2 if age_p >=60 & age_p <=74
replace aa_age_grp=3 if age_p >=75 & age_p <=84
replace aa_age_grp=. if age_p >=85
	
 recode chronic (1/2=1) (0=2), gen(chronic1p)
 recode cigsmoke (4 10 99 = 99) , gen(cigsmoke_r)
 recode cigsmoke   (5 6 7 8 9 10=4) (4 99 = 99), gen(cigsmoke_r2)
 recode alcstat (4 9 10 = 99), gen(alcstat_r)
 recode alcstat (2 3 4=2) (9 10 = 99) , gen(alcstat_r2)
 recode alcstat_r2 (5/6=3) (7=4) (8=5) (99=.), gen(xalcstat)
 recode cigsmoke_r2 (99=.), gen(xcigsmoke)
 recode SPD2 (0=2), gen(xspd2)
 
 foreach i of varlist marital educ_cat poverty bmicat pa08_3r pa08_4r chronic chronic1p {
	 	 recode `i' (.=9), gen(`i'_r) 
	 	 }
tab xspd2
      
 run H:\spd_mort_data_code\xlabels.do

 tab syear cigsmoke_r if age_p>=35 & age_p<=84 & xspd2==1
 tab syear cigsmoke_r if mortstat==1 & age_p>=35 & age_p<=84 & xspd2==1
 
 table cig_dis sex xspd2, by(cigsmoke_r2 mortstat) content(freq)
 
 #delimit cr
 compress 
 save "H:\spd_mort_data_code\indi_data", replace

foreach x of varlist aa_age_grp sex marital marital_r racehisp educ_cat educ_cat_r  poverty poverty_r ///
             xspd2 chronic1p chronic1p_r xcigsmoke cigsmoke_r2 xalcstat alcstat_r2 pa08_3r ///
			 pa08_3r_r pa08_4r pa08_4r_r bmicat bmicat_r {
tab syear `x' if age_p>=35 & age_p<=84
}

foreach x of varlist aa_age_grp sex marital marital_r racehisp educ_cat educ_cat_r  poverty poverty_r ///
                  xspd2 chronic1p chronic1p_r xcigsmoke cigsmoke_r xalcstat alcstat_r2 ///
				  pa08_3r pa08_3r_r pa08_4r pa08_4r_r bmicat bmicat_r {
tab syear `x' if mortstat==1 & age_p>=35 & age_p<=84
}

keep if !missing(age_p, aa_age_grp, sex, racehisp, marital, educ_cat,  poverty, ///
                 xspd2, chronic1p,  bmicat, pa08_3r, xcigsmoke,  xalcstat, syear, mortstat, ///
			     marital_r, educ_cat_r, poverty_r, chronic1p_r, cigsmoke_r2, alcstat_r2, ///
			     pa08_3r_r, pa08_4r_r, bmicat_r)
compress 
save "E:\spd_mort_data_code\indi_data_nm", replace	

foreach x of varlist aa_age_grp sex marital marital_r racehisp educ_cat educ_cat_r  poverty poverty_r ///
             xspd2 chronic1p chronic1p_r xcigsmoke xcigsmoke cigsmoke_r2 xalcstat alcstat_r2 pa08_3r ///
			 pa08_3r_r pa08_4r pa08_4r_r bmicat bmicat_r {
tab syear `x' 
}

foreach x of varlist aa_age_grp sex marital marital_r racehisp educ_cat educ_cat_r  poverty poverty_r ///
                  xspd2 chronic1p chronic1p_r xcigsmoke cigsmoke_r2 xalcstat alcstat_r2 ///
				  pa08_3r pa08_3r_r pa08_4r pa08_4r_r bmicat bmicat_r {
tab syear `x' if mortstat==1
}		   
log close indi 

	
	

