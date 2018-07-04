
capture log close cox
//E:\SASDATAMH\mh_model.do
clear
clear matrix
set mem 300m
set more off
set linesize 255
use "E:\SASDATAMH\forstata.dta"
describe
compress
log using "E:\SASDATAMH\content.log", name (cox) replace

gen xdthdate=.
replace xdthdate=dthdate if dthdate >intdate
replace xdthdate=dthdate+45 if dthdate ==intdate

gen dox =.
replace dox=xdthdate if mortstat==1
replace dox=enddate if mortstat==0


//create analysis time in years - time from interview to death or censoring
//gen time_yr=0
//replace time_yr = ceil( (interval/365.25) )

//'attained age (years)' = 'time from interview to death or censoring' + 'age at interview' 
//gen xtime_yr=0
//replace xtime_yr = time_yr+age_p


gen xtime_yr = age_p + (ceil ((dox - intdate)/365.25))

gen xtime_yr_grp =0
replace xtime_yr_grp = 1 if xtime_yr >= 18 & xtime_yr <=44
replace xtime_yr_grp = 2 if xtime_yr >= 45 & xtime_yr <=54
replace xtime_yr_grp = 3 if xtime_yr >= 55 & xtime_yr <=64
replace xtime_yr_grp = 4 if xtime_yr >= 65 & xtime_yr <=74
replace xtime_yr_grp = 5 if xtime_yr >= 75

//format intdate dthdate xdthdate enddate dox %d
//list age_p xtime_yr intdate dthdate xdthdate enddate dox if dthdate==intdate
//tab1 xtime_yr xtime_yr_grp

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


gen yr00_04x=2
replace yr00_04x=1 if srvy_yr_n>=2000 & srvy_yr_n<=2004
 
char xspd2 [omit] 2
char xsmoke [omit] 3
char racehisp [omit] 2
char bmicat [omit] 2
char yr00_04x [omit] 2

//stset dox, failure(chd==1) id(id) scale(365.25) origin(doe) exit(time doe + 10*365.25)  
svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(missing)
//stset dox [pweight=wt8], failure(mortstat==1)  id (publicid_2) origin(intdate) enter(intdate) scale(365.25) 
stset dox [pweight=wt8], failure(mortstat==1)  id (publicid_2) origin(dob) enter(intdate) scale(365.25) 


//stphplot, strata(xtime_yr_grp) adjust(sex xspd2 xsmoke marital ///
//                                   racehisp educ_cat bmicat xchronic ///
//								   yr1998 yr1999 yr2000 yr2001 yr2002 yr2003 yr2004) zero
								   
//stphplot, strata(xspd2) adjust(sex xsmoke marital ///
//                                   racehisp educ_cat bmicat xchronic ///
//								   yr1998 yr1999 yr2000 yr2001 yr2002 yr2003 yr2004) zero								   
								   

 
foreach spop of varlist xa1844  xa4554 xa5564 xa6574 xa75p  {
 capture noisily  xi:svy, subpop(`spop'): stcox i.sex i.xspd2 i.xsmoke i.marital ///
                                   i.racehisp i.educ_cat i.bmicat i.xchronic ///
								   yr1998 yr1999 yr2000 yr2001 yr2002 yr2003 yr2004, nolog
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

est table xa1844 xa4554 xa5564 xa6574 xa75p, label  b(%5.2f)  star (.05 .01 .001) eform    
								   
matrix model1844 = e(b)	

capture noisily: svy: stcox i.sex ib2.xspd2 ib3.xsmoke i.marital ///
                                   ib2.racehisp i.educ_cat ib2.bmicat i.xchronic , nolog

//matrix list model1844	
//stcurve, hazard 
stcurve, hazard at1(xspd2=1) at2(xspd2=2) range (18, 95) 
stcurve, hazard at1(xsmoke=1) at2(xsmoke=2) at3(xsmoke=3) range (18, 95)
stcurve, hazard at1(xspd2=1 xsmoke=1) at2(xspd2=2 xsmoke=1) range (18, 95)
stcurve, cumhaz at1(xspd2=1) at2(xspd2=2) range (18, 95)
stcurve, cumhaz at1(yr00_04=1) at2(yr00_04=2) range (18, 95)
stcurve, surv at1(xspd2=1) at2(xspd2=2)  range (18, 95)

stcurve, surv at1(xspd2=1 xsmoke=3) at2(xspd2=2 xsmoke=3) range (18, 95) 

stcurve, surv at1(sex=1 xspd2=1 xsmoke=3) at2(sex=1 xspd2=2 xsmoke=3) range (18, 95) 
stcurve, surv at1(sex=2 xspd2=1 xsmoke=3) at2(sex=2 xspd2=2 xsmoke=3) range (18, 95) 

stcurve, surv at1(sex=2 xspd2=1 xsmoke=1) at2(sex=2 xspd2=2 xsmoke=1) range (18, 95) 

stcurve, surv at1(sex=1 xsmoke=1) at2(sex=1 xsmoke=3) range (18, 95)

// calculate the baseline haz, cumh, surv functions for indivuuals in the ref categories for all covariates including SPD (i.e., no_spd)
predict ch_no_spd, basechazard 
predict s_no_spd, basesurv 
summarize ch_no_spd 
matrix summary=r(mean)
matrix list summary


// calculate the cumulative hazard for indivuuals WITH SPD (i.e., SPD=1)
generate ch_spd1844= summary1844[1,1]*exp(model1844[1,3])
summarize ch_spd1844
matrix summary_ch_spd1844=r(mean)
matrix list summary_ch_spd1844

log close cox       

