
## title: "The life tables 'Chiang method (II)' for subnational life expectancy at birth results"
## author: "Ivan Hanigan"
## acknowledgements: "Richard Broome, Josh Horsley"
library(data.table)
library(devtools)
install_github("richardbroome2002/iomlifetR", build_vignettes = TRUE)
library(iomlifetR)

## Using an abridged set of population and mortality data:
dat <- read.csv("03_Lifetables_with_R/lifetabletemplat_demo_R.csv")
str(dat)

## Set up scenario: use Chen and Hoek (2020) recommended CRF 
rr_use <- data.frame(est_type = c("RRper10", "RRper10_lci", "RRper10_uci"),
                     est = c(1.08, 1.06, 1.09))
rr_use
## estimate for change in exposure of
deltaX = 3

## Create demog data
demog_data = data.frame(age = dat$start_age,
                            population = dat$pop,
                            deaths = dat$death)
demog_data

## Calculate for RR and 95CIs
# To start with we will run a single case using the point estimate, after you have tested this then uncomment the loop to run the lower and upper convidence limits too
# for(est_type in rr_use$est_type){
    #
    est_type = rr_use$est_type[1]
    rr <- rr_use[rr_use$est_type == est_type, "est"]
    print(est_type)
    
## Calculate life table
le = burden_le(demog_data,
               pm_concentration = deltaX,
               RR = rr)
le

## Calculate yll from lifetable
impacted_le <- le[["impacted"]][, "ex"]
#impacted_le

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
# when you have understood the above steps for the point estimate, uncomment this looping bracket
#}

burden_out[,c("est_type", "impacted.age", "population", "impacted.hazard", "an", "yll")]
setDT(burden_out)    
burden_out[,sum(yll), by = est_type]
## years of life lost in scenario A, or years of life gained in scenario B
##burden_out[1,]
ledif <- data.frame(
    impacted_le = burden_out[baseline.age == 0, impacted.ex],
    baseline_le = burden_out[baseline.age == 0, baseline.ex]
    )
(ledif[,1] - ledif[,2]) * 365
## days of life gained by birth cohort in scenario B
