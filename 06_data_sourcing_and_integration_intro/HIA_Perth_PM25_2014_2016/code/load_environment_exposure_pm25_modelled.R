
'name:code/load_environment_exposure_pm25_modelled'
## exposure

outdir <- "working_temporary"

flist <- dir(indir_expo, pattern = "GlobalGWR_")
flist <- flist[grep(".tif$", flist)]
flist2 <- dir(indir_expo, pattern = "GlobalGWRwUni_")
flist2 <- flist2[grep(".tif$", flist2)]

flist3 <- c(flist, flist2)
flist3

shp2 <- shp2[shp2$MB_CAT16 != "NOUSUALRESIDENCE",]

qc <- cbind(shp2, st_coordinates(pts0))
head(qc)
summary(qc)
shp2 <- qc[!is.na(qc$X),]

pts0 <- st_centroid(shp2, byid = T)
summary(st_coordinates(pts0))

pts <- SpatialPointsDataFrame(st_coordinates(pts0), st_drop_geometry(shp2)) #, proj4string = crs(shp2))
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
