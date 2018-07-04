
capture log close cox
//G:\SASDATAMH\mh_model.do
clear
clear matrix
set mem 300m
set more off
set linesize 255
use "G:\SASDATAMH\forstata.dta"

compress
log using "G:\SASDATAMH\mh_model.log", name (cox) replace
tab mortstat if xsmoke==1

gen currsmk=0
replace currsmk = 1 if xsmoke==1

gen frmsmk=0
replace frmsmk = 1 if xsmoke==2

gen nevsmk=0
replace nevsmk = 1 if xsmoke==3


gen male_currsmk=0
replace male_currsmk = 1 if sex==1 & xsmoke==1
gen female_currsmk=0
replace female_currsmk = 1 if sex==2 & xsmoke==1

gen male_frmsmk=0
replace male_frmsmk = 1 if sex==1 & xsmoke==2
gen female_frmsmk=0
replace female_frmsmk = 1 if sex==2 & xsmoke==2


gen male_nevsmk=0
replace male_nevsmk = 1 if sex==2 & xsmoke==3
gen female_nevsmk=0
replace female_nevsmk = 1 if sex==2 & xsmoke==3

table xspd2

foreach gvar of varlist currsmk frmsmk nevsmk male_currsmk female_currsmk ///
 male_frmsmk female_frmsmk male_nevsmk female_nevsmk {
table `gvar' mortstat, contents(freq)
}

char xsmoke [omit] 3 
char xspd2 [omit] 2 
char xchronic [omit] 1 
char bmicat [omit] 2 
char educ_cat [omit] 1  
char agegrp5 [omit] 1 
char marital [omit] 1 
char racehisp [omit] 1
char xsmoke [omit] 3

svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(missing)
  stset interval [pweight=wt8], failure(mortstat==1)
              capture noisily xi: svy, subpop(male_currsmk): stcox i.xspd2 i.agegrp5 i.marital ///
                                          i.racehisp i.educ_cat i.bmicat i.xchronic 
								 //margins, vce(unconditional) subpop(male_currsmk) at(_Ixspd2_1=1)
								 //margins, vce(unconditional) subpop(male_currsmk) at(_Ixspd2_2=2)								 
							capture la var _Ixspd2_1  "Serious Psy Distress"
							capture la var _Iagegrp5_2 "Age 45-54"
							capture la var _Iagegrp5_3 "Age 55-64"
							capture la var _Iagegrp5_4 "Age 65-74"
							capture la var _Iagegrp5_5 "Age 75+"
							capture la var _Imarital_2 "Sep/Divorced"
							capture la var _Imarital_3 "Widow"   
							capture la var _Imarital_4 "Nev Married"
							capture la var _Iracehisp_2 "NH Black" 
							capture la var _Iracehisp_3 "Hispanic"
							capture la var _Iracehisp_4 "Other"
							capture la var _Ieduc_cat_2 "Hi Sch/GED/S_Col"
							capture la var _Ieduc_cat_3 "Col Degree or Hi"
							capture la var _Ibmicat_1 "Normal Range"
							capture la var _Ibmicat_3 "Overweight"
							capture la var _Ibmicat_4 "Obese"
							capture la var _Ixchronic_1 "1 Chrnc Cond" 
							capture la var _Ixchronic_3 "2+ Chrnc Cond"			  
	
log close cox       


