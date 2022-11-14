library(tidyverse)
library(stringr)
library(ggplot2)

concentrations_particulate_matter <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-4-section-aa/main/data/Concentrations%20of%20fine%20particulate%20matter.csv")

mortality <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-4-section-aa/main/data/Mortality%20rate%20attributed%20to%20household%20and%20ambient%20air%20pollution.csv")

clean_fuels <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-4-section-aa/main/data/Household%20air%20pollution%20data.csv")

world_concentrations <- concentrations_particulate_matter %>%
  select(ParentLocation,
         Location,
         Period,
         Dim1,
         FactValueNumeric,
         FactValueNumericLow,
         FactValueNumericHigh,
         Value)

concentration_colnames <- c("Region", "Country", "Year", "Area_Type","Mean_PM2.5_Level", "Low_PM2.5_Level", "High_PM2.5_Level", "PM2.5_Level_Range")

colnames(world_concentrations) <- concentration_colnames

concentrations_by_country_2019 <- world_concentrations %>%
  arrange(Country) %>%
  filter(Year == 2019)

world_clean_fuels <- clean_fuels %>%
  select(ParentLocation,
         Location,
         Period,
         Dim1,
         FactValueNumeric,
         FactValueNumericLow,
         FactValueNumericHigh,
         Value) %>%
  filter(Period == 2019)

cleanfuel_colnames <- c("Region", "Country", "Year", "Area_Type","Mean_Percent_Reliance", "Low_Reliance", "High_Reliance", "Reliance_Range")
colnames(world_clean_fuels) <- cleanfuel_colnames

cleanfuels_by_country_2019 <- world_clean_fuels %>%
  arrange(Country)

world_mortality <- mortality %>%
  filter(IndicatorCode == "SDGAIRBOD") %>%
  select(ParentLocation,
         Location,
         Period,
         Dim1,
         Dim2,
         FactValueNumeric,
         FactValueNumericLow,
         FactValueNumericHigh,
         Value) %>%
  filter(Period == 2019)

mortality_colnames <- c("Region", "Country", "Year", "Sex", "Illness_Type","Mean_Death_Rate_per100k", "Low_Death_Rate", "High_Death_Rate", "Death_Rate_Range")
colnames(world_mortality) <- mortality_colnames

mortality_by_country_2019 <- world_mortality %>%
  arrange(Country, Illness_Type)

air_quality_attributable_deaths <- mortality_by_country_2019 %>%
  filter(Sex == "Both sexes") %>%
  filter(Illness_Type == "Total")

conc_and_mortality <- left_join(air_quality_attributable_deaths, concentrations_by_country_2019)
ggplot(data = conc_and_mortality) +
  geom_point(mapping = aes(x = Mean_Death_Rate_per100k, y = Mean_PM2.5_Level))

reliance_and_mortality <- left_join(cleanfuels_by_country_2019, air_quality_attributable_deaths)
reliance_death_plot <- ggplot(data = reliance_and_mortality) +
  geom_point(mapping = aes(x = Mean_Percent_Reliance, y = Mean_Death_Rate_per100k)) +
  geom_smooth(mapping = aes(x = Mean_Percent_Reliance, y = Mean_Death_Rate_per100k)) +
  labs(
    title = "Household Reliance on Clean Fuels vs. Air Pollution-Attributable Deaths",
    x = "Reliance on Clean Fuels in Household (%)",
    y = "Deaths Attributed to Household and Ambient Air Pollution (per 100,000)"
  )