
'name:code/do_attributable_number'
# attributable
indir <- "working_temporary"

dths_expectedV4 <- read.csv(file.path(outdir, sprintf("dths_expectedV4_%s_%s.csv", state, timepoint)), as.is = T)

head(dths_expectedV4) 
##qcsa2 <- 210051247
##dths_expectedV4[dths_expectedV4$SA2_MAINCODE_2016 == qcsa2,]


dths_expectedV4$attributable <-  (exp(beta * dths_expectedV4$pm25_anthro_pw) - 1) * dths_expectedV4$expected

## TODO summarise to just the GMR of Melb and compare against richard
dths_attr <- data.table(dths_expectedV4)
dths_attrV2 <- dths_attr[,.(pop_tot = sum(value, na.rm = T),
                            expected_tot = sum(expected, na.rm = T),
                            an_sa2 = sum(attributable, na.rm = T),
                            pm25_anthro_pw_sa2 = mean(pm25_anthro_pw, na.rm = T),
                            pm25_pw_sa2 = mean(pm25_pw, na.rm = T)
                            ),
                         by = .(SA2_MAINCODE_2016, SA2_NAME16)
                         ]
##dths_attrV2[dths_attrV2$SA2_MAINCODE_2016 == qcsa2,]
dths_attrV2$SA3 <- substr(dths_attrV2$SA2_MAINCODE_2016, 1,5)
dths_attrV3 <- dths_attrV2[,.(pop_tot_sa3 = sum(pop_tot, na.rm = T),
                              expected_tot_sa3 = sum(expected_tot, na.rm = T),
                              an_sa3 = sum(an_sa2, na.rm = T),
                              pm25_anthro_pw_sa3 = sum(pm25_anthro_pw_sa2 * pop_tot, na.rm = T)/sum(pop_tot, na.rm = T),
                              pm25_pw_sa3 = sum(pm25_pw_sa2 * pop_tot, na.rm = T)/sum(pop_tot, na.rm = T)
                              ),
                           by = .(SA3)
                           ]
head(dths_attrV3, 20)
## sa3 20901 is Banyule with estimate 15.5 (Broome's estimate was 14)

sa3 <- st_read(file.path(indir_sa3, infile_sa3))
head(sa3)
dths_attrV4 <- left_join(data.frame(dths_attrV3), 
                         sa3, 
                         by = c("SA3" = "SA3_CODE16")
                         )
head(dths_attrV4)
dths_attrV4$geometry <- NULL
nrow(dths_attrV3)
dths_attrV4[is.na(dths_attrV4$GCC_CODE16),]

# SA3 pop_tot_sa3 expected_tot_sa3 an_sa3 SA3_NAME16 SA4_CODE16 SA4_NAME16
# 53 29797          25       0.05563499      0       <NA>       <NA>       <NA>
#   54 29999        4585      19.77492923      0       <NA>       <NA>       <NA>
#   GCC_CODE16 GCC_NAME16 STE_CODE16 STE_NAME16 AREASQKM16
# 53       <NA>       <NA>       <NA>       <NA>         NA
# 54       <NA>       <NA>       <NA>       <NA>         NA

##getwd()

write.csv(dths_attrV4, 
          file.path("figures_and_tables", sprintf("deaths_attributable_%s_%s.csv", state, timepoint))
          , row.names = F)

#