** Exercise 16, follow-up to SAMHSA training
** Author: Stas Kolenikov
** Date: March 3, 2014

version 13.1

cap log close
log using exer16, replace

* (i) CPS 2011 March supplement data
use data/cps.march.2011/cps2011all.dta , clear
svyset [pw=wtsupp] , vce(sdr) sdrw(repwtp1-repwtp160)

* (i.a) recode income
mvdecode inc* , mv( 99999 999999 = .v)
generate lincwage = ln(incwage+0.01)

* (i.b) recode education into meaningfully named dummy variables
generate byte _educ_less_hi = inrange(educ,1,71) if !mi(educ)
generate byte _educ_some_co = inrange(educ,80,110) | inrange(educ,120,122)  if !mi(educ)
generate byte _educ_college = educ == 111  if !mi(educ)
generate byte _educ_grad_pr = inrange(educ,123,125)   if !mi(educ)

* (i.c) recode race into meaningfully named dummy variables
assert !mi(race)
generate byte _race_black = race==200
generate byte _race_asian = inlist(race,650,651)
generate byte _race_other = !missing(race) - (race==100) - _race_black - _race_asian

* (i.d) regression of interest
svy , subpop( if age>=18 & age <= 99 ): regress lincwage _educ_* _race_* c.age##c.age
estimates store cps2011_svy_reg

* (ii) test whether the weight matters
* (ii.a) aux variables
foreach x of varlist _educ_* _race_* {
	generate double wt`x' = wtsupp*`x'
}

* (ii.b) OLS regression
regress lincwage _educ_* _race_* c.wtsupp##(_educ_* _race_* c.age##c.age) if age>=18 & age <= 99
estimates store cps2011_ols_reg_long

* (ii.c) design regression
svy, subpop( if age>=18 & age <= 99 ) : ///
	regress lincwage _educ_* _race_* c.wtsupp##(_educ_* _race_* c.age##c.age)
estimates store cps2011_svy_reg_long

* (ii.d) comparison
estimates tab cps2011*reg, se
estimates for cps2011_*_reg_long: testparm wtsupp* c.wtsupp#(_educ_* _race_* c.age##c.age)

* (iii) extra credit: regression diagnostics
estimates restore cps2011_svy_reg
predict _res, res
predict _yhat, xb

generate wtres  = _res*sqrt(wtsupp)
generate wtres2 = _res*_res*wtsupp

* residuals vs. fitted values, a random subset of data:
scatter wtres _yhat [aw=sqrt(wtsupp)] if uniform()<0.1 , msize(0.4) yline(0) m(Oh) name( cps2011rvfplot, replace)
twoway (scatter _res wtsupp [aw=sqrt(wtsupp)] if uniform()<0.1 , msize(0.4) yline(0, lp(dash)) m(Oh)) ///
	(lowess _res wtsupp if uniform()<0.1 ) , name( cps2011rvwplot, replace)
* combine several plots on the same graph
twoway (scatter wtres2 _yhat [aw=sqrt(wtsupp)] if uniform()<0.1 , msize(0.4) m(Oh) ) ///
	(lowess wtres2 _yhat if uniform()<0.1), name( cps2011r2vfplot, replace)
* NOTE THAT THE PLOTS DO NOT ALLOW pweights, SO I HAD TO SPECIFY aweights INSTEAD
	
log close
