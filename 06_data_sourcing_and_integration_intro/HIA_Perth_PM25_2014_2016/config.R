
# datadir <- "/home/public_share_data/ResearchData_Train_DataScience/HIA_Health_Impact_Assessments/HIA_workshop_2021/data_provided"
datadir <- "C:/Users/287658C/Nextcloud/Environment_General"
specific_stdy_reg <- FALSE

##mb
indir_mb <- file.path(datadir,  sprintf("ABS_data/ABS_meshblocks/abs_meshblocks_2016_data_provided/"))
# 1270055001_mb_2016_%s_shape/", tolower(state))
infile_mb <- sprintf("MB_2016_%s.shp", state)
## meshblock pops
indir_mb_pops <- file.path(datadir, "ABS_data/ABS_meshblocks/abs_meshblocks_2016_pops_data_provided")
dir(indir_mb_pops)
infile_mb_pops <- "2016 census mesh block counts.csv"
mb_pops_varlist <- c("MB_CODE16", "MB_CATEGORY_NAME_2016", "Person")

## pops at sa2
indir_pop <- file.path(datadir, "ABS_data/ABS_Census_2016/abs_gcp_2016_data_derived")
infile_pop_sa2 <- "abs_sa2_2016_agecatsV2_total_persons_20180405.csv"

## 0301 load health rates standard
## TODO if age specific use
indir_death <- file.path(datadir, "Australian_Mortality_ABS/ABS_MORT_2006_2016/data_provided/")
infile_death <- "DEATHS_AGESPECIFIC_OCCURENCEYEAR_04042018231304281.csv"
indat_death_varlist <- c("Region", "Sex", "Age", "Measure", "Time", "Value")

## if cause specific use
## the aihw mort books

## exposure
indir_expo <- file.path(datadir, "Air_pollution_model_GlobalGWR_PM25/GlobalGWR_PM25_V4GL02/data_derived/")


indir_sa3 <- file.path(datadir, "ABS_data/ABS_Census_2016/abs_sa3_2016_data_provided")
infile_sa3 <- "SA3_2016_AUST.shp"
