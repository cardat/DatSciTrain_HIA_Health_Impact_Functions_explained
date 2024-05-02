
'name:code/load_environment_exposure_pm25_modelled'
## exposure

outdir <- "working_temporary"

flist <- dir(indir_expo, pattern = "GlobalGWR_")
flist <- flist[grep(".tif$", flist)]
flist2 <- dir(indir_expo, pattern = "GlobalGWRwUni_")
flist2 <- flist2[grep(".tif$", flist2)]

flist3 <- c(flist, flist2)
flist3

pts0 <- gCentroid(shp2, byid = T)
head(pts0@coords)
pts <- SpatialPointsDataFrame(pts0@coords, shp2@data, proj4string = CRS(proj4string(shp2)))
#plot(pts, col = "red")

for(fi in timepoint){
##  fi <- 2010
fli <- flist3[grep(fi,flist3)]
print(fli)
infile_expo <- fli
r <- raster(file.path(indir_expo, infile_expo))
#plot(r, add = T)
#plot(shp2, add = T)

#e <- extract(r, shp2, weights = T)
# woah this takes forever and I killed it

e <- extract(r, pts)
head(e)
pts2 <- shp2
pts2@data <- cbind(pts2@data, e)
head(pts2@data)

##writeOGR(pts2, path.expand(outdir), sprintf("exposure_pm25_%s_%s", state, fi), driver = "ESRI Shapefile", overwrite_layer = T)
write.csv(pts2, file.path(outdir, sprintf("exposure_pm25_%s_%s.csv", state, fi)), row.names = F)

}
