
'name:load_deaths'
## 0301 load health rates standard
indat_death <- read.csv(file.path(indir_death, infile_death), as.is = T)
head(indat_death)

indat_deathV2 <- indat_death[,indat_death_varlist]

head(indat_deathV2)
paste(names(table(indat_deathV2$Region)), collapse="', '", sep = "")
indat_deathV2$RegionV2 <- recode(indat_deathV2$Region,
'Australian Capital Territory' = 'ACT', 'New South Wales' = 'NSW', 'Northern Territory'='NT', 'Queensland'='QLD', 'South Australia'='SA', 'Tasmania'='TAS', 'Victoria'='VIC', 'Western Australia'='WA'                               
)
table(indat_deathV2$Time)

deathV3 <- indat_deathV2[indat_deathV2$RegionV2 == state
                         & indat_deathV2$Time %in% (timepoint-2):timepoint
                         & indat_deathV2$Sex == "Persons"
                        ,]

table(deathV3$Age, deathV3$Sex)
head(deathV3)

deathV4 <- cast(deathV3[,c("RegionV2", "Sex", "Age", "Measure","Time", "Value")], Age ~ Measure, fun = mean)
head(deathV4)
deathV4$rate <- deathV4$Deaths / deathV4$Population

plot(deathV4$rate * 1000, deathV4[,2])
