###########################################################
## Opening the black box of an NTD mathematical model
## Martin Walker & Aditya Ramani
##########################################################
rm(list=ls())

###########################################################
## Installing and loading R packages
##########################################################
#install.packages("deSolve")
library(deSolve)

###########################################################
## Load R scripts
##########################################################
source("funcs.R")
source("par.R")

###########################################################
## run model with default parameters to equilibrium
##########################################################
equib <- runmod(init=1, par=par)

###########################################################
## plot outputs
##########################################################
par(mfrow=c(2,2))
plot(W~time, data=equib, type="l", lwd=2)
plot(E~time, data=equib, type="l", lwd=2)
plot(p~time, data=equib, type="l", lwd=2)
plot(Re~time, data=equib, type="l", lwd=2)

par["dotx"] <- 1
par["stop.t"] <- 10
par["freq.tx"] <- 0.5
par["n.tx"] <- 10

interv_bi <- runmod(init = equib[nrow(equib),"W"], par)

par["freq.tx"] <- 1
par["n.tx"] <- 5

interv_an <- runmod(init = equib[nrow(equib),"W"], par)


png(filename="MDA.png", width=8, height=8, unit="in", res=500)
par(mfrow=c(2,2))
plot(W~time, data=interv_bi, ylab="Mean number schistosomes per host", xlab="Years", type="l", lwd=2)
lines(W~time, data=interv_an, lwd=2, lty="dashed")
plot(E~time, data=interv_bi, ylab="Mean egg output per host", xlab="Years", type="l", lwd=2)
lines(E~time, data=interv_an, lwd=2, lty="dashed")
plot(I(100*p)~time, ylab="Prevalence", data=interv_bi, type="l",xlab="Years", lwd=2, ylim=c(0,100))
lines(I(100*p)~time, data=interv_an, lwd=2, lty="dashed")
plot(Re~time, data=interv_bi, ylab="Effective reproduction number", xlab="Years", type="l", lwd=2)
lines(Re~time, data=interv_an, lwd=2, lty="dashed")
dev.off()
