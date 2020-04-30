# library(tidyverse)
# library(dplyr)
# library(magrittr)
# library(here)
#
# #read in csvs
county_pops <- read_csv("Data/county_population.csv")
pop_density <- read_csv("Data/usa_pop_density.csv")
aqi_data <- read_csv("Data/county_aqi_2019.csv")
stay_home <- read_csv("Data/stay_at_home.csv")
census_data <- read_csv("Data/census_tables.csv")
case_data <- read_csv("Data/final_data.csv") %>% select(c(-county, -state))

# #merge pop data
pop <- left_join(county_pops, pop_density, by = c("county", "state"))

# #merge population density to aqi data
pop_aqi <- left_join(pop, aqi_data, by = c("county", "state"))

# #merge pop_aqi data to stay at home orders
pop_aqi_orders <- left_join(pop_aqi, stay_home, by = "state")

# #merge pop_aqi_orders data to census data
pop_aqi_orders_census <- left_join(pop_aqi_orders, census_data, by = c("county", "state"))

# #merge pop_aqi_orders_census to case data
final_data <- left_join(pop_aqi_orders_census, case_data, by = "fips")

final_data$case_ratio <- final_data$cases / final_data$population * 100
final_data$deaths_ratio <- final_data$deaths / final_data$population * 100

final_data <- final_data %>% select(state, county, fips, population, pop_density, date, cases, case_ratio, deaths, deaths_ratio, everything())

write_csv(final_data, "Data/final_data.csv")
