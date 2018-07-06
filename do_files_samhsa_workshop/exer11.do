** Exercise 11, follow-up to SAMHSA training
** Author: Stas Kolenikov
** Date: March 3, 2014

version 13.1

cap log close
log using exer11, replace

* (i) CPS 2011 March supplement data
use data/cps.march.2011/cps2011hh.dta , clear

* (ii) design
lookfor weight
* repwt is actually a weird variable indicating whether the replicate
*   weights are available for a given observation
* the rest of the variables are replicate weights
* Here, I use a rarely used wildcard ? which denotes any single symbol
svyset [pw=hwtsupp], vce(sdr) mse sdrw(repwt? repwt?? repwt???)

* (ii.a) quality control
* Note a minor bug with the replicate weights: 
*  there are only 159 replicate weights in the HH data set
* This was the way data came from the provider (IPUMS)
* To find which weight is missing:
forvalues k=1/160 {
	capture noisily confirm variable repwt`k'
}

* (iii) ate hot lunch
lookfor hot lunch
svy : total atelunch
* this figure is non-sensical:
capture noisily assert _b[atelunch] < 300e6

* (iii.b) try again -- see help for these commands
clonevar _atelunch = atelunch
mvdecode _atelunch , mv(99=.n)
label define atelunch_lbl .n "NIU", modify
* visual check
tab atelunch _atelunch, mi

svy , subpop( if !mi(_atelunch) ) : total _atelunch

* THESE AND SUBSEQUENT NUMBERS DON'T CHECK WITH THOSE IN THE HANDOUT; 
* HOWEVER OLD STAS' CODE REPRODUCES THESE REPORTED NUMBERS
* THUS THE ISSUE MUST BE WITH THE DATA

* (iv) reduced or free lunch
clonevar _frelunch = frelunch
mvdecode _frelunch , mv(99=.n \ 98=.e)
label  define frelunch .n "NIU -- No children in hh" .e "NIU -- Children didn't eat hot lunch"
* visual check
tab frelunch _frelunch, missing

svy, subpop( if !mi(_frelunch) ) : total _frelunch

* (v) proportion of children eligible for reduced or free lunch
* (v.a) ratio command
svy, subpop( if !mi(_frelunch) & !mi(_atelunch) ) : ratio _frelunch/_atelunch

* (v.b) ratio is actually a ratio of totals
svy, subpop( if !mi(_frelunch) & !mi(_atelunch) ) : total _frelunch _atelunch
* nlcom estimates nonlinear combinations of parameters
nlcom _b[_frelunch]/_b[_atelunch]

log close

exit
