
capture log close sindi
clear
set more off
set linesize 255
use "H:\spd_mort_data_code\causes_added_data", clear
log using "H:\spd_mort_data_code\sindi.log", name (sindi) replace


recode cigsmoke_r2 (2=1) (1 3 4 =0) (99=.), gen(cig_lt_1_pack)
recode cigsmoke_r2 (3=1) (1 2 4 =0) (99=.), gen(cig_1p_pack)
recode cigsmoke_r2 (4=1) (1 2 3 =0) (99=.), gen(former_smk)
recode cigsmoke_r2 ( 2 3 4=1) (1 3 4 =0) (99=.), gen(cf_smk)

gen xcig_lt_1_pack= cig_lt_1_pack*100
gen xcig_1p_pack= cig_1p_pack*100
gen xformer_smk= former_smk*100
gen xcf_smk = cf_smk*100

la variable xcig_lt_1_pack "current smoker <1 pack"
la variable xcig_1p_pack "current smoker 1+ pack"
la variable xformer_smk "Former smoker"
la variable xcf_smk "current/former smoker"
/*
  foreach x of varlist   cig_1p_pack cig_1p_pack former_smk cf_smk  {
            tab syear `x' if age_p>=35 & age_p<=84
}
  
  */
 *run H:\spd_mort_data_code\xlabels.do
 
svyset psu [pweight=wt8], strata (stratum) singleunit(missing)


foreach depvar of varlist cig_dis cig_dis3 cig_dis2  {
 display _newline _column(30) "Crosstables by SPD Status Ages 35 to 84 among those with SPD"
 svy, subpop(if age_p>=35 & age_p<=84 & xspd2==1) percent: tabulate `depvar' cigsmoke_r2, col obs  ///
  ci format (%5.1f) stubwidth(30)
			  }

			  
foreach depvar of varlist cig_dis cig_dis3 cig_dis2  {
 display _newline _column(30) "Crosstables by SPD Status Ages 35 to 84 among those with No SPD"
 svy, subpop(if age_p>=35 & age_p<=84 & xspd2==2) percent: tabulate `depvar' cigsmoke_r2 , col obs  ///
  ci format (%5.1f) stubwidth(30)
			  }

foreach depvar of varlist cig_dis cig_dis3 cig_dis2  {
 display _newline _column(30) "Crosstables by SPD Status Ages 35 to 84"
 svy, subpop(if age_p>=35 & age_p<=84) percent: tabulate `depvar' xspd2, col obs  ///
  ci format (%5.1f) stubwidth(30)
			  }

			  foreach depvar of varlist cig_dis cig_dis3 cig_dis2  {
 display _newline _column(30) "Crosstables by SPD Status Ages 35 to 84"
 svy, subpop(if age_p>=35 & age_p<=84) percent: tabulate `depvar' xmdd, col obs  ///
  ci format (%5.1f) stubwidth(30)
			  }
			  
			  
foreach depvar of varlist xcig_lt_1_pack xcig_1p_pack xformer_smk xcf_smk   {
   svy, subpop(a35_84): mean `depvar', over (sex xspd2)
lincom [`depvar']_subpop_1 - [`depvar']_subpop_2
lincom [`depvar']_subpop_3 - [`depvar']_subpop_4
    }
	
svyset psu [pweight=wt8], strata (stratum) singleunit(missing)
foreach depvar of varlist xcig_lt_1_pack xcig_1p_pack xformer_smk xcf_smk   {
   svy, subpop(a35_84): mean `depvar', over (xspd2)
lincom [`depvar']SPD - [`depvar']NoSPD
    }


log close sindi 
