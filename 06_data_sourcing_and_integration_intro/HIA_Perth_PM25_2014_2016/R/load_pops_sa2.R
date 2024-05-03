
'name:load_pop'
dir(indir_pop)
indat_pop <- read.csv(file.path(indir_pop, infile_pop_sa2), as.is = T)

head(indat_pop)

indat_pop$ste <- substr(indat_pop$SA2_MAINCODE_2016, 1, 1)
table(indat_pop$ste)
indat_pop$state <- recode(indat_pop$ste,
'1'='NSW', '2'='VIC', '3'='QLD', '4'='SA', '5'='WA', '6'='TAS', '7'='NT','8'='ACT', '9' = 'OT'                               
)
table(indat_pop$state, indat_pop$ste)

indat_popV2 <- indat_pop[indat_pop$state == state,]

head(indat_popV2)
