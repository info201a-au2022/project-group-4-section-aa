library(dplyr)
library(knitr)

concentrations_particulate_matter <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-4-section-aa/main/data/Concentrations%20of%20fine%20particulate%20matter.csv")

mortality <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-4-section-aa/main/data/Mortality%20rate%20attributed%20to%20household%20and%20ambient%20air%20pollution.csv")

clean_fuels <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-4-section-aa/main/data/Household%20air%20pollution%20data.csv")


# clean_fuels 2019 data values primarily use
new_clean_fuels <- clean_fuels %>% 
  filter(Period == "2019") %>% 
  select(ParentLocation, Location, Period, Dim1, FactValueNumeric) %>% 
  rename(Region = ParentLocation, Countries = Location, Year = Period, Areas = Dim1, Rates = FactValueNumeric)

## 2019 clean fuels reliance rates on average for each region
avg_reliance_region <- new_clean_fuels %>% 
  group_by(Region) %>% 
  summarise(avg_clean_fuels_rate = mean(Rates, na.rm = TRUE, round(2)))

## 2019 clean fuels reliance rates on average for each countries
avg_reliance_countries <- new_clean_fuels %>% 
  group_by(Countries) %>% 
  summarise(avg_clean_fuels_rate = mean(Rates, na.rm = TRUE, round(2)))


# mortality data values primarily use 
new_mortaity <- mortality %>% 
  select(ParentLocation, Location, Period, Dim1, Dim2, FactValueNumeric) %>% 
  rename(Region = ParentLocation, Countries = Location, Year = Period, Sexual = Dim1, Causes = Dim2,Rates = FactValueNumeric)

## mortality rates on average for each region
avg_mortality_region <- new_mortaity %>% 
  group_by(Region) %>% 
  summarise(avg_mortality_rate = mean(Rates, na.rm = TRUE, round(2)))

## mortality rates on average for each countries
avg_mortality_countries <- new_mortaity %>% 
  group_by(Countries) %>% 
  summarise(avg_mortality_rate = mean(Rates, na.rm = TRUE, round(2)))


# Concentrations particulate matter data values primarily use
new_concentrations_particulate_matter <- concentrations_particulate_matter %>% 
  select(ParentLocation, Location, Period, Dim1, FactValueNumeric) %>% 
  rename(Region = ParentLocation, Countries = Location, Year = Period, Areas = Dim1, Rates = FactValueNumeric)

## Concentrations particulate matter on average for each region
avg_concentrations_region <- new_concentrations_particulate_matter %>% 
  group_by(Region) %>% 
  summarise(avg_concentration_rate = mean(Rates, na.rm = TRUE, round(2)))

## Concentrations particulate matter on average for each countries
avg_Concentrations_countries <- new_concentrations_particulate_matter %>% 
  group_by(Countries) %>% 
  summarise(avg_concentration_rate = mean(Rates, na.rm = TRUE, round(2)))

## summary of all three average rate for regions
summary_values_region <- left_join(avg_concentrations_region, 
                                   avg_mortality_region, 
                                   by = "Region") %>% 
  mutate(avg_reliance_rate = avg_reliance_region$avg_clean_fuels_rate)

## output as an table
kable(summary_values_region)

## summary of all three average rate for countries
summary_values_countries <- left_join(avg_reliance_countries, 
                                      avg_Concentrations_countries, 
                                      by = "Countries") %>% 
  left_join(avg_mortality_countries, by = "Countries")

## output as an table
kable(summary_values_countries)
