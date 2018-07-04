capture log close log1
//e:/stata_app/YPLL1.do 3/13/2013
clear
//set mem 300m
set more off
use "E:\stata_app\tor.dta"
compress
gen xxsmoke=.
replace xxsmoke=1 if xsmoke==1
replace xxsmoke=2 if xsmoke==2
replace xxsmoke=3 if xsmoke==3

label define lab_xxsmoke ///
   1 "CurrentSmk" ///
   2 "FormerSmk"  ///
   3 "NeverSmk" 
label values xxsmoke lab_xxsmoke


label define lab_xspd2 ///
   1 "SPD" ///
   2 "NoSPD"  
label values xspd2 lab_xspd2

label define lab_sex ///
   1 "Male" ///
   2 "Female"  
label values sex lab_sex


log using "E:\stata_app\YPLL1.log", name(log1) replace
svyset psu [pweight=wt8], strata (stratum)
     foreach depvar of varlist ypll_ler {
   svy, subpop(mortstat): mean `depvar', over (xxsmoke)  
   lincom [`depvar']CurrentSmk - [`depvar']NeverSmk
   lincom [`depvar']CurrentSmk - [`depvar']FormerSmk
   lincom [`depvar']NeverSmk - [`depvar']FormerSmk
}

svyset psu [pweight=wt8], strata (stratum)
     foreach depvar of varlist ypll_ler {
   svy, subpop(mortstat): mean `depvar', over (xxsmoke xspd2 sex)  
   
   }

   
svyset psu [pweight=wt8], strata (stratum)
     foreach depvar of varlist ypll_75 {
   svy, subpop(premature_ypll_75_flag): mean `depvar', over (xxsmoke)  
   lincom [`depvar']CurrentSmk - [`depvar']NeverSmk
   lincom [`depvar']CurrentSmk - [`depvar']FormerSmk
   lincom [`depvar']NeverSmk - [`depvar']FormerSmk
}


svyset psu [pweight=wt8], strata (stratum)
     foreach depvar of varlist ypll_75 {
   svy, subpop(premature_ypll_75_flag): mean `depvar', over (xxsmoke xspd2 sex)  
   }
log close log1



