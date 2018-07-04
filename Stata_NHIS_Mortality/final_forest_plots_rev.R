#test_forest_plot.R
setwd("H:/Stata_mortality")
library(ggplot2)
loadedNamespaces()
load("forest_plot_data.rdata")

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
                                       "Smoke cigarette <1 pack (M2)",
                                       "Smoke cigarette <1 pack (M1)",
                                       "Smoke cigarette 1+ pack (M2)" ,
                                       "Smoke cigarette 1+ pack (M1)" , 
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

p <- ggplot(data, aes(x=xcovariate_f, y=or, ymin=lc, ymax=uc))+
  geom_pointrange(size = 0.8)+
  geom_hline(aes(x=0), lty=2) +
  geom_text(y = 0.2, aes(label= string.est,
                         x = as.numeric(data$xcovariate) - 0.5),
            size = 2.5, hjust = 0, colour="black")+
  facet_wrap(~ age_cat_f)+
  coord_flip()+
  xlab ("Hazard ratio (95% CI)")+
  ylab("  ")+
  theme_bw() +
  theme(panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        strip.background = element_rect(colour="black",
                                        fill='white')
  )

###################
# p <- ggplot(data, aes(x=xcovariate_f, or,y=or, ymin=lc, ymax=uc))+
#                   geom_pointrange()+
#                   geom_hline(aes(x=0), lty=2) +
#                   facet_wrap(~ age_cat_f)+
#                   coord_flip()+ 
#                   xlab ("Predictors")+
#                   ylab("Hazard Ratio")+
#                   theme_bw() +
#                   theme(panel.grid.major=element_blank(),panel.grid.minor=element_blank())+
#                   theme(strip.text.x=element_text(),
#                   strip.background = element_rect(colour="black", fill='white') 
#              ) +

#geom_text(aes(label=string.est,y=uc),hjust=-0.02,colour="black",size=3)+
# scale_y_continuous(limits=c(0,4.25))

#geom_text(aes(label=string.est,y=max(uc)+0.1),hjust=-0.02,colour="black",size=3)+
#scale_y_continuous(limits=c(0,4.25))

 print(p)
ggsave(file='H:/forest_plots_final.png', width=11, height=8.5)

  