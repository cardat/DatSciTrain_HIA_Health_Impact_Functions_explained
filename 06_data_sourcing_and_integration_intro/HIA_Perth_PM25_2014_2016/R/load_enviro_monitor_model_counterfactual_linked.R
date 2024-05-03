
'name:code/load_enviro_monitor_model_counterfactual_linked'
## depends on config.R

if(do_env_counterfactual == "min"){
  head(pm25)
  str(pm25)
  pm25_min
  
  pm25$pm25_anthro <- pm25$pm25 - pm25_min
  
  pm25_dt <- data.table(pm25)
  
  pm25_pw_sa2 <- pm25_dt[, .(pm25_pw =  sum(pm25 * Person, na.rm = T)/sum(Person, na.rm = T),
                             pm25_anthro_pw = sum(pm25_anthro * Person, na.rm = T)/sum(Person, na.rm = T),
                             pop = sum(Person, na.rm = T)),
                         by = .(SA2_MAIN16, SA2_NAME16)
  ]
  head(pm25_pw_sa2)
  
  pm25_pw_sa3 <- pm25_dt[, .(pm25_pw =  sum(pm25 * Person, na.rm = T)/sum(Person, na.rm = T),
                             pm25_anthro_pw = sum(pm25_anthro * Person, na.rm = T)/sum(Person, na.rm = T),
                             pop = sum(Person, na.rm = T)),
                         by = .(SA3_CODE16, SA3_NAME16)
  ]
  head(pm25_pw_sa3)
} else {
  print("Environment_General folder not found, review your config.R")
}