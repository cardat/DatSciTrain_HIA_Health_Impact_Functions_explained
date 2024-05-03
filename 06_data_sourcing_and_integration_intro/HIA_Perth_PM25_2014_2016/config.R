## Make your selections here
state <- "WA"
timepoints <- 2014:2016

# health_impact_function
rr <- 1.062
rr_lci <- 1.040
rr_uci <- 1.083
# this is a RR per 10 unit change
unit_change <- 10
beta <- log(rr)/unit_change
beta
## so if x = 10
x <- 10
exp(beta * x)
## or alternately
rr^(x/10)

## what counterfactual method to use?  NB only regional minimum implemented here. 
## review R/load_enviro_monitor_model_counterfactual_linked.R to change this
do_env_counterfactual <- "min"

# COESRA: datadir <- "/home/public_share_data/ResearchData_Train_DataScience/HIA_Health_Impact_Assessments/HIA_workshop_2021/data_provided"
# OR CLOUD-CARDAT
datadir <- "C:/Users/287658C/Nextcloud/Environment_General"

# optional setting for a sub-state region, not tested
specific_stdy_reg <- FALSE

## mb
indir_mb <- file.path(datadir,  sprintf("ABS_data/ABS_meshblocks/abs_meshblocks_2016_data_provided/"))
infile_mb <- sprintf("MB_2016_%s.shp", state)

## meshblock pops
indir_mb_pops <- file.path(datadir, "ABS_data/ABS_meshblocks/abs_meshblocks_2016_pops_data_provided")
dir(indir_mb_pops)
infile_mb_pops <- "2016 census mesh block counts.csv"
mb_pops_varlist <- c("MB_CODE16", "MB_CATEGORY_NAME_2016", "Person")

## pops at sa2
indir_pop <- file.path(datadir, "ABS_data/ABS_Census_2016/abs_gcp_2016_data_derived")
infile_pop_sa2 <- "abs_sa2_2016_agecatsV2_total_persons_20180405.csv"

## load health rates standard
indir_death <- file.path(datadir, "Australian_Mortality_ABS/ABS_MORT_2006_2016/data_provided/")
infile_death <- "DEATHS_AGESPECIFIC_OCCURENCEYEAR_04042018231304281.csv"
indat_death_varlist <- c("Region", "Sex", "Age", "Measure", "Time", "Value")

## exposure
indir_expo <- file.path(datadir, "Air_pollution_model_GlobalGWR_PM25/GlobalGWR_PM25_V4GL02/data_derived/")

## SA3
indir_sa3 <- file.path(datadir, "ABS_data/ABS_Census_2016/abs_sa3_2016_data_provided")
infile_sa3 <- "SA3_2016_AUST.shp"
