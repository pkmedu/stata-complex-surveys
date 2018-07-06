** Exercise 5, SAMHSA training
** Author: Stas Kolenikov
** Date: Feb 25, 2014

version 13.1

cap log close
log using exer5, replace

* (i) NSDUH
use data/nsduh2010/nsduh2010small, clear

* (ii)-(iii) RTFM
svyset VEREP [pw= ANALWT_C], strata( VESTR )

* (iv) do we have the right design?
svydes
assert r(N_strata) == 60
assert r(N_units) == 2*r(N_strata)

* (v) prop ever smoked
svy: tab CIGEVER, se
matrix list e(b)
display _b[p11]
* this is bound to fail!!!
* capture suppresses the output
* noisily turns it back on
* USE WITH EXTREME CAUTION
capture noisily assert _b[p11] == 0.6425
help round()
display round(_b[p11], 0.0001 )
assert reldif(_b[p11], 0.6425 ) <= 1e-4
assert reldif(_se[p11], 0.0036 ) <= 1e-4
assert _se[p11] < 0.3*_b[p11]

* other QC checks: e(Obs) matrix

log close
exit

