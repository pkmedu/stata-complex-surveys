** Exercise 17, follow-up to SAMHSA training
** Author: Stas Kolenikov
** Date: March 3, 2014

version 13.1

cap log close
log using exer17, replace

* (i) NHIS data
use data/nhis.mortality/nhis_linked_mort_stready.dta, clear
keep if smkstat1 <= 3

* svyset
svyset psu [pw=sa_wgt_new] , strata(stratum)

* stset
* time variable is calendar year
* failure is mortstat
* origin is birth year
stset year [pw=sa_wgt_new], id(publicid_2) time0(year0) ///
	origin(time year0) enter( time nhis_year ) exit(time min(2006, dodyear) ) ///
	failure(died==19/26 28/43) 

sts graph, by( smkstat1 )

svy : stcox ib3.smkstat1

* asserting the hazard ratios is somewhat more complicated
* hazard ratio is a nonlinear statistic, 
* so this calls for the corresponding postestimation command
nlcom exp(_b[1.smkstat1])
* nlcom leaves behind r(b) matrix for the estimated statistics
* and r(V) for the estimated variance
return list
assert abs(el(r(b),1,1)-1.6808)<0.0001
assert abs(sqrt(el(r(V),1,1))-0.1208)<0.0001

* (ii) direct test of the proportional hazards assumption
stphplot, by(smkstat1)
stsplit pht, at(60 70 80)
gen byte current_pht = 1.smkstat1 * pht
gen byte former_pht = 2.smkstat1 * pht
svy : stcox ib3.smkstat1 i.current_pht i.former_pht
testparm i.current_pht
testparm i.former_pht

* (iii) transform towards discrete time analysis
stsplit T, every(1)
bysort publicid_2 (year) : gen byte _died_other_cancer = ///
	cond(_n==_N, /// check if the last observation for a given respondent
		(year==year[_N])*((died>=19&died<=26)|(died>=28&died<=43)), /// enumerated causes of death
		0 ) // 0 if not the last record

* (iv) discrete time models are binary data models
* prop hazards
svy: cloglog _died_other_cancer ib3.smkstat1, eform
* prop odds
svy: logit _died_other_cancer ib3.smkstat1, eform

log close

exit
