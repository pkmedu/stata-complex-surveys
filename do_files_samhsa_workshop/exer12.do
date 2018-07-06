** Exercise 12, SAMHSA training
** Author: Stas Kolenikov
** Date: Feb 26, 2014

version 13.1

cap log close
log using exer12, replace

* (i) NHANES2 with PSU and strata
use data/nhanes2, clear
forvalues k=1/3 {
	svy, subpop(if race==`k') : total diabetes 
	est title : Lin'z'd, if race==`k'
	est store td_sp_lin_r`k'
	svy : total diabetes if race==`k'
	est title : Lin'z'd, subpop(race==`k')
	est store td_if_lin_r`k'
}

* (ii) with jackknife
use data/nhanes2jknife, clear
forvalues k=1/3 {
	svy jackknife, subpop(if race==`k') : total diabetes 
	est title : Jknife, if race==`k'
	est store td_sp_jkn_r`k'
	svy jackknife : total diabetes if race==`k'
	est title : Jknife, subpop(race==`k')
	est store td_if_jkn_r`k'
}


* (iii) NHANES2 with BRR weights
use data/nhanes2brr, clear
forvalues k=1/3 {
	svy, subpop(if race==`k') : total diabetes
	est title : BRR, if race==`k'
	est store td_sp_brr_r`k'
	svy : total diabetes if race==`k'
	est title : BRR, subpop(race==`k')
	est store td_if_brr_r`k'
}

* (iv) compare and contrast
forvalues k=1/3 {
	display "{txt}Race = {res}`k'"
	est tab td_*_r`k', se stat(N N_sub N_pop N_strata_omit singleton N_reps)
}

log close

exit

