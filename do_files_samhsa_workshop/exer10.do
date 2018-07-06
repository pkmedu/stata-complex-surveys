** Exercise 10, follow-up to SAMHSA training
** Author: Stas Kolenikov
** Date: March 3, 2014

version 13.1

cap log close
log using exer10, replace

* (i.a) bootstrap weights data
use data\scf2007\scf2007rw, clear
forvalues k=1/999 {
	gen bsw`k' = cond( missing(wt1b`k'), 0, wt1b`k'*mm`k' )
	assert !missing( bsw`k')
}
drop wt1b* mm*

* (i.b) merge with the main data
merge 1:1 peuid using data\scf2007\scf2007small, assert( match )
drop _merge

* (ii) design settings
svyset [pw=wgtmain], vce(bootstrap) mse bsrw( bsw* ) dof(81)

save scf2007merged, replace

* (iii) principal residence
lookfor principal residence
svy : mean valuetotal owedtotal
svy : total valuetotal owedtotal 

* (iv) subgroups of interest
* remember that Stata's missing value is +infinity
* comparisons like "greater than" may erroneously identify cases
*    with missing data as large values
generate byte _upside_down = (owedtotal > valuetotal) if owedtotal<.
generate byte _millionaire = (valuetotal-owedtotal)>1e6 if !missing(valuetotal-owedtotal)

* could do a tab, but this will only require one run through the rep weights
svy : proportion _upside_down _millionaire

log close


exit
