
'name:code/load_environment_exposure_pm25_modelled'
## exposure

outdir <- "working_temporary"

flist <- dir(indir_expo, pattern = "GlobalGWR_")
flist <- flist[grep(".tif$", flist)]
flist2 <- dir(indir_expo, pattern = "GlobalGWRwUni_")
flist2 <- flist2[grep(".tif$", flist2)]

flist3 <- c(flist, flist2)
flist3

## NOTE shp2 is loaded in script: load_pops_mb.R
## there are some missing coordinate data
shp2 <- shp2[!st_is_empty(shp2),]

## we will use a simple method to extract the exposure data at centre of polygon
## rather than more time-consuming area-averages
pts0 <- st_centroid(shp2, byid = T)
pts0_xy <- st_coordinates(pts0)
summary(pts0_xy)

shp2_joined <- cbind(shp2, pts0_xy)
head(shp2_joined)
summary(shp2_joined)

pts <- SpatialPointsDataFrame(pts0_xy, st_drop_geometry(shp2_joined))
#plot(pts, col = "red")

for(fi in timepoint){
##  fi <- 2015
fli <- flist3[grep(fi,flist3)]
print(fli)
infile_expo <- fli
r <- raster(file.path(indir_expo, infile_expo))
#plot(r, add = T)
#plot(st_geometry(shp2), add = T)

e <- extract(r, pts)
head(e)
pts2 <- shp2
pts2 <- cbind(pts2, e)
head(pts2)

##writeOGR(pts2, path.expand(outdir), sprintf("exposure_pm25_%s_%s", state, fi), driver = "ESRI Shapefile", overwrite_layer = T)
write.csv(st_drop_geometry(pts2), file.path(outdir, sprintf("exposure_pm25_%s_%s.csv", state, fi)), row.names = F)

}
