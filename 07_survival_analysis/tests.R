head(vet2)
str(vet2)
vet2$tgroup_f <- as.factor(vet2$tgroup)

coxph(Surv(tstart, time, status) ~ trt + prior +
        pm25_q:strata(tgroup_f), data=vet2)

coxph(Surv(tstart, time, status) ~ trt + prior +
        pm25_q:tgroup_f, data=vet2)

coxph(Surv(tstart, time, status) ~ trt + prior +
        pm25_q*tgroup_f, data=vet2)

coxph(Surv(tstart, time, status) ~ trt + prior +
        pm25_q, data=vet2, subset = tgroup == 1)
coxph(Surv(tstart, time, status) ~ trt + prior +
        pm25_q, data=vet2, subset = tgroup == 2)
coxph(Surv(tstart, time, status) ~ trt + prior +
        pm25_q, data=vet2, subset = tgroup == 3)
