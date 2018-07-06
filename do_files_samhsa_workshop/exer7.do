** Exercise 7, SAMHSA training
** Author: Stas Kolenikov
** Date: Feb 26, 2014

version 13.1

cap log close
log using exer7, replace

* (o) data
use data/poststrata, clear

* (i) design with poststratification
svyset [pw=weight], poststrata(type) postweight(postwgt)

* (ii) total expenses
svy : total totexp
estimates store totexp_pstrat
estimates save  totexp_pstrat, replace

* (iii) design without poststratification
svyset [pw=weight]
svy : total totexp
estimates store totexp_srs
estimates save totexp_srs, replace


* (iv) compare results
estimates tab totexp*, se
estimates for totexp* : estat cv
cap noi estimates for totexp* : estat effect


log close
exit
