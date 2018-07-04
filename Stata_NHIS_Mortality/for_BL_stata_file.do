
capture log close test
//clolog_attained_age_duration.do
clear
clear matrix
set more off
set linesize 255
use "F:\DataRequestToRTI\Policy Vars.dta"
log using "E:\Stata_mortality\test.log", name (test) replace
describe

log close test

