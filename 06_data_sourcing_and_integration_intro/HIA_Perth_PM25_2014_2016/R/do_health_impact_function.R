
'name:code/do_health_impact_function'
rr <- 1.062
rr_lci <- 1.040
rr_uci <- 1.083
# this is a RR per 10 unit change
unit_change <- 10
beta <- log(rr)/unit_change
beta
## so if x = 10
x <- 10
exp(beta * x)
## or alternately
rr^(x/10)
