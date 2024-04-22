## Calculation methods for attributable number given exposure to risk factors
## ivanhanigan
library(data.table)
## simplest

## if RR is
rr <- 1.05
## fraction within
paf = (rr-1)/rr
cases = 10
attr = paf * cases
attr
0.4761905
# this is the attributable number OUT OF THE 10 OBSERVED GIVEN EXPOSURE

# fraction excess on top
attr = (rr-1) * cases
attr
0.5
## this is the attributable number THAT WOULD BE OBSERVED OVER AND
## ABOVE THE 10 IF THE POP WERE EXPOSED

## If the proportion of the population exposed to risk is denoted by
## p, then it may be shown (Levin 1953) that the proportion of all cases
## (in both exposed and non-exposed groups) which are associated with
## exposure is p(r-1)/(p(r-1)+1) as opposed to (rr-1)/rr

## For a per unit increase of exposure X given a
## population fraction (ie. the proportion of the population-time in
## the exposed category) is 100%
pf1 <- 1

## then PAF is
paf <- (pf1 * (rr - 1))/((pf1 * (rr - 1)) + 1)
## (using the Levin 1953 definition)
## Levin, M. (1953). The occurrence oflung cancer in man. Acta Unio Internationalis Contra Cancrum, 9, 531–41. (as quoted in Walter, S. D. (1978). Calculation of attributable risks from epidemiological data. International Journal of Epidemiology, 7(2), 175–182. https://doi.org/10.1093/ije/7.2.175)
paf
## [1] 0.04761905
## this means that just under 5% of the observed cases were
## attributable to this risk factor
## if a proportion of the population time is unexposed (say in a study
## population you have 20% unexposed and 80% exposed)
pf1 <- 0.8
paf <- (pf1 * (rr - 1))/((pf1 * (rr - 1)) + 1)
paf
0.03846154
## which is the attributable FRACTION given this
## exposure/population-time

## back to the entire population example
paf <- (rr - 1)/rr
paf


## further examples
## if you got 6 cases (or 6 per thousand say) in your exposed study pop
6 * paf
## [1] 0.2857143
## this 'number' was attributable to the risk factor (i.e. about a
## third of a person)

## Alternately, if you had 6 cases in an 'unexposed' population (or
## you estimate an expected number based on an external standard) then
## you can estimate the additional expected number if they were
## exposed as
6 * rr
## [1] 6.3

## which can be compared to the unexposed to get the attributable number
6 * (rr - 1)
## [1] 0.3

## an alternative formulation is to use the log transformed RR, which
## is the beta coefficient returned by a log-linear regression model
beta <- log(rr)
beta
## [1] 0.04879016

## which can be applied to an unexposed pop
6 * (exp(beta)-1)
## [1] 0.3

## or to an exposed pop
6 * (1-exp(-beta))
## [1] 0.2857143
## what this means is 
# rr-1/rr
# rr/rr - 1/rr
# 1 - 1/rr
# and 1/exp(beta) is the same as exp(-beta)

## recall this is using a RR expressed as change in risk of one unit
## increase in X, but often RR are published for a different exposure
## contrast. E.g. Jerrett et al. 2005 report PM2.5 RR using a 10ug/m^3 change
rr_per10 <- 1.25
unit_change <- 10
beta2 <- log(rr_per10)/unit_change
beta2

## conversely, if we calculated the change per 1 unit X, we could
## standardise across different risk factors by adjusting the
## attributable number per IQR change
rr2 <- exp(beta2 * unit_change)
rr2

## or in the case of avoidable mortality you might set a
## counterfactual as the theoretical minimum risk exposure level
## (TMREL), or the target/referent (non-anthropogenic). Using Hankey et
## al. 2011 as an e.g.
X <- 23.6
counterfactual <- 13.6
deltaX <- X - counterfactual
deltaX
rr2 <- exp(beta2*deltaX)
rr2
## also see Broome 2016 Env International (the Shipping paper) for a nice published example

## if you have a varying exposure-response curve then the RR can be
## different at levels of the risk factor

## for example physical activity

## As cited by Hankey 2012, the WHO (2004) suggests a three-tier dose–response for physical
## activity: a) active (exercise for > 150 min/week; RR = 1), b)
## insufficiently active (exercise for 1–150 min/week; RR = 1.31), and
## c) inactive (0 min exercise per week; RR = 1.47), allowing for only
## three possible physical activity RRs


## the data.table package makes the calculations easier to code
## use the example from Hanley 2001 where the table 1 shows a published error
## create a table of the RRs
rr_act <- data.table(class = c("a_low","b_moderate","c_high"),
                     rr = c(1, 1.4, 1.7))

rr_act
## the population (Hanley doesn't show cases so just set to 1)
dat <- data.table(
                  class = c("a_low","b_moderate","c_high"),
                  cases = c(1,1,1),
                  pop = c(50,30,20)
)
dat

## merge these
dat2 <- merge(dat, rr_act, by = "class")
dat2
## calculate the proportion of pop in each level of risk
dat2[,prop := pop/sum(pop)]
dat2
## note this next step is incorrect! See Hanley 2001 for demonstration
## how easy it is to misunderstand
out <- dat2[,
            paf := (prop * (rr - 1)) / (1 + (prop * (rr - 1)))
][]
out
## It is wrong to apply this formula at each level of the risk factor
## the correct method is more like a weighted average (note the sum in
## the denominator)
out <- dat2[,
            paf := (prop * (rr - 1)) / (1 + sum((prop * (rr - 1))))
            ][]
out

## and in a single step now sum over levels of risk to calculate paf,
## then second square brackets does final calculation of attributable
## number
out <- dat2[, .(cases = sum(cases),
                pop = sum(pop),
                prop = sum(prop),
                paf = sum(prop * (rr - 1)) / (1 + sum(prop * (rr - 1)))
                )
            ][,attr := cases * paf][]
out


## continuing the example of having a rate of 6 per thousand in a
## study pop
## create a table of the RRs
## From WHO / Hankey
## Referent, > 150 min/week;
## insufficiently active, 1–150 min/week;
## inactive, 0 min/week.
rr_act <- data.table(class = c("a_active","b_insufficent","c_inactive"),
                     rr   = c(1.00, 1.31, 1.47),
                     rrlc = c(1.00, 1.21, 1.39),
                     rruc = c(1.00, 1.41, 1.56)
                     )
##
rr_act
## create a simulated population with 6 cases and 1000 person-years
dat <- data.table(class = c("a_active","b_insufficent","c_inactive"),
                  cases = c(1,4,1),
                  pop = c(200,600,200))
dat
## merge these
dat2 <- merge(dat, rr_act, by = "class")
dat2
## calculate the proportion of pop in each level of risk
dat2[,prop := pop/sum(pop)]
dat2
## and now sum over levels of risk to calculate paf, then second square brackets does final calculation
out <- dat2[, .(cases = sum(cases),
                pop = sum(pop),
                prop = sum(prop),
                paf = sum(prop * (rr - 1)) / (1 + sum(prop * (rr - 1))))
            ][,attr := cases * paf][]
out
## so of the 6 cases observed in this exposed pop 1.31 were
## attributable to the risk factor

## now extend the example of having three study pops, say by neighbourhood type

## create a simulated population with 6 cases and 1000 person-years
dat <- data.table(neighbourhood_type = c(rep("a_high", 3), rep("b_medium", 3), rep("c_low", 3)),
                  class = rep(c("a_active","b_insufficent","c_inactive"), 3),
                  cases = c(1,4,1, 2,2,2, 2,3,1),
                  pop = c(200,600,200, 250,250,500, 400,200,400))
dat
## merge these
dat2 <- merge(dat, rr_act, by = "class")[order(neighbourhood_type),]
dat2
## calculate the proportion of pop in each level of risk
dat2[,prop := pop/sum(pop), by = .(neighbourhood_type)]
dat2
## now sum over levels of risk to calculate paf, then second square brackets does final calculation
out <- dat2[, .(cases = sum(cases),
                pop = sum(pop),
                prop = sum(prop),
                paf = sum(prop * (rr - 1)) / (1 + sum(prop * (rr - 1)))),
            by = .(neighbourhood_type)
            ][,attr := cases * paf][]
knitr::kable(out, digits = 2)
## so of the 6 cases observed in this exposed pop 1.31 were
## attributable to the risk factor in the 'high' neighbourhood class
## 1.43 were attributable in the 'medium' and 1.2 were attributable in the 'low' neighbourhood

################################################################
## case study: sydney LHD
rr_act <- data.table(class = c("a_active","b_insufficent","c_inactive"),
                     rr   = c(1.00, 1.31, 1.47),
                     rrlc = c(1.00, 1.21, 1.39),
                     rruc = c(1.00, 1.41, 1.56)
                     )
##
rr_act
## create a simulated population
ihd_rate_per100K <- 46.3
prop_insufficient_active <- 0.324
pop <- 666537
dat <- data.table(class = c("a_active","b_insufficent","c_inactive"),
                  incidence = c(ihd_rate_per100K/100000,ihd_rate_per100K/100000,0),
                  pop = c((1.00-prop_insufficient_active) * pop, prop_insufficient_active * pop, 0))
dat
## merge these
dat2 <- merge(dat, rr_act, by = "class")
dat2
dat2[,cases := incidence * pop]
## calculate the proportion of pop in each level of risk
dat2[,prop := pop/sum(pop)]
dat2
out <- dat2[,
              paf := (prop * (rr - 1)) / (sum((prop * (rr - 1))) + 1)
            ][]
out

## and now sum over levels of risk to calculate paf, 
out <- dat2[, .(cases = sum(cases),
                pop = sum(pop),
                prop = sum(prop),
                paf = sum(prop * (rr - 1)) / (1 + sum(prop * (rr - 1))),
                paf_lc = sum(prop * (rrlc - 1)) / (1 + sum(prop * (rrlc - 1))),
                paf_uc = sum(prop * (rruc - 1)) / (1 + sum(prop * (rruc - 1)))
                )
            ][,attr := cases * paf][]
# the second square brackets does final calculation
knitr::kable(out[,.(cases = cases,
             attr = attr, attr_lc = cases * paf_lc, attr_uc = cases * paf_uc)],
      digits = 1
      )
## so of the 308.6 cases *observed* in this exposed pop around
## 28.2 (95%CI 19.7, 36.2) were
## attributable to the risk factor

