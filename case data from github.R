# library(tidyverse)
# library(magrittr)
# library(DataCombine)
# 
# #Set WD
# setwd("~/GitHub/covid-19")
# 
# #read in csv
case_data <- read_csv("~/GitHub/covid-19-data/us-counties.csv")
  
# #clean up names, first select everything to be changed
case_data_2 <- case_data %>% 
  filter(county != "Carson City" 
         & county != "St. Louis City" 
         & county != "Fairfax City" 
         & county != "Baltimore City"
         & county != "Kansas City"
         & county != "New York City"
         & county != "Franklin City")

# #create a small data frame to add back when cleanup is done
case_data_3 <- case_data %>% 
  filter(county %in% c("Carson City", "St. Louis City", "Fairfax City", "Franklin City", "Baltimore City", "New York City")) 

# #make a list of words to remove
wordstoremove <- c(" County", " City", " Parish", " and Borough", " Borough", " Municipality", " Census Area")%>% 
  paste0(collapse = "|")

case_data_2 <- case_data_2 %>%
  mutate(county = str_remove_all(county, regex(str_c("\\b", wordstoremove, "\\b", collapse = "|"), ignore_case = T)),)

# #merge together
case_data <- rbind(case_data_2, case_data_3)

# #make fips field numeric
case_data$fips <- as.numeric(case_data$fips)

# #filter
case_data <- case_data %>%
  filter(cases > 0) %>%
  group_by(date) %>%
  group_by(county, state) %>%
  slice(1L + 15)

county_data <- case_data[complete.cases(case_data$fips), ]

write_csv(county_data, "Data/county_data.csv")

state_data <- subset(case_data,is.na(fips))

write_csv(state_data, "Data/state_data.csv")

