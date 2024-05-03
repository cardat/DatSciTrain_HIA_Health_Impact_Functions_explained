
'name:code/load_environment_exposure_pm25_counterfactual'

indir <- "working_temporary"

#### the mb with lowest PM2.5 = non-anthropogenic ####
## pm25 <- readOGR(path.expand(indir), sprintf("exposure_pm25_%s_%s", state, timepoint))
pm25 <- read.csv(file.path(indir, sprintf("exposure_pm25_%s_%s.csv", state, timepoint)), as.is = T)
head(pm25)
summary(pm25$e)
head(pm25[is.na(pm25$e),"MB_CODE16"])
## TODO why are these MBs missing PM2.5?
## FILLED WITH 10 KM GRID
##pm25_10km <- readOGR(path.expand(indir), sprintf("exposure_pm25_%s_%s_10km", state, timepoint))
pm25_10km <- read.csv(file.path(indir, sprintf("exposure_pm25_%s_%s_10km.csv", state, timepoint)), as.is = T)
head(pm25_10km)
summary(pm25_10km$e)
## still 14 NA's
pm25_10km$pm25_10km <- pm25_10km$e

pm25_V2 <- pm25
pm25_V2 <- left_join(pm25, pm25_10km[,c("MB_CODE16", "pm25_10km")], by = "MB_CODE16")

head(pm25_V2)
##with(pm25_V2, plot(e, pm25_10km, ylim = c(0,7.2), xlim = c(0,7.2)))
##abline(0,1, col = 'red')

qc_filled <- pm25_V2[is.na(pm25_V2$pm25_10km)
                     & pm25_V2$Person != 0,]
if(nrow(qc_filled) > 0){
##writeOGR(qc_filled, path.expand(outdir), sprintf("mb_cent_missing_expo_%s_%s_10km_linked", state, fi), driver = "ESRI Shapefile", overwrite_layer = T)
print("some still missing")
}

##par(mfrow=c(2,1))
##plot(density(pm25_V2$e, na.rm = T),xlim = c(0,7))
##plot(density(pm25_V2$pm25_10km, na.rm = T),xlim = c(0,7))

pm25_V2$pm25 <- ifelse(is.na(pm25_V2$e), pm25_V2$pm25_10km, pm25_V2$e)
nrow(pm25_V2[is.na(pm25_V2$pm25),])
##14

pm25_min <- min(pm25_V2$pm25, na.rm = T)
pm25_min

pm25 <- pm25_V2
