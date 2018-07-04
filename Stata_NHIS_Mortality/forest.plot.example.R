


library(ggplot2)
loadedNamespaces()


cohort <- letters[1:15]
population <- c(  runif(15, min=2000, max=50000)) #hit1$N
beta <-  c(  runif(15, min=-1, max=2))
lower95 <- c(runif(15, min=-1.5, max=0.5))
upper95 <- c(runif(15, min=1.5, max=2.5))
type <- c("CBCL","SDQ","CBCL","SDQ","CBCL","SDQ","CBCL", "CBCL","SDQ","CBCL","SDQ","CBCL","SDQ","CBCL", "CBCL")
data <- as.data.frame(cbind(cohort, population, beta ,lower95,upper95,type))
data


ggplot(data=data, aes(x=cohort, y=beta))+
  geom_errorbar(aes(ymin=lower95, ymax=upper95), width=.667) +
  geom_point(aes(size=population, fill=type), colour="black",shape=21)+
  geom_hline(yintercept=0, linetype="dashed")+
  scale_x_discrete(name="Cohort")+
  coord_flip()+
  scale_shape(solid=FALSE)+
  scale_fill_manual(values=c( "CBCL"="white", "SDQ"="black"))+
  labs(title="Forest Plot") +
  theme_bw()

ggplot(data=data,aes(x=beta,y=cohort))+
  geom_point(aes(size=population,color=type),shape=16)+
  geom_errorbarh(aes(xmin=lower95,xmax=upper95),height=0.0, colour="blue")+
  geom_vline(xintercept=0,linetype="dashed")+
  scale_size_discrete(breaks=c(5000,10000,15000))+
  geom_text(aes(x=2.8,label=type),size=4)+
  theme_bw()