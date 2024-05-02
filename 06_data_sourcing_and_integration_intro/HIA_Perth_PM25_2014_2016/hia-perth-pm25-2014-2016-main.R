'name:main R scipt'
# ivanhanigan

################################################################################
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## Free Software
## Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
## 02110-1301, USA
################################################################################

projdir <- "~/DatSciTrain_HIA_Health_Impact_Functions_explained/06_data_sourcing_and_integration_intro/HIA_Perth_PM25_2014_2016"
 # e.g. use getwd() and pwd etc to find your path, then copy and past it here"
setwd(projdir)
# install the required packages
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
source("code/func.R")
if(!dir.exists("working_temporary")) dir.create("working_temporary")
if(!dir.exists("figures_and_tables")) dir.create("figures_and_tables")

timepoints <- 2014:2016
for(timepoint in timepoints){
## timepoint <- 2015
## TODO abs_year <- ifelse closer to 2016, else 2011

state <- "WA"


## if abs_year == 2016
source("code/scope_2014_2016.R")
## else 2011

source("code/load_pops_mb.R")
source("code/load_pops_sa2.R")
source("code/load_health_rates_standard_pop.R")
source("code/do_expected_deaths_for_subpopulations.R")  
source("code/load_environment_exposure_pm25_modelled.R")
source("code/qc_environment_exposure_pm25_modelled_missing.R")
source("code/load_environment_exposure_pm25_model_fill_missing.R")  
source("code/load_environment_exposure_pm25_counterfactual.R")
source("code/load_enviro_monitor_model_counterfactual_linked.R")
source("code/load_linked_pop_health_enviro.R")
source("code/do_health_impact_function.R")
source("code/do_attributable_number.R")

}

#### summary tables ####
source("code/do_summary_tables.R")
output_results[,c(8, 1:7)]

## write out and keep record of runs
write.csv(output_results[,c(8,1:7)], sprintf("figures_and_tables/results_%s.csv", make.names(Sys.time())), row.names = F)


