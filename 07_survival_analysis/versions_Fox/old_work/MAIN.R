# this was put together by karthik
# TODO: re-write based on versions/appendix-cox.R

if(dir.exists("07_survival_analysis/")) setwd("07_survival_analysis/")
library(survival)
library(carData)
Rossi[1:5, 1:10]

#### load data ####
# Rossi <- read.table("Rossi.txt", header=T)
### Downloaded from ####
# I downloaded this from the following url:
# https://socialsciences.mcmaster.ca/jfox/Books/Companion/downloads.html

#### simple wide cox ph ####
mod.allison <- coxph(Surv(week, arrest) ~ fin + age + race + wexp + mar + paro + prio,
                     data=Rossi)
mod.allison

summary(mod.allison)

plot(survfit(mod.allison), ylim=c(.7, 1), xlab="Weeks",
     ylab="Proportion Not Rearrested")


# attach(Rossi)
# Rossi.fin <- data.frame(fin=c(0,1), age=rep(mean(age),2), race=rep(mean(race),2),
#                         wexp=rep(mean(wexp),2), mar=rep(mean(mar),2), paro=rep(mean(paro),2),
#                         prio=rep(mean(prio),2))
# detach()
# 
# plot(survfit(mod.allison, newdata=Rossi.fin), conf.int=T,
#      lty=c(1,2), ylim=c(.6, 1))
# 
# legend(locator(1), legend=c(’fin = 0’, ’fin = 1’), lty=c(1,2))

Rossi.2 <- matrix(0, 19809, 14) # to hold new data set

colnames(Rossi.2) <- c("start", "stop", "arrest.time", names(Rossi)[1:10], "employed")

row <- 0 # set record counter to 0
for (i in 1:nrow(Rossi)) { # loop over individuals
  for (j in 11:62) { # loop over 52 weeks
    if (is.na(Rossi[i, j])) next # skip missing data
    else {
      row <- row + 1 # increment row counter
      start <- j - 11 # start time (previous week)
      stop <- start + 1 # stop time (current week)
      arrest.time <- if (stop == Rossi[i, 1] && Rossi[i, 2] ==1) 1 else 0
      # construct record:
      Rossi.2[row,] <- c(start, stop, arrest.time, unlist(Rossi[i, c(1:10, j)]))
        }
    }
  }

Rossi.2 <- as.data.frame(Rossi.2)

remove(i, j, row, start, stop, arrest.time) # clean up

# To create the same data set as above using fold, I enter:
source("R/unfold.R")
Rossi.2 <- unfold(Rossi, 
                time= "week",
                event= "arrest", 
                cov=11:62, 
                cov.names= "employed")

#   This command required less than 16 seconds on my computer – still not impressively efficient, but (not
#                                                                                                      counting programming effort) much better than the brute-force approach that I took previously. Here are
# the first 50 of the nearly 20,000 records in the data frame Rossi.2:

Rossi.2$start <- as.numeric(Rossi.2$start)
Rossi.2$stop <- as.numeric(Rossi.2$stop)
Rossi.2$arrest.time <- as.numeric(Rossi.2$arrest.time)


mod.allison.2 <- coxph(Surv(start, stop, arrest.time) ~
                         + fin + age + race + wexp + mar + paro + prio + employed,
                       data=Rossi.2)

summary(mod.allison.2)