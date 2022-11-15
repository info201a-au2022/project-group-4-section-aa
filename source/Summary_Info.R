# Summary_info.R
library(dplyr)

concentrations_particulate_matter <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-4-section-aa/main/data/Concentrations%20of%20fine%20particulate%20matter.csv")

mortality <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-4-section-aa/main/data/Mortality%20rate%20attributed%20to%20household%20and%20ambient%20air%20pollution.csv")

clean_fuels <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-4-section-aa/main/data/Household%20air%20pollution%20data.csv")

## All the calculated values are from 2019

summary_info <- list()

# Summary of observations for each data sets
summary_info$observations_clean_fuels <- nrow(clean_fuels)
summary_info$observations_mortality <- nrow(mortality)
summary_info$observations_concentrations <- nrow(concentrations_particulate_matter)

# The average reliance rates on 2019 (Value)
summary_info$avg_reliance_2019 <- clean_fuels %>% 
  filter(Period == "2019") %>% 
  summarise(avg_rate_2019 = mean(FactValueNumeric, na.rm = TRUE, round(2))) %>% 
  pull(avg_rate_2019)

## Rural average reliance rate (Value)
summary_info$avg_reliance_rural <- clean_fuels %>% 
  filter(Period == "2019") %>% 
  filter(Dim1 == "Rural") %>% 
  summarise(avg_rate_2019 = mean(FactValueNumeric, na.rm = TRUE, round(2))) %>% 
  pull(avg_rate_2019)

## Urban average reliance rate (Value)
summary_info$avg_reliance_urban <- clean_fuels %>% 
  filter(Period == "2019") %>% 
  filter(Dim1 == "Urban") %>% 
  summarise(avg_rate_2019 = mean(FactValueNumeric, na.rm = TRUE, round(2))) %>% 
  pull(avg_rate_2019)

## Region has the most reliance rates (Value 1)
summary_info$Region_most_reliance <- clean_fuels %>%
  filter(Period == "2019") %>% 
  group_by(ParentLocation) %>% 
  summarise(avg_rate = mean(FactValueNumeric, na.rm = TRUE, round(2))) %>% 
  filter(avg_rate == max(avg_rate)) %>% 
  pull(ParentLocation)

## Region has the least reliance rates (Value 2)
summary_info$Region_least_reliance <- clean_fuels %>% 
  group_by(ParentLocation) %>% 
  summarise(avg_rate = mean(FactValueNumeric, na.rm = TRUE, round(2))) %>% 
  filter(avg_rate == min(avg_rate)) %>% 
  pull(ParentLocation)

# The average mortality rates on 2019 (Value)
summary_info$avg_mortality_2019 <- mortality %>% 
  summarise(avg_rate_2019 = mean(FactValueNumeric, na.rm = TRUE, round(2))) %>% 
  pull(avg_rate_2019)

## Region has the highest mortality (Value 3)
summary_info$Region_most_mortality <- mortality %>%
  group_by(ParentLocation) %>% 
  summarise(avg_rate = mean(FactValueNumeric, na.rm = TRUE, round(2))) %>% 
  filter(avg_rate == max(avg_rate)) %>% 
  pull(ParentLocation)

## Region has the lowest mortality (Value 4)
summary_info$Region_lowest_mortality <- mortality %>% 
  group_by(ParentLocation) %>% 
  summarise(avg_rate = mean(FactValueNumeric, na.rm = TRUE, round(2))) %>% 
  filter(avg_rate == min(avg_rate)) %>% 
  pull(ParentLocation)

# The average concentrations rates on 2019 (Value)
summary_info$avg_concentrations_2019 <- concentrations_particulate_matter %>% 
  summarise(avg_rate_2019 = mean(FactValueNumeric, na.rm = TRUE, round(2))) %>% 
  pull(avg_rate_2019)

# Urban average concentration rate
summary_info$avg_concentrations_urban <- concentrations_particulate_matter %>% 
  filter(Dim1 == "Urban") %>% 
  summarise(avg_rate_2019 = mean(FactValueNumeric, na.rm = TRUE, round(2))) %>% 
  pull(avg_rate_2019)

# Rural average concentration rate
summary_info$avg_concentrations_rural <- concentrations_particulate_matter %>% 
  filter(Dim1 == "Rural") %>% 
  summarise(avg_rate_2019 = mean(FactValueNumeric, na.rm = TRUE, round(2))) %>% 
  pull(avg_rate_2019)

## Region has the highest concentrations matter (Value 5)
summary_info$Region_highest_concentrations <- concentrations_particulate_matter %>%
  group_by(ParentLocation) %>% 
  summarise(avg_rate = mean(FactValueNumeric, na.rm = TRUE, round(2))) %>% 
  filter(avg_rate == max(avg_rate)) %>% 
  pull(ParentLocation)

## Region has the lowest concentrations matter (Value 6)
summary_info$Region_lowest_concentrations <- concentrations_particulate_matter %>%
  group_by(ParentLocation) %>% 
  summarise(avg_rate = mean(FactValueNumeric, na.rm = TRUE, round(2))) %>% 
  filter(avg_rate == min(avg_rate)) %>% 
  pull(ParentLocation)
