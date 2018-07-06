** Exercise 4, SAMHSA training
** Author: Stas Kolenikov
** Date: Feb 25, 2014

version 13.1

cap log close
log using exer4, replace

sysuse auto, clear

* (ii) basic regression
reg mpg length weight i.rep78 foreign
rvpplot weight , yline(0)
est store regress_basic

* (iii) cluster on manufacturer
list make in 1/20
help word()
gen manuf = word(make, 1)
list make manuf in 1/20
tab manuf foreign
reg mpg length weight i.rep78 foreign, clus( manuf )
est store reg_manuf
encode manuf, gen(manuf1)
tab manuf1

* (iv) some sort of probability weight
reg mpg length weight i.rep78 foreign [pw=price]
est store reg_price

* (v) summary of models
est tab reg*, se stat(r2)

* (vi) test repair record in all specifications
est for reg* : testparm i.rep78

log close
exit

