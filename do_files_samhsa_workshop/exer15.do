** Exercise 15, post SAMHSA training
** Author: Stas Kolenikov
** Date: March 5, 2014

version 13.1

cap log close
log using exer15, replace

* (i) NSDUH: are the same people use different drugs,
* or are drugs being used independently?
use data/nsduh2010/nsduh2010small, clear

svyset VEREP [pw=ANALWT_C] , strata(VESTR)

svy : tab HERYR CRKYR, pearson lr wald llwald noadj
svy : tab HERYR LSDYR, pearson lr wald llwald noadj
svy : tab CRKYR LSDYR, pearson lr wald llwald noadj

* (ii) SCF2007: are millionaires as likely to be upside-down as other people?
* this data set is a by-product of exercise 11
use scf2007merged, clear

generate byte _upside_down = (owedtotal > valuetotal) if owedtotal<.
generate byte _millionaire = (valuetotal-owedtotal)>1e6 if !missing(valuetotal-owedtotal)

svy : tab _upside_down _millionaire , col se pearson lr wald llwald noadj

log close

exit
