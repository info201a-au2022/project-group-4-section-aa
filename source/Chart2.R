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


world_shape <- map_data("world") %>%
  left_join(conc_and_cleanfuels, by = c("region" = "Country"))

concentration_map <- ggplot(world_shape) +
  geom_polygon(
    mapping = aes(x = long, y = lat, group = group, fill = Mean_PM2.5_Level),
    color = "white", # show state outlines
    size = .1        # thinly stroked
  ) +
  coord_map() + # use a map-based coordinate system
  scale_fill_continuous(low = "#132B43", high = "Red") +
  labs(
    title = "Concentrations of PM2.5 Particulate Matter Worldwide",
    fill = "PM2.5 Level (µg/m3)") +
  theme_bw() +
  theme(
    axis.line = element_blank(),        # remove axis lines
    axis.text = element_blank(),        # remove axis labels
    axis.ticks = element_blank(),       # remove axis ticks
    axis.title = element_blank(),       # remove axis titles
    plot.background = element_blank(),  # remove gray background
    panel.grid.major = element_blank(), # remove major grid lines
    panel.grid.minor = element_blank(), # remove minor grid lines
    panel.border = element_blank()      # remove border around plot
  )
