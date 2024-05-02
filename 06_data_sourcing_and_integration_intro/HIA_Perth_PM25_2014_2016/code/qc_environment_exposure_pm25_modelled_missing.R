
#### QC ####
fi_exists <- file.exists(file.path(path.expand(outdir), sprintf("mb_cent_%s.shp", state)))
if(!fi_exists){
writeOGR(pts, path.expand(outdir), sprintf("mb_cent_%s", state), driver = "ESRI Shapefile", overwrite_layer = T)
}

## did all areas get an estimate? valid reasons why not include coastal zones that have centroids in the ocean/lakes (see Gippsland lakes), but this can be fixed
qc <- pts2[is.na(pts2@data$e),]
head(qc@data)
qc <- qc[qc@data$Person != 0,]

writeOGR(qc, path.expand(outdir), sprintf("mb_cent_missing_expo_%s_%s", state, fi), driver = "ESRI Shapefile", overwrite_layer = T)
