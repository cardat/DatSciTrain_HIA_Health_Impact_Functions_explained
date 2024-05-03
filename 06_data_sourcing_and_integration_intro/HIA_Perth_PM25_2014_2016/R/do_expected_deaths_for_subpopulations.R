
outdir <- "working_temporary"

head(deathV4)
head(indat_popV2)

mrg_dth_pop <- merge(deathV4, indat_popV2, by = "Age")
mrg_dth_popV2 <- mrg_dth_pop[,c("SA2_MAINCODE_2016", "Age", "variable", "value", "rate")]
##qcsa2 <- 210051247
##mrg_dth_popV2[mrg_dth_popV2$SA2_MAINCODE_2016 == qcsa2,]
## this is Meadow Heights in SA3 Tullamarine - Broadmeadows
qc <- data.frame(table(mrg_dth_popV2$SA2_MAINCODE_2016))
nrow(qc)
## 464 (but the shapefile only has 462)
##qc
## 463 297979799   22
## 464 299999499   22
## 99999s

head(mrg_dth_popV2)
mrg_dth_popV2$expected <- mrg_dth_popV2$value * mrg_dth_popV2$rate

dths_expected <- data.table(mrg_dth_popV2[mrg_dth_popV2$Age != "All ages",])
dths_expectedV2 <- dths_expected[,.(deaths = sum(expected)), .(SA2_MAINCODE_2016)]

##dths_expectedV2[dths_expectedV2$SA2_MAINCODE_2016 == qcsa2,]
## 41.3 vs 44 observed, not bad

#### now we just want the 30 plus, by age
paste(names(table(dths_expected$Age)), sep = "", collapse = "', '")
dths_expectedV3 <- dths_expected[Age %in% c('30 - 34', '35 - 39', '40 - 44', 
                                            '45 - 49', '50 - 54',
                                            '55 - 59', '60 - 64', 
                                            '65 - 69', '70 - 74',
                                            '75 - 79', '80 - 84', '85 - 89', 
                                            '90 - 94', '95 - 99',
                                            '100 and over'),]
qc_30andUp <- dths_expectedV3[,.(deaths = sum(expected)), .(SA2_MAINCODE_2016)]
##qc_30andUp[qc_30andUp$SA2_MAINCODE_2016 == qcsa2,]
##39.50
##dths_expectedV3[dths_expectedV3$SA2_MAINCODE_2016 == qcsa2,]
write.csv(dths_expectedV3, file.path(outdir, sprintf("dths_expectedV3_%s_%s.csv", state, timepoint)), row.names = F)
