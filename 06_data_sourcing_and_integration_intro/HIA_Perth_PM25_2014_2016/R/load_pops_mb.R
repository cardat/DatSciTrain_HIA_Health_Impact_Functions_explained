
'name:code/load_pops_mb'

shp <- st_read(file.path(indir_mb, infile_mb))
# 
if(specific_stdy_reg){
  todo <- foreign::read.dbf(stdy_reg)
  ## names(todo)
  ## names(shp)
  shp2 <- shp[shp@data$SA3_CODE16 %in% todo$SA3_CODE16,]
  ##
  ##plot(shp2)
  
} else {
  shp2 <- shp
}

## population

level0_pops <- read.csv(file.path(indir_mb_pops, infile_mb_pops), as.is = T)
head(level0_pops)
level0_pops$MB_CODE16 <- level0_pops$MB_CODE_2016

head(shp2,2)

shp2 <- left_join(shp2, level0_pops[,mb_pops_varlist])
head(shp2)
