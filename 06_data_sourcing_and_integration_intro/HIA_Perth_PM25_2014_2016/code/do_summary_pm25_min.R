
## summary of the pm25_min used in each state/territory
pm25_min_outV2 <- data.frame(year = NA, ste = NA, pm25_min = NA)[-1,]
for(timepoint in timepoints){
  ##timepoint <- 2015

    state <- "VIC"
    
##pm25 <- foreign::read.dbf(file.path(path.expand(indir), sprintf("exposure_pm25_%s_%s.dbf", state, timepoint)))
pm25 <- read.csv(file.path(indir, sprintf("exposure_pm25_%s_%s.csv", state, timepoint)))
## FILLED WITH 10 KM GRID
##pm25_10km <- foreign::read.dbf(file.path(path.expand(indir), sprintf("exposure_pm25_%s_%s_10km.dbf", state, timepoint)))
pm25_10km <- read.csv(file.path(indir, sprintf("exposure_pm25_%s_%s_10km.csv", state, timepoint)))

pm25_10km$pm25_10km <- pm25_10km$e

##pm25_V2 <- pm25
pm25_V2 <- left_join(pm25, pm25_10km[,c("MB_CODE16", "pm25_10km")], by = "MB_CODE16")

head(pm25_V2)

pm25_V2$pm25 <- ifelse(is.na(pm25_V2$e), pm25_V2$pm25_10km, pm25_V2$e)
nrow(pm25_V2[is.na(pm25_V2$pm25),])


pm25_min <- min(pm25_V2$pm25, na.rm = T)
pm25_min_out <- data.frame(year = timepoint, ste = state, pm25_min = pm25_min)
pm25_min_outV2 <- rbind(pm25_min_outV2, pm25_min_out)

}
pm25_min_outV2 <- pm25_min_outV2[order(pm25_min_outV2$ste, pm25_min_outV2$year),]
