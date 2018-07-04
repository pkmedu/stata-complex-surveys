
capture log close cox
//G:\SASDATAMH\mh_model.do
clear
clear matrix
set mem 300m
set more off
set linesize 255
use "G:\SASDATAMH\forstata.dta"
describe
compress
log using "G:\SASDATAMH\content.log", name (cox) replace

gen xdthdate=.
replace xdthdate=dthdate if dthdate >intdate
replace xdthdate=dthdate+45 if dthdate ==intdate

drop dox
gen dox=xdthdate if mortstat==1
replace dox=enddate if mortstat==0


//change 'current smoking status unknown' to missing
replace xsmoke =. if xsmoke==4


//convert character into numeric variable
gen srvy_yr_n = real(srvy_yr)

//create 8 dummy variables
foreach x of numlist 1997 1998 1999 2000 2001 2002 2003 2004 {
      gen  yr`x'=0
       replace yr`x'=1 if srvy_yr_n==`x'
      } 
 
 //create factors (nominal variables)
gen yr01_04=2
replace yr01_04=1 if srvy_yr_n>=2001 & srvy_yr_n<=2004

gen byte a_age = ceil((dox - dob)/365.25)

gen a_age_grp=0
replace a_age_grp = 1 if a_age >= 18 & a_age <=44
replace a_age_grp = 2 if a_age >= 45 & a_age <=54
replace a_age_grp = 3 if a_age >= 55 & a_age <=64
replace a_age_grp = 4 if a_age >= 65 & a_age <=74
replace a_age_grp = 5 if a_age >= 75


gen dur = ceil((dox - intdate)/365.25)


gen dur_q= floor(((year(dox)-year(intdate))*12+month(dox)-month(intdate))/3)
recode dur_q (0=1)

//table dur_q srvy_yr_n, by(mortstat) contents(freq)

ta dur_q, ge(d)

gen dur1 = d1+d2+d3+d4
gen dur2 = d5+d6+d7+d8
gen dur3 = d9+d10+d11+d12
gen dur4 = d13+d14+d15+d16
gen dur5 = d17+d18+d19+d20
gen dur6 = d21+d22+d23+d24
gen dur7 = d25+d26+d27+d28
gen dur8 = d29+d30+d31+d32
gen dur9 = d33+d34+d35+d36
gen dur10 = d37+d38+d39


gen yr00_04x=2
replace yr00_04x=1 if srvy_yr_n>=2000 & srvy_yr_n<=2004


char xspd2 [omit] 2
char xsmoke [omit] 3
char racehisp [omit] 2
char bmicat [omit] 2
char yr00_04x [omit] 2

//For later use -  exit(time doe + 10*365.25)  
svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(missing)
stset dox [pweight=wt8], failure(mortstat==1)  id (publicid_2) origin(intdate) enter(intdate) scale(365.25) 
//stset dox [pweight=wt8], failure(mortstat==1)  id (publicid_2) origin(dob) enter(intdate) scale(365.25) 



//stphplot, strata(a_age_grp) adjust(sex xspd2 xsmoke marital ///
//                                   racehisp educ_cat bmicat xchronic ///
//								   yr1998 yr1999 yr2000 yr2001 yr2002 yr2003 yr2004) zero
								   
//stphplot, strata(xspd2) adjust(sex xsmoke marital ///
//                                   racehisp educ_cat bmicat xchronic ///
//	

 capture noisily  xi:svy: stcox i.sex i.xspd2 i.xsmoke i.marital ///
                                   i.racehisp i.educ_cat i.bmicat i.xchronic,   nolog
capture la var _Isex_2 "Female"	
capture la var _Ixspd2_1 "Serious Psy Distress"
capture la var _Ixsmoke_1 "Current Smoker"
capture la var _Ixsmoke_2 "Former Smoker"
capture la var _Imarital_2 "Div/Sep" 
capture la var _Imarital_3 "Widow" 
capture la var _Imarital_4 "Never Married" 
capture la var _Iracehisp_1 "Hispanic"
capture la var _Iracehisp_3 "NH Black" 
capture la var _Iracehisp_4 "NH Other"
capture la var _Ieduc_cat_2 "Hi Sch Grad"                                                                              
capture la var _Ieduc_cat_3 "College Grad"                                                                              
capture la var _Ibmicat_1 "Underweight"
capture la var _Ibmicat_3 "Overweight"
capture la var _Ibmicat_4 "Obese"
capture la var _Ixchronic_2 "1 Condition"
capture la var _Ixchronic_3 "2+ Conditions"

    
	   

capture noisily  xi:svy, subpop(if age_p>=35 & age_p <=54): stcox i.sex i.xspd2 i.xsmoke i.marital ///
                                   i.racehisp i.educ_cat i.bmicat i.xchronic,   nolog
capture la var _Isex_2 "Female"	
capture la var _Ixspd2_1 "Serious Psy Distress"
capture la var _Ixsmoke_1 "Current Smoker"
capture la var _Ixsmoke_2 "Former Smoker"
capture la var _Imarital_2 "Div/Sep" 
capture la var _Imarital_3 "Widow" 
capture la var _Imarital_4 "Never Married" 
capture la var _Iracehisp_1 "Hispanic"
capture la var _Iracehisp_3 "NH Black" 
capture la var _Iracehisp_4 "NH Other"
capture la var _Ieduc_cat_2 "Hi Sch Grad"                                                                              
capture la var _Ieduc_cat_3 "College Grad"                                                                              
capture la var _Ibmicat_1 "Underweight"
capture la var _Ibmicat_3 "Overweight"
capture la var _Ibmicat_4 "Obese"
capture la var _Ixchronic_2 "1 Condition"
capture la var _Ixchronic_3 "2+ Conditions"

est store m3554 
est table m3554, label  b(%5.2f)  star (.05 .01 .001) stats (N) eform
 
								   

 
foreach spop of varlist a_age1844  a_age4554 a_age5564 a_age6574 a_age75p  {
 capture noisily  xi:svy, subpop(`spop'): stcox i.sex i.xspd2 i.xsmoke i.marital ///
                                   i.racehisp i.educ_cat i.bmicat i.xchronic,   nolog
capture la var _Isex_2 "Female"	
capture la var _Ixspd2_1 "Serious Psy Distress"
capture la var _Ixsmoke_1 "Current Smoker"
capture la var _Ixsmoke_2 "Former Smoker"
capture la var _Imarital_2 "Div/Sep" 
capture la var _Imarital_3 "Widow" 
capture la var _Imarital_4 "Never Married" 
capture la var _Iracehisp_1 "Hispanic"
capture la var _Iracehisp_3 "NH Black" 
capture la var _Iracehisp_4 "NH Other"
capture la var _Ieduc_cat_2 "Hi Sch Grad"                                                                              
capture la var _Ieduc_cat_3 "College Grad"                                                                              
capture la var _Ibmicat_1 "Underweight"
capture la var _Ibmicat_3 "Overweight"
capture la var _Ibmicat_4 "Obese"
capture la var _Ixchronic_2 "1 Condition"
capture la var _Ixchronic_3 "2+ Conditions"

est store `spop' 
}

est table a_age1844  a_age4554 a_age5564 a_age6574 a_age75p, label  b(%5.2f)  star (.05 .01 .001) stats (N) eform    
								   

capture noisily: svy: stcox  i.sex ib2.xspd2 ib3.xsmoke i.marital ///
                                   ib2.racehisp i.educ_cat ib2.bmicat i.xchronic , nolog

capture noisily: svy: stcox  i.sex ib2.xspd2 ib3.xsmoke i.marital ///
                                   ib2.racehisp i.educ_cat ib2.bmicat i.xchronic , nolog
estimates store m1	
ereturn list
						   
//matrix list model1844	
//stcurve, hazard 
stcurve, hazard at1(xspd2=1) at2(xspd2=2) range (18, 95) 

stcurve, hazard at1(xsmoke=1) at2(xsmoke=2) at3(xsmoke=3) range (18, 95)
stcurve, hazard at1(xspd2=1 xsmoke=1) at2(xspd2=2 xsmoke=1) range (18, 95)
stcurve, cumhaz at1(xspd2=1) at2(xspd2=2) range (18, 95)
stcurve, cumhaz at1(yr00_04=1) at2(yr00_04=2) range (18, 95)
stcurve, surv at1(xspd2=1) at2(xspd2=2)  range (18, 95)

stcurve, surv at1(xspd2=1 xsmoke=3) at2(xspd2=2 xsmoke=3) range (18, 95) outfile ("G:\spd_no_spd_surv") 

stcurve, surv at1(sex=1 xspd2=1 xsmoke=3) at2(sex=1 xspd2=2 xsmoke=3) range (18, 95) 
stcurve, surv at1(sex=2 xspd2=1 xsmoke=3) at2(sex=2 xspd2=2 xsmoke=3) range (18, 95) 

stcurve, surv at1(sex=2 xspd2=1 xsmoke=1) at2(sex=2 xspd2=2 xsmoke=1) range (18, 95) 

stcurve, surv at1(sex=1 xsmoke=1) at2(sex=1 xsmoke=3) range (18, 95)

//use "G:\spd_no_spd_surv.dta"
//describe spd_no_spd_surv

// calculate the baseline cumh from the model for all covariates =0
predict ch_no_spd, basechazard 
summarize ch_no_spd, meanonly
scalar ch_no_spd_m = r(mean)
scalar list 

// calculate the cumulative hazard for indivuuals WITH SPD (i.e., XSPD2=1)
matrix b = e(b)
matrix list b
scalar xspd2_hr = exp(b[1,3])
local ch_spd = ch_no_spd_m*xspd2_hr
display ch_spd 




//display 1/(5*-ln(ch_no_spd))
//display 1/(5*-ln(ch_spd))

codebook _all
count if age_p == 60 & xspd2==1 & mortstat==1


log close cox       

