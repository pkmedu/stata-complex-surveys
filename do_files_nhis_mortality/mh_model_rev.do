
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

  
  tab1 interval x_marital x_xsmoke x_bmicat x_xchronic racehisp x_racehisp educ_cat x_educ_cat, m
  
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


tab1 x_xsmoke  male_currsmk female_currsmk male_frmsmk female_frmsmk male_nasmk female_nasmk

  
foreach spop of varlist male_currsmk female_currsmk male_frmsmk female_frmsmk ///
                        male_nevsmk female_nevsmk  male_nasmk female_nasmk  {
svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(missing)
  stset interval [pweight=wt8], failure(mortstat==1)  
    capture noisily: svy, subpop(`spop'): stcox ib2.xspd2 i.agegrp5 i.x_marital ///
                                   i.x_racehisp i.x_educ_cat ib2.x_bmicat i.x_xchronic 
	
		 margins xspd2#agegrp5, vce(unconditional) subpop(`spop')						 
								
}								
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


