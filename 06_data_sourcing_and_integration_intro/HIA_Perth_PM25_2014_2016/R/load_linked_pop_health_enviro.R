
'name:code/load_linked_pop_health_enviro'

outdir <- "working_temporary"

dths_expectedV3 <- read.csv(file.path(outdir, sprintf("dths_expectedV3_%s_%s.csv", state, timepoint)), as.is = T)
str(dths_expectedV3)

head(pm25_pw_sa2)
nrow(pm25_pw_sa2)
#462
str(pm25_pw_sa2)
pm25_pw_sa2$SA2_MAINCODE_2016 <- as.integer(as.character(pm25_pw_sa2$SA2_MAIN16)) 
##pm25_pw_sa2[pm25_pw_sa2$SA2_MAINCODE_2016 == qcsa2,]

dths_expectedV4 <- left_join(dths_expectedV3,
                             data.frame(pm25_pw_sa2), 
                             by = c("SA2_MAINCODE_2016")
                             )
head(dths_expectedV4, 20)
##dths_expectedV4[dths_expectedV4$SA2_MAINCODE_2016 == qcsa2,]
paste(names(dths_expectedV4), sep = "", collapse = "', '")
dths_expectedV4 <- dths_expectedV4[,c('SA2_MAINCODE_2016', 'Age', 'value', 'rate', 'expected', 'SA2_NAME16', 'pm25_pw', 'pm25_anthro_pw', 'pop')]

outdir
write.csv(dths_expectedV4, file.path(outdir, sprintf("dths_expectedV4_%s_%s.csv", state, timepoint)), row.names = F)
