** Exercise 14, SAMHSA training
** Author: Stas Kolenikov
** Date: Feb 26, 2014

version 13.1

cap log close
log using exer14, replace

use data/nsduh2010/nsduh2010small

* (i.a) recode # of cigarettes smoked into a "continuous" variable
assert inlist(CIG30AV, 1, 2, 3, 4, 5, 6, 7, 91, 93, 94, 97, 98)

recode CIG30AV (1=0.25) (2=1) (3=3.5) (4=10) (5=20) (6=30) (7=50) (91/98=0), ///
	gen( _cig_per_day )
lab var _cig_per_day "CIG30AV recoded to the midpoint of the interval"

hist _cig_per_day

* (i.b) annual usage
gen _cig_per_year = _cig_per_day * cond(CIG30USE<90,CIG30USE,0) * 12

* (i.c) total
svyset VEREP [pw=ANALWT_C] , strata(VESTR)
svy : total _cig_per_year
est store tot_cig_per_year

di %15.0f _b[_cig_per_year]

* (ii) direct total MJ users
recode MJEVER (1=1) (nonmissing=0) , gen( _mjever )
svy : total _mjever
est store tot_mjever

* (iii) ratio estimator of MJ users
* does not account for the errors in the industry figure
svy : ratio _mjever / _cig_per_year
lincom _b[_ratio_1] * 315e9
est store ratio_mjever_cig_per_year

* (iv) which one is better?
estimates for tot_cig_per_year ratio_mjever_cig_per_year: estat effect
estimates for tot_cig_per_year ratio_mjever_cig_per_year: estat cv

log close

exit


