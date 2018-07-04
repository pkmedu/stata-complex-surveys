
capture log close cox
//E:\SASDATAMH\mh_model.do
clear
clear matrix
set mem 300m
set more off
set linesize 255
use "E:\SASDATAMH\forstata.dta"

compress
log using "E:\SASDATAMH\mh_model.log", name (cox) replace

  replace interval =45 if interval ==0
  
  gen x_marital=marital
  replace x_marital=9 if marital ==.
  
  gen x_xsmoke=xsmoke
  replace x_xsmoke=9 if xsmoke ==. | xsmoke==4

  gen x_bmicat=bmicat
  replace x_bmicat=9 if bmicat ==.
  
   gen x_xchronic=xchronic
  replace x_xchronic=9 if xchronic ==.
  
  gen x_racehisp= racehisp
   replace x_racehisp=5 if racehisp==.

   gen x_educ_cat= educ_cat
   replace x_educ_cat=4 if educ_cat==.

  
//  tab1 interval x_marital x_xsmoke x_bmicat x_xchronic racehisp x_racehisp educ_cat x_educ_cat, m
  
gen male_currsmk=0
replace male_currsmk = 1 if sex==1 & x_xsmoke==1

gen female_currsmk=0
replace female_currsmk = 1 if sex==2 & x_xsmoke==1

gen male_frmsmk=0
replace male_frmsmk = 1 if sex==1 & x_xsmoke==2

gen female_frmsmk=0
replace female_frmsmk = 1 if sex==2 & x_xsmoke==2


gen male_nevsmk=0
replace male_nevsmk = 1 if sex==1 & x_xsmoke==3

gen female_nevsmk=0
replace female_nevsmk = 1 if sex==2 & x_xsmoke==3
  

gen male_nasmk=0
replace male_nasmk = 1 if sex==1 & x_xsmoke==9

gen female_nasmk=0
replace female_nasmk = 1 if sex==2 & x_xsmoke==9


gen a1844=0
replace a1844 = 1 if agegrp5==1

gen a4554=0
replace a4554 = 1 if  agegrp5==2

gen a5564=0
replace a5564 = 1 if  agegrp5==3

gen a6574=0
replace a6574 = 1 if agegrp5==4

gen a75p=0
replace a75p = 1 if agegrp5==5


gen m_a1844=0
replace m_a1844 = 1 if sex==1 & agegrp5==1

gen m_a4554=0
replace m_a4554 = 1 if sex==1 & agegrp5==2

gen m_a5564=0
replace m_a5564 = 1 if sex==1 & agegrp5==3

gen m_a6574=0
replace m_a6574 = 1 if sex==1 & agegrp5==4

gen m_a75p=0
replace m_a75p = 1 if sex==1 & agegrp5==5


gen f_a1844=0
replace f_a1844 = 1 if sex==2 & agegrp5==1

gen f_a4554=0
replace f_a4554 = 1 if sex==2 & agegrp5==2

gen f_a5564=0
replace f_a5564 = 1 if sex==2 & agegrp5==3

gen f_a6574=0
replace f_a6574 = 1 if sex==2 & agegrp5==4

gen f_a75p=0
replace f_a75p = 1 if sex==2 & agegrp5==5


gen time_yr=0
replace time_yr = ceil( (interval/30.5/12) )

svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(missing)
 stset time_yr [pweight=wt8], failure(mortstat==1)
 
 drop H 
 //capture noisily: svy: stcox ib2.xspd2 i.agegrp5 i.sex ib3.x_xsmoke
  capture noisily: svy: stcox i.agegrp5 i.sex , strata (x_xsmoke) basechazard(H)
      gen cu_smoker=H if x_xsmoke==1
	  gen fo_smoker=H if x_xsmoke==2
	  gen nev_smoker=H if x_xsmoke==3
	  gen unk=H if x_xsmoke==9
	  line fo_smoker nev_smoker _t, c( J J) sort	
	  
	//line surv0 _t, c(J) sort	
	//gen surv1 = surv0^exp(_b[1.xspd2])
	//tab1 surv1	 
	//tab1 surv0
   	
log close cox       


