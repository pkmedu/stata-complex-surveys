capture log close cox
//G:\SASDATAMH\mh_model.do
clear
clear matrix
set mem 300m
set more off
set linesize 255
use "G:\SASDATAMH\forstata.dta"

compress
log using "G:\SASDATAMH\mh_model_rev.log", name (cox) replace

  replace interval =45 if interval ==0
     


gen time_yr=0
replace time_yr = ceil( (interval/30.5/12) )

gen xtime_yr=0
replace xtime_yr = time_yr+age_p


gen xa1844=0
replace xa1844 = 1 if xtime_yr >= 18 & xtime_yr <=44

gen xa4554=0
replace xa4554 = 1 if xtime_yr >= 45 & xtime_yr <=54

gen xa5564=0
replace xa5564 = 1 if xtime_yr >= 55 & xtime_yr <=64

gen xa6574=0
replace xa6574 = 1 if xtime_yr >= 65 & xtime_yr <=74

gen xa75p=0
replace xa75p = 1 if xtime_yr >= 75


label define sexlab 1 "Male" 2 "Female"
label values sex sexlab


svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(missing)
stset xtime_yr [pweight=wt8], failure(mortstat==1) 
foreach spop of varlist xa1844     {
capture noisily: svy, subpop(`spop'): stcox i.sex ib2.xspd2 ib3.xsmoke i.marital ///
                                   ib2.racehisp i.educ_cat ib2.bmicat i.xchronic, nolog 
	capture la var _Isex_2 "Male"   
	
	capture la var _Ispd_1 "Serious Psych Disress"
	
    capture la var _Imarital_2 "Divorce/Sep"
	capture la var _Imarital_3 "Widow"
    capture la var _Imarital_4 "Never Married"  
	
    capture la var _Iracehisp_1 "Hispanic"
    capture la var _Iracehisp_2 "Black"
    capture la var _Iracehisp_1 "Other"
                                                                 
    capture la var _Ieduc_cat_2 "HS Graduate"                                                                              
    capture la var _Ieduc_cat_3 "College or Higher"
 
    capture la var _Ixsmoke_1 "Current Smoker"                   
    capture la var _Ixsmoke_2 "Former Smoker"  
    capture la var _Ixsmoke_4 "Smoking Status Unknown"  
 
    capture la var _Ibmicat_1 "Underweight"                   
    capture la var _Ibmicat_3 "Overweight"  
    capture la var _Ibmicat_4 "Obese"
 
    capture la var _Ixchronic_2 "1 Chronic Cond"  
    capture la var _Ixchronic_3 "2+ Chronic Cond"                    		   
	
	estimates store a
	}	
   capture noisily estout  a
	// capture noisily estout  a  using  "G:\SASDATAMH\model_1844.txt", label  ///
    // drop(_cons) varwidth(35) cells( "b(star label(OR) fmt(%5.2f)) ci (par label(CI))")  ///
       //          modelwidth(12) eform replace   


predict ch, basechazard
predict s, basesurv
summarize ch s
stcurve, hazard


log close cox       

