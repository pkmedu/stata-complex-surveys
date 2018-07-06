** Exercise 1, SAMHSA training
** Author: Stas Kolenikov
** Date: Feb 25, 2014

version 13.1

* clear the memory
clear

* capture supresses the error messages
* I might expect an error if a log file is already opened
capture log close

* open a log file
* * replace option specifies that the log file 
* * will be created anew each time this do-file is run
log using exer1, replace

* get NHANES2 data file from Stata website
use data\nhanes2
* bird-eye view of the data set
describe
* more detailed look at specific variables
codebook sex region highbp ///
	bp* t*result

* close the log
log close

* all done
exit



