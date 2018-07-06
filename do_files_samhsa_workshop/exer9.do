** Exercise 9, SAMHSA training
** Author: Stas Kolenikov
** Date: Feb 26, 2014

version 13.1

cap log close
log using exer9

local model highbp height weight c.age##c.age i.female i.race

clear

* (i) NHANES2 data with PSU and strata
use data/nhanes2, clear

svy : total diabetes
est store total_diabetes_taylor

svy: logistic `model'
est store logit_highbp_taylor

* (ii) NHANES2 data with BRR weights
use data/nhanes2brr, clear

svy : total diabetes
est store total_diabetes_brr

svy: logistic `model'
est store logit_highbp_brr

* (iii) NHANES2 data with jackknife weights
use data/nhanes2jknife, clear

svy : total diabetes
est store total_diabetes_jknife

svy: logistic `model'
est store logit_highbp_jknife

* (iv) compare and contrast
est tab total_diabetes_*, se modelwidth(20) 
est tab logit_highbp_*, se modelwidth(20) eform

log close

exit
