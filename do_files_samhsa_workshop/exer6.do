** Exercise 6, SAMHSA training
** Author: Stas Kolenikov
** Date: Feb 25, 2014

version 13.1

cap log close
log using exer6, replace

* (i) data
use data/seniors, clear
svyset
* to reproduce
svyset county [pweight= sampwgt], strata(state) fpc(ncounties) ///
	|| school, fpc(nschools) || _n, strata(gender) fpc(nseniors)

* (ii) tab of interest
svy : tab smoked, se
est store seniors_smoked_full

* (iii) PUMS set up: single stage
svyset county [pw=sampwgt], strata(state)
svy : tab smoked, se
est store seniors_smoked_1stage

* (iv) two-stage
svyset county [pweight=sampwgt], strata(state) fpc(ncounties) || school 
svy : tab smoked, se
est store seniors_smoked_2stage

* (v) save 
save myseniors, replace

* (vi) compare tabs
est tab seniors_smoked*, se

log close

exit
