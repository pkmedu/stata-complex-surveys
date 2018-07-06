** Exercise 2, SAMHSA training
** Author: Stas Kolenikov
** Date: Feb 25, 2014

version 13.1

clear

capture log close
log using exer2, replace

* (iii) execute another do file
cd "C:\Users\kolenikovs\Desktop\SAMHSA training/data/census2000/"
do usa_00002.do

* (iv)
describe

* (v) save for future use
* optimize the data set for storage
compress

* make it smaller and more manageable: create 1% sample
sample 1

* on your computer, this may have to be
* save "c:\stata training\census2000.dta", replace
save census2000_1pct, replace

* (vi) go back to the home directory
cd "C:\Users\kolenikovs\Desktop\SAMHSA training"

log close
exit
