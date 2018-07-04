

#delimit;

label define dur_cat_lab 
			  1 "<=1.50 Yrs" 
	          2 "1.75-3.00 Yrs" 
			  3 "3.25-5.00 Yrs" 
              4 "5.25-9.75 Yrs";
label values dur_cat dur_cat_lab;


label define ta_age_grp_lab 
			1 "35-49 Yrs" 
			2 "50-64 Yrs" 
			3 "65-74 Yrs" 
			4= "75+" ;
label values ta_age_grp ta_age_grp_lab;

label define cigsmoke_r2x_lab   
			1 "Never"  
	        2 "Curr <1 pack/d"    
	        3 "Curr 1+ packs/d"    
            4 "Former"  ; 
label values  cigsmoke_r2x cigsmoke_r2x_lab;


