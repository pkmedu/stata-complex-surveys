
capture log close cox
//G:\SASDATAMH\mh_model.do
clear
clear matrix
set mem 300m
set more off
set linesize 255
use "G:\SASDATAMH\forstata.dta"

compress
log using "G:\SASDATAMH\content.log", name (cox) replace


//create analysis time in years - time from interview to death or censoring
gen time_yr=0
replace time_yr = ceil( (interval/365.25) )

//'attained age (years)' = 'time from interview to death or censoring' + 'age at interview' 
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


gen yr00_04=2
replace yr00_04=1 if srvy_yr_n>=2000 & srvy_yr_n<=2004
 

svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(missing)
stset xtime_yr [pweight=wt8], failure(mortstat==1) 

capture noisily: svy, subpop(xa1844): stcox i.sex ib2.xspd2 ib3.xsmoke i.marital ///
                                   ib2.racehisp i.educ_cat ib2.bmicat i.xchronic ///
								   yr1998 yr1999 yr2000 yr2001 yr2002 yr2003 yr2004, nolog

 capture noisily: svy, subpop(xa1844): stcox i.sex ib2.xspd2 ib3.xsmoke i.marital ///
                                   ib2.racehisp i.educ_cat ib2.bmicat i.xchronic ///
								   ib2.yr00_04, nolog
								   
matrix model1844 = e(b)	
//matrix list model1844	
						   
 
stcurve, hazard at1(xspd2=1) at2(xspd2=2) range (18, 45) outfile ("G:\SASDATAMH\haz1844spd", replace)
stcurve, hazard at1(xspd2=1 xsmoke=1) at2(xspd2=2 xsmoke=1) range (18, 45) outfile ("G:\SASDATAMH\haz1844spd_smoke", replace)
stcurve, hazard at1(yr00_04=1) at2(yr00_04=2) range (18, 45) outfile ("G:\SASDATAMH\haz1844year", replace)
stcurve, cumhaz at1(xspd2=1) at2(xspd2=2) range (18, 45) outfile ("G:\SASDATAMH\cumh1844spd", replace)
stcurve, cumhaz at1(yr00_04=1) at2(yr00_04=2) range (18, 45) outfile ("G:\SASDATAMH\cumh1844year", replace)
stcurve, surv at1(xspd2=1) at2(xspd2=2)  range (18, 45) outfile ("G:\SASDATAMH\surv1844spd", replace)

// calculate the baseline haz, cumh, surv functions for indivuuals in the ref categories for all covariates including SPD (i.e., no_spd)
predict ch_no_spd1844, basechazard 
predict s_no_spd1844, basesurv 
summarize ch_no_spd1844 
matrix summary1844=r(mean)
matrix list summary1844


// calculate the cumulative hazard for indivuuals WITH SPD (i.e., SPD=1)
generate ch_spd1844= summary1844[1,1]*exp(model1844[1,3])
summarize ch_spd1844
matrix summary_ch_spd1844=r(mean)
matrix list summary_ch_spd1844

log close cox       

