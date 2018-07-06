** Exercise 8, follow-up to SAMHSA training
** Author: Stas Kolenikov
** Date: March 3, 2014

version 13.1

cap log close
log using exer8, replace

* (i) NSDUH extract data and settings
use data/nsduh2010/nsduh2010small, clear
svyset VEREP [pw= ANALWT_C], strata( VESTR )

* (ii.a) backdoor from svy: tab
svy : tab HERYR, se count format(%9.0f)
mat li e(b)
* verify against Stas' results
assert abs(_b[p21] - 632081 ) < 1
assert abs( _se[p21]- 75221 ) < 1

* (ii.b) direct total
recode HERYR (1=1) (nonmissing=0), gen( _used_heroine_past_year )
svy : total _used_heroine_past_year
assert abs(_b[_used_heroine_past_year] - 632081 ) < 1
assert abs( _se[_used_heroine_past_year]- 75221 ) < 1


log close

exit
