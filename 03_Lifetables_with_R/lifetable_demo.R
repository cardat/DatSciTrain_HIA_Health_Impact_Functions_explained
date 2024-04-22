
## title: "The life tables 'Chiang method (II)' for subnational life expectancy at birth results"
## author: "Ivan Hanigan, Richard Broome and Josh Horsley"
library(data.table)
library(devtools)
install_github("richardbroome2002/iomlifetR", build_vignettes = TRUE)
library(iomlifetR)

## Using an abridged set of population and mortality data:
dat <- read.csv("03_Lifetables_with_R/lifetabletemplat_demo_R.csv")
str(dat)

## Set up scenario: use HRAPIE recommended CRF 
rr_use <- data.frame(est_type = c("RRper10", "RRper10_lci", "RRper10_uci"),
                     est = c(1.062, 1.040, 1.083))
rr_use
## estimate for change in exposure of
deltaX = 3

## Create demog data
demog_data = data.frame(age = dat$start_age,
                            population = dat$pop,
                            deaths = dat$death)
demog_data

## Calculate for RR and 95CIs
for(est_type in rr_use$est_type){
    ##
    rr <- rr_use[rr_use$est_type == est_type, "est"]
    print(est_type)
    
## Calculate life table
le = burden_le(demog_data,
               pm_concentration = deltaX,
               RR = rr)
## le

## Calculate yll from lifetable
impacted_le <- le[["impacted"]][, "ex"]
## impacted_le

an <- burden_an(demog_data,
                pm_concentration = deltaX,
                RR = rr)
yll <- burden_yll(an, impacted_le)

## results in a data frame
burden <- data.frame(x_attrib = an, population = demog_data$population, le, an, yll)
    ##
burden$est_type <- est_type

if(est_type == "RRper10"){
    burden_out <- burden
} else {
    burden_out <- rbind(burden_out, burden)
}
}

##burden_out
setDT(burden_out)    
burden_out[,sum(yll), by = est_type]
## years of life lost in scenario A
"
      est_type       V1
1:     RRper10 566.8479
2: RRper10_lci 369.4309
3: RRper10_uci 751.6683
"
##burden_out[1,]
ledif <- data.frame(
    impacted_le = burden_out[baseline.age == 0, impacted.ex],
    baseline_le = burden_out[baseline.age == 0, baseline.ex]
    )
(ledif[,1] - ledif[,2]) * 365
## days of life gained by birth cohort in scenario B
"
71.12587
lower 46.33968
upper 94.34513
"
