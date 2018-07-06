** Exercise 3, SAMHSA training
** Author: Stas Kolenikov
** Date: Feb 25, 2014

version 13.1

clear

capture log close
log using exer3, replace

* (i) the data file was created by exer2.do
do "C:\Users\kolenikovs\Desktop\SAMHSA training\Data\Census2000\ReadUScensus2000.do"

* (ii) find the education variable
lookfor educ
lookfor school

* (iii) crude education variable
recode educd (0/1=.n) (2/61=0) (62/116=1), g(hs_or_more)

* (iv) label everything for the new variable
label variable hs_or_more "High school or above"
label define hs_or_more_lbl 0 "Below high school" ///
	1 "High school or above" .n "N/A"
label values hs_or_more hs_or_more_lbl

* (v) cross-tab
tab educd hs_or_more, mi
tab educ hs_or_more, mi

* (vi) done in step (iv)

log close
exit
