
capture log close freq_082013 
clear
clear matrix
set mem 300m
set more off
set linesize 255
use "E:\SASDATAMH\forstata.dta"
describe
compress
log using "E:\SASDATAMH\content.log", name (freq_082013 ) replace


generate current_smk= xsmoke==1 if !missing(xsmoke)
generate under_wgt= bmicat==2 if !missing(bmicat)
generate overwgt= bmicat==3 if !missing(bmicat)
generate obese= bmicat==4 if !missing(bmicat)

generate div_sep= marital==2 if !missing(marital)
generate widow= marital==3 if !missing(marital)
generate nev_marrd= marital==4 if !missing(marital)
generate had_spd = xspd2==1 if !missing(xspd2)

tab1 overwgt obese div_sep widow nev_marrd 



generate cond_1p =xchronic >=2 if xchronic<.

 tab current_smk xsmoke, missing
 tab under_wgt bmicat, missing
 tab cond_1p xchronic, missing

 
  
  
gen xdthdate=.
replace xdthdate=dthdate if dthdate >intdate
replace xdthdate=dthdate+45 if dthdate ==intdate

drop dox
gen dox=xdthdate if mortstat==1
replace dox=enddate if mortstat==0


//change 'current smoking status unknown' to missing
replace xsmoke =. if xsmoke==4


//convert character into numeric variable
gen srvy_yr_n = real(srvy_yr)

//create 8 dummy variables
foreach x of numlist 1997 1998 1999 2000 2001 2002 2003 2004 {
      gen  yr`x'=0
       replace yr`x'=1 if srvy_yr_n==`x'
      } 
 
 //create factors (nominal variables)
gen yr01_04=2
replace yr01_04=1 if srvy_yr_n>=2001 & srvy_yr_n<=2004

gen byte a_age = ceil((dox - dob)/365.25)

// create a 8-catgory attained age variable
gen a_age_grp=1 if a_age >= 18 & a_age <=24
replace a_age_grp=2 if a_age >=25 & a_age <=34
replace a_age_grp=3 if a_age >=35 & a_age <=44
replace a_age_grp=4 if a_age >=45 & a_age <=54
replace a_age_grp=5 if a_age >=55 & a_age <=64
replace a_age_grp=6 if a_age >=65 & a_age <=74
replace a_age_grp=7 if a_age >=75 & a_age <=84
replace a_age_grp=8 if a_age >=85


//create dummy variables for attained age
gen xa_age1824 = a_age_grp==1
gen xa_age2534 = a_age_grp==2
gen xa_age3544 = a_age_grp==3
gen xa_age4554 = a_age_grp==4
gen xa_age5564 = a_age_grp==5
gen xa_age6574 = a_age_grp==6
gen xa_age7584 = a_age_grp==7
gen xa_age85p = a_age_grp==8



// calculate survival time (quarter-years elapsed) between the imputed date 
// of interview and the imputed date of exit (death or censored) 
gen dur = ceil((dox - intdate)/365.25)
gen dur_q= floor(((year(dox)-year(intdate))*12+month(dox)-month(intdate))/3)
recode dur_q (0=1)
drop dur
tab1 dur_q


// alternative construct: survtime_q

gen  yq_int = qofd(intdate)
gen  yq_dth = qofd(dthdate)
gen  yq_end = qofd(enddate)
gen  yq_dox = qofd(dox)
gen  yq_dob = qofd(dob)

gen survtime_q = yq_dox - yq_int
recode survtime_q (0=1)
tab survtime_q srvy_yr_n
summarize survtime_q, detail
bysort srvy_yr_n: summarize survtime_q


// duration variable (categorical)

gen survtime_y = ceil(survtime_q/4)
tab survtime_y srvy_yr_n


gen dur_cat=1 if survtime_y <=4.00
replace dur_cat=2 if survtime_y>=4.25 & survtime_y<=6.00
replace dur_cat=3 if survtime_y>=6.25 & survtime_y<=8.00
replace dur_cat=4 if survtime_y>=8.25 & survtime_y<=9.75





//create a 6-catgory attained age variable
gen xa_age_grp=. if a_age >= 18 & a_age <=24
replace xa_age_grp=1 if a_age >=25 & a_age <=34
replace xa_age_grp=2 if a_age >=35 & a_age <=44
replace xa_age_grp=3 if a_age >=45 & a_age <=54
replace xa_age_grp=4 if a_age >=55 & a_age <=64
replace xa_age_grp=5 if a_age >=65 & a_age <=74
replace xa_age_grp=6 if a_age >=75 & a_age <=84
replace xa_age_grp=. if a_age >=85
label define  xa_age_grp_v 1 "25-34 Yrs" 2 "35-44 Yrs" ///
           3 "45-54 Yrs" 4 "55-64 Yrs" 5 "65-74 Yrs" 6 "75-84 Yrs" 
     label values xa_age_grp xa_age_grp_v


//create a 3-catgory attained age variable
gen ta_age_grp=. if a_age >= 18 & a_age <=24
replace ta_age_grp=1 if a_age >=25 & a_age <=44
replace ta_age_grp=2 if a_age >=45 & a_age <=64
replace ta_age_grp=3 if a_age >=65 & a_age <=84
replace ta_age_grp=. if a_age >=85
label define  ta_age_grp_v 1 "25-44 Yrs" 2 "45-64 Yrs" 3 "65-84 Yrs" 
     label values ta_age_grp ta_age_grp_v



     label define dur_cat_v 1 "<=4.00 Yrs" 2 "4.25-6.00 Yrs" 3 "6.25-8.00 Yrs" ///
                              4 "8.25-9.75 Yrs"
	 label values dur_cat dur_cat_v

	 label define a_age_grp_v 1 "18-24 Yrs" 2 "25-34 Yrs" 3 "35-44 Yrs" ///
                                4 "45-54 Yrs" 5 "55-64 Yrs" 6 "65-74 Yrs" 7 "75-84 Yrs" 8 "85+ Yrs"
	 label values a_age_grp a_age_grp_v

	 

	 label define xspd2_lab 1 "Serious Psy Distress" 2 "No SPD"
     label values xspd2 xspd2_lab

	 label define sex_lab 1 "Male" 2 "Female"
     label values sex sex_lab
	 
	 label define xsmoke_lab 1 "Current Smoker" 2 "Former Smoker" 3 "Never Smoker"
     label values xsmoke xsmoke_lab
	 
	 label define marital_lab 1 "Married" 2 "Div/Sep" 3 "Widow" 4 "Never Married"
     label values marital marital_lab
	 
	 label define racehisp_lab 1 "Hispanic" 2 "NH White" 3 "NH Black" 4 "NH Other"
     label values racehisp racehisp_lab
	
	 label define educ_cat_lab 1 "Below Hi Sch" 2 "High Scool Grad." 3 "College Grad/Higher"
     label values educ_cat educ_cat_lab
	
	 label define bmicat_lab 1 "Underweight" 2 "Normal" 3 "Overweight" 4 "Obese"
     label values bmicat bmicat_lab
	 
	 label define xchronic 1 "None" 2 "1 Condition" 3 "2+ Conditions"
     label values xchronic xchronic_lab

	 
	 table xa_age_grp xspd2, by(dead) contents(freq)
	 table ta_age_grp xspd2, by(dead) contents(freq)
	 table ta_age_grp xspd2, by(xsmoke dead) contents(freq)
	 
	 table xa_age_grp sex xspd2, by(dead) contents(freq)
	 table ta_age_grp sex xspd2, by(dead) contents(freq)
	 table ta_age_grp sex xspd2, by(xsmoke dead) contents(freq)
	 
	 
	 table xa_age_grp xspd2, by(xspd2) contents(freq)
	 table ta_age_grp xspd2, by(xspd2) contents(freq)
	 table ta_age_grp xspd2, by(xsmoke) contents(freq)
	 
	 
	 count if dead==1 & ta_age_grp==1 & sex==1 & xspd2==1 & xsmoke==1
	 
	 

	/* 
	 
gen yr00_04x=2
replace yr00_04x=1 if srvy_yr_n>=2000 & srvy_yr_n<=2004

tab1 sex  xspd2 xsmoke marital racehisp educ_cat bmicat xchronic a_age_grp, missing
tab dur_q srvy_yr_n, missing

tab1  sex  xspd2 xsmoke marital racehisp educ_cat bmicat xchronic a_age_grp if a_age >=25 & a_age <=84, missing
tab dur_q srvy_yr_n if a_age >=25 & a_age <=84, missing


svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(missing)
 foreach depvar of varlist had_spd current_smk cond_1p under_wgt overwgt obese div_sep widow nev_marrd  mortstat{
   svy, subpop(if a_age>=25 & a_age<=84) percent : tabulate  `depvar' xa_age_grp, col obs ci format(%5.1f) stubwidth(30) 
    }
*/
tab sex
//cond_1p under_wgt overwgt obese div_sep widow nev_marrd
svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(missing)
 foreach depvar of varlist had_spd current_smk {
    foreach x of numlist 0 1 {
   svy, subpop(if a_age>=25 & a_age<=84 & under_wgt =`x') percent:tabulate `depvar' xa_age_grp, row obs ci format(%5.1f) stubwidth(30) 
   }
    }
	
	ereturn list
	
	gen matx = e(b)

svyset psu [pweight=wt8], strata (stratum) vce(linearized) singleunit(missing)
 foreach depvar of varlist had_spd current_smk cond_1p under_wgt overwgt obese div_sep widow nev_marrd  mortstat{
   svy, subpop(if a_age>=25 & a_age<=84 ) percent : tabulate   `depvar' xa_age_grp, row obs ci format(%5.1f) stubwidth(30) 
    }

  
log close freq_082013      

