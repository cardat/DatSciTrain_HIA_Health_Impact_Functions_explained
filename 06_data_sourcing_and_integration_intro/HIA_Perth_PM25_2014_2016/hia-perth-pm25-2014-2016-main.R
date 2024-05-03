# HIA_Perth_PM25_2014_2016
# A demonstration of a simple pipeline for mortality attributable to long-term air pollution exposure
# ivanhanigan

## IMPORTANT: set your project working directory
projdir <- "~/DatSciTrain_HIA_Health_Impact_Functions_explained/06_data_sourcing_and_integration_intro/HIA_Perth_PM25_2014_2016"
 # e.g. use getwd() and pwd etc to find your path, then copy and past it here"
setwd(projdir)
# install the required packages, if you need to
install_pkg_flag <- FALSE
if(install_pkg_flag){
  #install.packages("rgdal") # deprecated package
  #install.packages("rgeos") # deprecated package
  install.packages("raster")
  install.packages("foreign")
  install.packages("sqldf")
  install.packages("dplyr")
  install.packages("data.table")
  install.packages("reshape")
}
## load packages
source("R/func.R")
## load settings
source("config.R")
## create folders needed to store working files and results
if(!dir.exists("working_temporary")) dir.create("working_temporary")
if(!dir.exists("figures_and_tables")) dir.create("figures_and_tables")

for(timepoint in timepoints){
  ## for testing set this and don't loop
  ## timepoint <- 2015
  
  source("R/load_pops_mb.R")
  source("R/load_pops_sa2.R")
  source("R/load_health_rates_standard_pop.R")
  source("R/do_expected_deaths_for_subpopulations.R")  
  source("R/load_environment_exposure_pm25_modelled.R")
  source("R/qc_environment_exposure_pm25_modelled_missing.R")
  source("R/load_environment_exposure_pm25_model_fill_missing.R")  
  source("R/load_environment_exposure_pm25_counterfactual.R")
  source("R/load_enviro_monitor_model_counterfactual_linked.R")
  source("R/load_linked_pop_health_enviro.R")
  source("R/do_attributable_number.R")
  
}

#### summary tables ####
source("R/do_summary_tables.R")
output_results[output_results$GCC_NAME16 %in% c('Greater Perth', 'Rest of WA'),
               c('run', 'STE_NAME16', 'GCC_NAME16', 'attributable_number', 'pop_total', 'pm25_anthro_pw_gcc', 'pm25_pw_gcc', 'rate_per_1000000')]

## write out and keep record of runs
write.csv(output_results[,c(8,1:7)], 
          sprintf("figures_and_tables/results_%s.csv", make.names(Sys.time())), 
          row.names = F)


