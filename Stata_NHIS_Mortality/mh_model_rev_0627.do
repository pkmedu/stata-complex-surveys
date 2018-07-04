
capture log close cox
//e:\SASDATAMH\mh_model.do
clear
clear matrix
set mem 300m
set more off
set linesize 255
use "E:\SASDATAMH\forstata.dta"

compress
log using "E:\SASDATAMH\mh_model.log", name (cox) replace
tab mortstat if xsmoke==1


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

//tab1 agegrp5
////table mortstat agegrp5
//tab1 a1844 a4554 a5564 a6574 a75p 
//table sex agegrp5
//tab1 m_a1844 m_a4554 m_a5564 m_a6574 m_a75p 
//tab1  f_a1844 f_a4554 f_a5564 f_a6574 f_a75p

 
 //table mortstat agegrp5, row col if sex==1
  // table mortstat agegrp5 if sex==2

//tab1 x_xsmoke  male_currsmk female_currsmk male_frmsmk female_frmsmk male_nasmk female_nasmk

gen time_yr=0
replace time_yr = ceil( (interval/30.5/12) )
//tab1 time_yr

//sts list, at(10 40 to 160) by(posttran) compare

//stset time_yr[pweight=wt8] , failure(mortstat==1)
//sts list , at(1 2 3 4 5 6 7 8 9 10) by(xspd2) compare
//sts list, cumhaz at(1 2 3 4 5 6 7 8 9 10) by(xspd2)

//sts list, cumhaz at(1 2 3 4 5 6 7 8 9 10) by(sex x_xsmoke xspd2)

//label var xspd2 "1=SPD 2=No SPD"
// sts graph, by(xspd2) legend(lab(1 "SPD") lab(2 "No SPD"))
//sts graph, by(xspd2) legend(lab(1 "SPD") lab(2 "No SPD")) na

//sts graph, by(x_xsmoke)  na

//label var x_xsmoke "1=Current 2=Former 3=Never 9=Missing"
//sts graph, by(x_xsmoke) legend(lab(1 "Current") lab(2 "Former") lab (3 "Never")  lab (9 "Missing") )

svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(missing)
 stset interval [pweight=wt8], failure(mortstat==1)  
  capture noisily: svy: stcox ib2.xspd2  i.agegrp5 i.sex ib3.x_xsmoke,  basesurv(surv0) nohr
	        line surv0 _t, c(J) sort	
	gen surv1 = surv0^exp(_b[1.xspd2])
	
	tab1 surv1	 
	tab1 surv0
	
//foreach spop of varlist a1844 a4554 a5564 a6574 a75p  {
//svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(missing)
  //stset interval [pweight=wt8], failure(mortstat==1)  
  // capture noisily: svy, subpop(`spop'): stcox i.sex ib2.xspd2 ib3.x_xsmoke i.x_marital ///
   //                                i.x_racehisp i.x_educ_cat ib2.x_bmicat i.x_xchronic 
	//}

	
	
//foreach spop of varlist male_currsmk female_currsmk male_frmsmk female_frmsmk ///
 //                       male_nevsmk female_nevsmk  male_nasmk female_nasmk  {
//svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(missing)
 // stset interval [pweight=wt8], failure(mortstat==1)  
  //  capture noisily: svy, subpop(`spop'): stcox ib2.xspd2 i.agegrp5 i.x_marital ///
  //                                 i.x_racehisp i.x_educ_cat ib2.x_bmicat i.x_xchronic 
	
	//	 margins xspd2#agegrp5, vce(unconditional) subpop(`spop')						 
								
//}								
								//margins, over (xspd2 agegrp5) exp(exp(predict(xb)))  subpop(if sex==1  & x_xsmoke==1)
								
								
								//margins, vce(unconditional) dydx(xspd2) subpop(if sex==1  & x_xsmoke==1)
								
								// margins , over(posttran surgery) exp(exp(predict(xb)))

								// margins, over( posttran surgery )

								//margins agegrp5, vce(unconditional) subpop(male_currsmk)
								//margins, vce(unconditional) dydx(agegrp5) subpop(male_currsmk)
								 
								//margins xspd2#agegrp5, vce(unconditional) subpop(male_currsmk)
								//margins, vce(unconditional) dydx(xspd2#agegrp5) subpop(male_currsmk)
		 
// estimates store results
// capture estout results								  
                            	
log close cox       


