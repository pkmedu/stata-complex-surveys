label define f_age_lab 1 "18-34" 2 "35-44 Yrs" 3 "45-54 Yrs" ///	
               4 "55-64 Yrs"  5 "65-74 Yrs"	6 "75-84 Yrs" 7 "85+ Yrs"
label values f_age_grp f_age_lab


label define aa_age_lab 1 "35-49 Yrs"  2 "50-64 Yrs" 3 "65-74 Yrs" 
label values aa_age_grp aa_age_lab

label define x_age_lab 1 "35-44 Yrs" 2 "45-54 Yrs" 	3 "55-64 Yrs"  4 "65-74 Yrs"	
label values x_age_grp x_age_lab

label define alcstat_lab  ///
	        1 "Lifetime Abstainer:<12 life"    /// 
	        2 "Former infrequent: <12 1yr"   ///
			3  "Former regular: >=12 1 yr"  ///
	        4  "Former, frequency unknown"   ///
			5  "Current infrequent: <12 pst yr"  /// 
			6  "Current Light: <=3/wk"  ///
            7  "Current Moderate: F>3-7wk/M>3-14wk" /// 
			8 "Current Heavy: F>7wk/M>14wk"  ///  
			9 "Current, frequency unknown" ///  
			10 "Drinking status unknown" 
 label values alcstat alcstat_lab

 label define xalcstat_lab   ///
            1 "Lifetime Abstainer:<12 life"  ///
            2 "Former"  ///
            3 "Current infrequent/Light"  ///
            4 "Current Moderate"   ///
	        5 "Current Heavy"  
 label values xalcstat xalcstat_lab

 label define alcstat_r_lab  ///
	        1 "Lifetime Abstainer:<12 life" ///  
	        2 "Former infrequent: <12 1yr"  ///
	        3  "Former regular: >=12 1 yr"  ///
	        5  "Current infrequent: <12 pst yr"  /// 
			6  "Current Light: <=3/wk"  ///
            7  "Current Moderate: F>3-7wk/M>3-14wk" ///  
			8 "Current Heavy: F>7wk/M>14wk"    ///
			99 "Unknown (curr former overall)" 
  label values alcstat_r alcstat_r_lab
	 
  label define alcstat_r2_lab  /// 
	        1 "Lifetime Abstainer:<12 life"  ///
	        2 "Former"  ///
	        5 "Current infrequent: <12 pst yr"  ///
	        6 "Current Light: <=3/wk"  ///
            7 "Current Moderate: F>3-7wk/M>3-14wk" ///  
		    8 "Current Heavy: F>7wk/M>14wk"  /// 
		    99 "Unknown (curr former overall)" 
  label values alcstat_r2 alcstat_r2_lab
   
   
  label define smoke_lab  ///
			1  "Current every day smoker" /// 
			2  "Current some day smoker" ///  
			3  "Former smoker"   ///
			4  "Never smoker"   ///
			5  "Smoker current status unknown"  
   label values smoke smoke_lab
	
   label define cigsmoke_lab   ///
	        1 "Never"   ///
	        2 "Current <1 pack/d"   /// 
	        3 "Current 1+ packs/d"  /// 
	        4 "Current CIGSDAY unk" /// 
            5 "FQ_0–4 yrs ago"  ///
	        6 "FQ_5–9 yrs ago"  ///
			7 "FQ_10–19 yrs ago"  /// 
            8 "FQ_20–29 yrs ago"  ///
			9 "FQ_30+ yrs ago"  ///
			10 "For SMKQTY unk"  ///
			99 "Unk"
	label values  cigsmoke cigsmoke_lab

	label define cigsmoke_r_lab  ///
	        1 "Never"   ///
	        2 "Curr <1 pack/d"   ///
	        3 "Curr 1+ packs/d"  ///
			5 "FQ_0–4 yrs ago"  ///
	        6 "FQ_5–9 yrs ago"  ///
			7 "FQ_10–19 yrs ago" ///  
            8 "FQ_20–29 yrs ago"  ///
			9 "FQ_30+ yrs ago" ///
            99 "Unknown (curr former oveall)"
     label values  cigsmoke_r cigsmoke_r_lab
	 
	 label define cigsmoke_r2_lab   ///
			1 "Never"  ///
	        2 "Curr <1 pack/d"   /// 
	        3 "Curr 1+ packs/d"   /// 
            4 "Former"  /// 
			99 "Unknown (curr oveall)"
     label values  cigsmoke_r2 cigsmoke_r2_lab
	 
	 label define cigsmoke_r2x_lab ///  
			1 "Never"  ///
	        2 "Curr <1 pack/d" ///   
	        3 "Curr 1+ packs/d"  ///  
            4 "Former"  
	 label values  xcigsmoke cigsmoke_r2x_lab
	 
	      label define pa08_3r_lab   ///
			1 "Inactive (No Activity)"  /// 
	        2 "Insufficiently Aactive (<150 Min/Wk)" /// 
	        3 "Sufficiently Active (150+ Min/Wk)" ///   
			9 "Unknown"
     label values pa08_3r pa08_3r_r pa08_3r_lab

     label define pa08_4r_lab  ///
	        1 "Inactive (None)"  ///	 	 
	        2 "Insufficiently Active (<150 Min/Wk)"   ///
	        3 "Sufficiently Active (150<=Min/Wk<=300)"  /// 
	        4 "Highly Active (>300 Min/Wk)"  ///
			9 "Unknown"
     label values pa08_4r pa08_4r_r pa08_4r_lab
	 
	 
label define alcwkfrq_lab  ///
           0 "Not Current Drinker"  ///
           1 "Infrequent/light <=3/wk"  ///
           2 "Moderate: F>3–7wk/M>3–14wk" /// 
           3 "Heavier: F>7wk/M>14wk"  ///
           8 "Current, frequency unk"  ///
           9 "Drinking status unknown"
label value alcwkfrq alcwkfrq_lab

  
label define heavydrk_lab  ///
          1 "Never"  ///
          2 "1-2 days"  ///
          3 "3-11 days"  ///
          4 "12-51 days"  ///
          5 "52+ days"  ///
          9 "Unknown"
label value heavydrk heavydrk_lab
	 
	 
	 label define  chronic_lab ///
	      0 "None" ///
		  1 " 1 Condition" ///
		  2 "2+ Conditions" ///
		  9 "Unknown"
     label values  chronic  chronic_r chronic_lab
 
     label define  chronic1p_lab ///
	      1 " 1+ Condition" ///
		  2 "None" ///
		  9 "Unknown"
     label values  chronic1p chronic1p_r chronic1p_lab
	 	  
	 label define xspd2_lab ///
	      1 "SPD" ///
		  2 "NoSPD"
     label values xspd2 xspd2_lab

	 label define sex_lab ///
	      1 "Male" ///
		  2 "Female"
     label values sex sex_lab
	 
	 
	 label define marital_lab ///
	      1 "Married" ///
		  2 "Div/Sep" ///
		  3 "Widow" ///
		  4 "Never Married" ///	
		  9 "Unknown"
     label values marital marital_r marital_lab
	 
	 label define racehisp_lab ///
	      1 "Hispanic" ///
		  2 "NH White" ///
		  3 "NH Black" ///
		  4 "NH Other"
     label values racehisp racehisp_lab
	
	 label define educ_cat_lab ///
	      1 "Below Hi Sch" ///
		  2 "High Scool Grad." ///
		  3 "College Grad/Higher" 	///
		  9 "Unknown"
     label values educ_cat educ_cat_r educ_cat_lab
	 
		
	label define poverty_lab  ///
	      1  "<100%"   ///
	      2  "100-199%"  ///
		  3  "200-399%"  ///
		  4  "400%+"  ///
		  9  "Unknown"
	  label values poverty poverty_r poverty_lab 
	
	 label define cig_dis_lab ///
	      1 "Lung Diseases" ///
		  2 "Major CVD" ///
		  3 "Pulmonary Diseases" ///
		  4 "Other Causes" 
   label values cig_dis cig_dis_lab
	 
  label define cig_dis3_lab ///
	      1 "Lung/Pulmonary Dis" ///
		  2 "Major CVD" ///
		  3 "Other Causes" 
   label values cig_dis3 cig_dis3_lab
	 
  label define cig_dis2_lab ///
	      1 "Lung/Pulmonary/CVD" ///
		  2 "Other Causes" 
   label values cig_dis2 cig_dis2_lab
	 	 