
foreach package in logout {
capture which `package'
if _rc==111 ssc install `package'
}

capture log close yyrates
//clolog_attained_age_duration.do
clear
set more off
set linesize 255
use "H:\spd_mort_data_code\py_working_file2"
*log using "H:\spd_mort_data_code\yycontent.log", name (yyrates) replace

 generate XSPD4 = SPD4+1

  label define spd4_lab ///  
			1 "K6 0"  ///
	        2 "K6 1-5" ///   
	        3 "K6 6-10" ///   
	        4 "K6 11-24" 
 label values  XSPD4 spd4_lab

recode cigsmoke_r2 (2 3 =2)  (4=3) (99=.), gen(cigsmoke_3c)


recode cigsmoke_3c (2 3 =2), gen(cig_never_ever)

	 
	 label define cig_never_ever_lab ///  
			1 "Never"  ///
	        2 "Ever"   
	 label values  cig_never_ever cig_never_ever_lab
	  
recode cigsmoke_r (99=.), gen(cigsmoke_9c)
	 
	 label define cigsmoke_9c_lab  ///
	        1 "Never"   ///
	        2 "Curr <1 pack/d"   ///
	        3 "Curr 1+ packs/d"  ///
			5 "FQ_0�4 yrs ago"  ///
	        6 "FQ_5�9 yrs ago"  ///
			7 "FQ_10�19 yrs ago" ///  
            8 "FQ_20�29 yrs ago"  ///
			9 "FQ_30+ yrs ago" 
            
     label values  cigsmoke_9c cigsmoke_9c_lab


    label define cigsmoke_3c_lab ///  
			1 "Never"  ///
	        2 "Current" ///   
	        3 "Former"  
	 label values  cigsmoke_3c cigsmoke_3c_lab

	 tab1 cigsmoke_3c
	 
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




 
/*
gen std_wgt = .5207 if aa_age_grp ==1
replace std_wgt = .3327 if aa_age_grp ==2
replace std_wgt = .1465 if aa_age_grp ==3
*/
gen xstd_wgt = 0.694 if aa_age_grp ==2
replace xstd_wgt = 0.306 if aa_age_grp ==3


gen std_wgt = 0.360776161 if x_age_grp ==1
replace std_wgt = 0.299145166 if x_age_grp ==2
replace std_wgt = 0.193567782 if x_age_grp ==3
replace std_wgt = 0.14651089 if x_age_grp ==4

gen ystd_wgt = 0.2904 if y_age_grp ==1
replace ystd_wgt = 0.2243 if y_age_grp ==2
replace ystd_wgt = 0.1796 if y_age_grp ==3
replace ystd_wgt = 0.1586 if y_age_grp ==4
replace ystd_wgt = 0.1471 if y_age_grp ==5

gen model_obs = !missing(y_age_grp, sex, racehisp, educ_cat, marital, ///
 xalcstat, chronic1p, pa08_3r,cigsmoke_3c, chronic1p, xspd2)

 
						  
egen spd_chr_cig3c = group(xspd2 chronic1p cigsmoke_3c ), l
egen spd_chr_cig2c = group(xspd2 chronic1p cig_never_ever), l
egen spd_chr = group(xspd2 chronic1p ), l
egen spd_cig2c = group(xspd2 cig_never_ever ), l


 
recode dead (.=0), gen(xdead) 


gen xd1000 = xdead*1000

 gen xlp_death =  lp_death*1000

 gen xlpc_death =  lpc_death*1000
 gen xm_cvd_death = m_cvd_death*1000

 
 tabulate xspd2 if model_obs==1	
tabulate chronic1p if model_obs==1	
tabulate spd_chr_cig3c  if model_obs==1	
tabulate cigsmoke_3c  if model_obs==1
tabulate cig_never_ever  if model_obs==1
tabulate spd_cig2c  if model_obs==1	
tabulate spd_chr_cig2c  if model_obs==1
tabulate spd_chr  if model_obs==1

tabulate y_age_grp  if model_obs==1 & xdead==1

tabulate spd_cig2c  if model_obs==1	& xdead==1

tabulate spd_chr_cig2c  if model_obs==1 & xdead==1


foreach indvar of varlist cigsmoke_9c {
tab2 `indvar' XSPD4 if model_obs==1 & xdead==1 
}

foreach indvar of varlist cig_never_ever cigsmoke_3c xalcstat chronic1p_r pa08_3r_r {
tab2 `indvar' XSPD4 if model_obs==1 & xdead==1 
}


tab2 y_age_grp XSPD4  if model_obs==1 & xdead==1 & sex==1
tab2 y_age_grp XSPD4  if model_obs==1 & xdead==1 & sex==2

tab2 y_age_grp XSPD4  if model_obs==1 & xdead==1 
tabulate XSPD4  if model_obs==1 & xdead==1 
tabulate XSPD4  if model_obs==1 & xdead==1 & sex==1
tabulate XSPD4  if model_obs==1 & xdead==1 & sex==2

tabulate y_age_grp  if model_obs==1 & xdead==1 & sex==1
tabulate y_age_grp  if model_obs==1 & xdead==1 & sex==2

/*
tabulate y_age_grp  if model_obs==1 & xdead==1 & xspd2==1
tabulate y_age_grp  if model_obs==1 & xdead==1 & xspd2==2

tabulate y_age_grp  if model_obs==1 & xdead==1 & xspd2==1 & sex==1
tabulate y_age_grp  if model_obs==1 & xdead==1 & xspd2==1  & sex==2

tabulate y_age_grp  if model_obs==1 & xdead==1 & xspd2==2 & sex==1
tabulate y_age_grp  if model_obs==1 & xdead==1 & xspd2==2  & sex==2

*/


*run H:\spd_mort_data_code\xtra_labels.do
svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(centered)

foreach indvar of varlist y_age_grp  {
display _newline _column(30) "Weighted Count - Ages 50 to 74"
svy, subpop(if model_obs==1 ): mean xd1000, over(`indvar' xspd2) 
 }
 foreach indvar of varlist y_age_grp  {
display _newline _column(30) "Weighted Count - Ages 50 to 74"
svy, subpop(if model_obs==1 ): mean xd1000, over(`indvar') 
 }


foreach indvar of varlist y_age_grp sex {
display _newline _column(30) "Weighted Count - Ages 50 to 74"
svy, subpop(if model_obs==1 ): mean xd1000, over(`indvar' XSPD4) 
 }

foreach indvar of varlist y_age_grp  {
display _newline _column(30) "Weighted Count - Ages 50 to 74"
svy, subpop(if model_obs==1 ): mean xd1000, over(`indvar' XSPD4 sex) 
 }
 
 svy, subpop (if model_obs==1): mean xd1000, stdize(aa_age_grp) stdweight(xstd_wgt) ///
      over (XSPD4) 
	  
 svy, subpop (if model_obs==1): mean xd1000, stdize(aa_age_grp) stdweight(xstd_wgt) ///
      over (XSPD4 sex) 
	  
foreach indvar of varlist  cigsmoke_9c {
display _newline _column(30) "Weighted Count - Ages 50 to 74"
	   svy, subpop (if model_obs==1): mean xd1000, stdize(aa_age_grp) stdweight(xstd_wgt) ///
      over (XSPD4 `indvar') 
 }
 
	  
foreach indvar of varlist cig_never_ever cigsmoke_3c xalcstat cigsmoke_9c chronic1p_r pa08_3r_r {
display _newline _column(30) "Weighted Count - Ages 50 to 74"
	   svy, subpop (if model_obs==1): mean xd1000, stdize(aa_age_grp) stdweight(xstd_wgt) ///
      over (XSPD4 `indvar') 
 }
 
 foreach indvar of varlist chronic1p {
display _newline _column(30) "Weighted Count - Ages 50 to 74"
	   svy, subpop (if model_obs==1): mean xd1000, stdize(aa_age_grp) stdweight(xstd_wgt) ///
      over (xspd2 `indvar') 
 }
 foreach indvar of varlist sex {
display _newline _column(30) "Weighted Count - Ages 50 to 74"
	   svy, subpop (if model_obs==1): mean xd1000, stdize(aa_age_grp) stdweight(xstd_wgt) ///
      over (`indvar' xspd2) 
 }
 
 
 
foreach indvar of varlist cig_never_ever cigsmoke_3c cigsmoke_9c xalcstat chronic1p_r pa08_3r_r {
display _newline _column(30) "Weighted Count - Ages 50 to 74"
	   svy, subpop (if model_obs==1): mean xd1000, stdize(aa_age_grp) stdweight(xstd_wgt) ///
      over (`indvar') 
 }

foreach indvar of varlist y_age_grp  {
display _newline _column(30) "Weighted Count - Ages 50 to 74"
svy, subpop(if model_obs==1 ): mean xd1000, over(`indvar' xspd2) 
 }

foreach indvar of varlist y_age_grp  {
display _newline _column(30) "Weighted Count - Ages 50 to 74"
svy, subpop(if model_obs==1 ): mean xd1000, over(`indvar' sex) 
 }

 foreach indvar of varlist y_age_grp  {
display _newline _column(30) "Weighted Count - Ages 50 to 74"
svy, subpop(if model_obs==1 ): mean xd1000, over(`indvar' sex xspd2) 
 }



svy, subpop (if model_obs==1): mean xd1000, stdize(aa_age_grp) stdweight(xstd_wgt) ///
      over (xspd2) 
	  lincom [xd1000]SPD - [xd1000]NoSPD

	  svy, subpop (if model_obs==1): mean xd1000, stdize(aa_age_grp) stdweight(xstd_wgt) ///
      over (cig_never_ever)
	  lincom [xd1000]Never - [xd1000]Ever
	  
	  
	  svy, subpop (if model_obs==1): mean xd1000, stdize(aa_age_grp) stdweight(xstd_wgt) ///
      over (chronic1p)
	  lincom [xd1000]_subpop_1 - [xd1000]None
	  
	  svy, subpop (if model_obs==1): mean xd1000, stdize(aa_age_grp) stdweight(xstd_wgt) ///
      over (spd_cig2c)
	  lincom [xd1000]_subpop_1 - [xd1000]_subpop_3
	  lincom [xd1000]_subpop_2 - [xd1000]_subpop_4
	  
	  svy, subpop (if model_obs==1): mean xd1000, stdize(aa_age_grp) stdweight(xstd_wgt) ///
      over (spd_chr)
	  lincom [xd1000]_subpop_1 - [xd1000]_subpop_3
	  lincom [xd1000]_subpop_2 - [xd1000]_subpop_4
	  
	  svy, subpop (if model_obs==1): mean xd1000, stdize(aa_age_grp) stdweight(xstd_wgt) ///
      over (spd_chr_cig2c)
	  lincom [xd1000]_subpop_1 - [xd1000]_subpop_5
	  lincom [xd1000]_subpop_2 - [xd1000]_subpop_6
	  lincom [xd1000]_subpop_3 - [xd1000]_subpop_7
	  lincom [xd1000]_subpop_4 - [xd1000]_subpop_8
	  
	  



/*
foreach indvar of varlist xspd2 cig_never_ever chronic1p  spd_cig2c spd_chr spd_chr_cig2c {
	 display _newline(2) _column(35) " Dependent variable = `depvar' "  
	  svy, subpop (if model_obs==1): mean xd1000, stdize(aa_age_grp) stdweight(xstd_wgt) ///
      over (`indvar')	  
	  
	   					
	 	 }		  
	
	lincom [`depvar']_subpop_1 - [`depvar']_subpop_4
	  lincom [`depvar']_subpop_2 - [`depvar']_subpop_5
	  lincom [`depvar']_subpop_3 - [`depvar']_subpop_6	
	 */
*logout, save(H:\spd_mort_results\rates) excel replace: ///
log close yyrates


