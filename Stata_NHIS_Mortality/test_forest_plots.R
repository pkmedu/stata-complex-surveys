#test_forest_plot.R
library(ggplot2)
loadedNamespaces()

#read this data set
temp <- "var  age_cat	model	or	lc	uc
1.chronic1p	35_49	indiv	2.69	2.35	3.09
2.xalcstat	35_49	indiv	1.30	1.02	1.66
3.xalcstat	35_49	indiv	0.75	0.61	0.92
4.xalcstat	35_49	indiv	0.69	0.54	0.90
5.xalcstat	35_49	indiv	1.26	0.91	1.74
2.xcigsmoke	35_49	indiv	1.42	1.14	1.76
3.xcigsmoke	35_49	indiv	2.18	1.76	2.69
4.xcigsmoke	35_49	indiv	1.23	0.97	1.56
1.pa08_3r 	35_49	indiv	1.78	1.46	2.18
2.pa08_3r 	35_49	indiv	1.25	0.99	1.59
1.xspd2	    35_49	indiv	2.56	1.99	3.29
1.xspd2	    35_49	final	1.54	1.16	2.05
2.xcigsmoke	35_49	final	1.44	1.15	1.82
3.xcigsmoke	35_49	final	2.00	1.60	2.49
4.xcigsmoke	35_49	final	1.21	0.94	1.56
2.xalcstat	35_49	final	1.08	0.84	1.38
3.xalcstat	35_49	final	0.69	0.56	0.86
4.xalcstat	35_49	final	0.63	0.48	0.83
5.xalcstat	35_49	final	0.94	0.67	1.31
1.pa08_3r	  35_49	final	1.54	1.26	1.89
2.pa08_3r	  35_49	final	1.14	0.90	1.45
1.chronic1p	35_49	final	2.46	2.12	2.84
1.chronic1p	50_69	indiv	2.37	2.17	2.59
2.xalcstat	50_69	indiv	1.45	1.30	1.61
3.xalcstat	50_69	indiv	0.80	0.71	0.90
4.xalcstat	50_69	indiv	0.87	0.75	1.01
5.xalcstat	50_69	indiv	1.56	1.32	1.83
2.xcigsmoke	50_69	indiv	2.15	1.89	2.45
3.xcigsmoke	50_69	indiv	2.64	2.38	2.93
4.xcigsmoke	50_69	indiv	1.43	1.29	1.57
1.pa08_3r	  50_69	indiv	2.09	1.91	2.28
2.pa08_3r	  50_69	indiv	1.42	1.26	1.62
1.xspd2	    50_69	indiv	2.11	1.85	2.40
1.xspd2	    50_69	final	1.44	1.24	1.66
2.xcigsmoke	50_69	final	2.11	1.84	2.42
3.xcigsmoke	50_69	final	2.31	2.08	2.57
4.xcigsmoke	50_69	final	1.33	1.20	1.48
2.xalcstat	50_69	final	1.22	1.09	1.37
3.xalcstat	50_69	final	0.77	0.68	0.87
4.xalcstat	50_69	final	0.81	0.69	0.95
5.xalcstat	50_69	final	1.21	1.02	1.44
1.pa08_3r	  50_69	final	1.81	1.65	1.99
2.pa08_3r	  50_69	final	1.34	1.18	1.53
1.chronic1p	50_69	final	2.20	2.01	2.40
1.chronic1p	70_84	indiv	1.89	1.74	2.05
2.xalcstat	70_84	indiv	1.29	1.20	1.38
3.xalcstat	70_84	indiv	0.82	0.76	0.89
4.xalcstat	70_84	indiv	0.79	0.70	0.88
5.xalcstat	70_84	indiv	1.33	1.14	1.56
2.xcigsmoke	70_84	indiv	2.32	2.08	2.59
3.xcigsmoke	70_84	indiv	2.74	2.47	3.05
4.xcigsmoke	70_84	indiv	1.54	1.45	1.64
1.pa08_3r  	70_84	indiv	2.27	2.11	2.45
2.pa08_3r 	70_84	indiv	1.46	1.33	1.60
1.xspd2	    70_84	indiv	1.97	1.72	2.24
1.xspd2	    70_84	final	1.52	1.33	1.75
2.xcigsmoke	70_84	final	2.33	2.07	2.61
3.xcigsmoke	70_84	final	2.51	2.24	2.82
4.xcigsmoke	70_84	final	1.55	1.45	1.66
2.xalcstat	70_84	final	1.08	1.01	1.17
3.xalcstat	70_84	final	0.78	0.71	0.84
4.xalcstat	70_84	final	0.74	0.66	0.83
5.xalcstat	70_84	final	1.08	0.92	1.27
1.pa08_3r	  70_84	final	2.04	1.88	2.20
2.pa08_3r	  70_84	final	1.41	1.28	1.56
1.chronic1p	70_84	final	1.80	1.66	1.95"

data <- read.table(textConnection(temp), header=TRUE, as.is=TRUE)

#load("forest_plot_data.rdata")

data <- forest_plot_data

# convert to factor
data$age_cat_f <- factor(data$age_cat,
                           levels = c("35_49", "50_69", "70_84"),      
                           labels = c("Ages 35-49","Ages 50-69", "Ages 70-84")
                         ) 
# convert to factor
data$covariate_f <- factor(data$var, 
                             levels = c("1.xspd2", "2.xcigsmoke", "3.xcigsmoke", "4.xcigsmoke",
                                      "2.xalcstat", "3.xalcstat", "4.xalcstat","5.xalcstat",
                                      "1.pa08_3r", "2.pa08_3r", "1.chronic1p" 
                                      ),
                             labels = c("Past-month SPD","Smoke cigrette <1 pack",
                                      "Smoke cigrette 1+ pack", "Former smoker",
                                      "Former drinker", "Light drinker","Moderate drinker",
                                      "Heavy drinker","No activity","Insufficiently active",
                                      "1+ chronic conditions"
                                      ) 
                            )
# convert to factor
data$model_f <- factor(data$model,
                         levels = c("indiv", "final"),
                         labels = c("(M1)", "(M2)")
                       )

# create a character variable
data$xcovariate_f <- paste(data$covariate_f, data$model_f, sep=" ")

# convert to factor
data$xcovariate_f <- factor(data$xcovariate_f,
                              levels=c("Former drinker (M2)",
                                       "Former drinker (M1)",
                                       "Light drinker (M2)",
                                       "Light drinker (M1)",
                                       "Moderate drinker (M2)",
                                       "Moderate drinker (M1)",
                                       "Heavy drinker (M2)",
                                       "Heavy drinker (M1)",
                                       "Insufficiently active (M2)",
                                       "Insufficiently active (M1)" ,
                                       "No activity (M2)",
                                       "No activity (M1)",
                                       "Former smoker (M2)",
                                       "Former smoker (M1)",
                                       "Smoke cigrette <1 pack (M2)",
                                       "Smoke cigrette <1 pack (M1)",
                                       "Smoke cigrette 1+ pack (M2)" ,
                                       "Smoke cigrette 1+ pack (M1)" , 
                                       "1+ chronic conditions (M2)",
                                       "1+ chronic conditions (M1)",
                                       "Past-month SPD (M2)",
                                       "Past-month SPD (M1)"
                                      )               
                            )
# construct a character string with OR, LC, and UC
data$string.est <- paste(sprintf('%.2f',data$or), " (", 
                         sprintf('%.2f',data$lc), ",", 
                         sprintf('%.2f',data$uc),")", sep="" 
                         ) 


 p <- ggplot(data, aes(x=xcovariate_f, or,y=or, ymin=lc, ymax=uc))+
                   geom_pointrange()+
                   geom_hline(aes(x=0), lty=2) +
                   geom_text( aes (label= string.est, y=.4),
                                   hjust = -.2, colour="black")+
                   facet_wrap(~ age_cat_f)+
                   coord_flip()+ 
                   xlab ("  ")+
                   ylab("  ")+
                   theme_bw() +
                   theme(panel.grid.major=element_blank(),panel.grid.minor=element_blank())+
                   theme(strip.text.x=element_text(),
                   strip.background = element_rect(colour="black", fill='white') 
              )
  
  print(p)
  