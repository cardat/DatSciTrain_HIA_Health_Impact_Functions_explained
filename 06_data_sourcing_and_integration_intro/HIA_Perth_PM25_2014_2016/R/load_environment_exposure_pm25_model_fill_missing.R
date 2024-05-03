
'name:code/load_environment_exposure_pm25_model_fill_missing'
## exposure for missings

outdir <- "working_temporary"

flist <- dir(indir_expo, pattern = "GlobalGWRc_")
flist <- flist[grep(".tif$", flist)]
flist2 <- dir(indir_expo, pattern = "GlobalGWRcwUni_")
flist2 <- flist2[grep(".tif$", flist2)]

flist3 <- c(flist, flist2)
flist3

#pts0 <- gCentroid(shp2, byid = T)
#head(pts0@coords)
#pts <- SpatialPointsDataFrame(pts0@coords, shp2@data, proj4string = CRS(proj4string(shp2)))
#plot(pts, add = T, col = "red")

for(fi in timepoint){
##  fi <- 2015
fli <- flist3[grep(fi,flist3)]
print(fli)
infile_expo <- fli
r <- raster(file.path(indir_expo, infile_expo))

e <- extract(r, pts)
head(e)
pts2 <- shp2
pts2 <- cbind(pts2, e)
head(pts2)

##writeOGR(pts2, path.expand(outdir), sprintf("exposure_pm25_%s_%s_10km", state, fi), driver = "ESRI Shapefile", overwrite_layer = T)
write.csv(st_drop_geometry(pts2), file.path(outdir, sprintf("exposure_pm25_%s_%s_10km.csv", state, fi)), row.names = F)

}

#### QC ####

## did all areas get an estimate? valid reasons why not include coastal zones that have centroids in the ocean/lakes (see Gippsland lakes), but this can be fixed
qc <- pts2[is.na(pts2$e),]
head(qc)
qc <- qc[qc$Person != 0,]
if(nrow(qc) > 0){
writeOGR(qc, path.expand(outdir), sprintf("mb_cent_missing_expo_%s_%s_10km", state, fi), driver = "ESRI Shapefile", overwrite_layer = T)
}
