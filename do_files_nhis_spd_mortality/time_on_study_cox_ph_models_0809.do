
capture log close cox_heroin
//F:\Heroin2014\k_m_stata_NMPR.do
clear
set more off
set linesize 255
use "F:\Heroin2014\km_sr30.dta"
describe
compress
log using "F:\Heroin2014\km.log", name (cox_heroin) replace

gen id_x= _n

summarize verep adjwt11 adjwt11 d_enter d_exit herflag if cohort==1, detail

svyset verep [pweight=adjwt11], strata (vestr) vce(linearized) singleunit(missing)

// age at the time scale
stset d_exit [pweight=adjwt11], failure(herflag)  id(id_x) scale(365.25) origin(brthdate) enter(d_enter)  
capture noisily  svy, subpop(if cohort==1): stcox i.irsex,   nolog
estimates store m1	
stcurve, hazard at1(irsex=1) at2(irsex=2) range (12, 60) outfile ("F:\Heroin2014\nmpr_surv2") 
stcoxkm, by(irsex)

// time to initiation at the time scale
stset d_exit [pweight=adjwt11], failure(herflag==1)  id(id_x) scale(365.25) origin(d_enter) exit(time d_enter+6*365.25) 
capture noisily  svy, subpop(if cohort==1): stcox i.irsex,   nolog
estimates store m1	
stcurve, hazard at1(irsex=1) at2(irsex=2) range (12, 60) outfile ("F:\Heroin2014\nmpr_surv3") 
stcoxkm, by(irsex)

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

