#forest_plots_mort1_rev1.R
setwd("E:/Stata_mortality")
library(dplyr)
library(ggplot2)
loadedNamespaces()
load("forest_plot_data.rdata")
data <- forest_plot_data


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

data$model_f <- factor(data$model,
                  levels = c("indiv", "final"),
                  labels = c("(M1)", "(M2)")
                  )
#data$model_f <- factor (data$model_f, levels = rev(levels(data$model)))

data$age_cat_f <- factor(data$age_cat,
                         levels = c("35_49", "50_69", "70_84"),      
                         labels = c("Ages 35-49","Ages 50-69", "Ages 70-84")
                        ) 

data$xcovariate_f <- paste(data$covariate_f, data$model_f, sep=" ")

data$xcovariate_f <- factor(data$xcovariate_f,
                            levels=c(                                                                                             
                              "Former drinker (M2)",
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
                            )                                                )
                            )
data$string.est <- paste(sprintf('%.2f',data$or), " (", 
                         sprintf('%.2f',data$lc), ",", 
                         sprintf('%.2f',data$uc),")", sep="" ) 
data

#data$xcovariate_f <-reorder(data$model c(data$or, data$lc, data$uc), FUN=mean )  
#subset to model category "indiv"
#data_indiv <- data[data$model=='indiv',]; 

 p <- ggplot(data, aes(x=xcovariate_f, or,y=or, ymin=lc, ymax=uc))+
                   geom_pointrange()+
                   geom_hline(aes(x=0), lty=2) +
                   geom_text( aes (label= string.est)),
                   hjust = .5, colour="black",face="bold")+
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
  
 ggsave(file='H:/forest_plots_indiv.png', width=11, height=7) 