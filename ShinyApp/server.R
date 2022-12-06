#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(tidyverse)
library(plotly)


# All Three data
pollution_df <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-4-section-aa/main/data/Concentrations%20of%20fine%20particulate%20matter.csv")
mortality <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-4-section-aa/main/data/Mortality%20rate%20attributed%20to%20household%20and%20ambient%20air%20pollution.csv")
clean_fuels <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-4-section-aa/main/data/Household%20air%20pollution%20data.csv")


# -------------------------Map data Wrangling----------------#
new_pollution <- pollution_df %>% 
  select(Location, Dim1, FactValueNumeric) %>% 
  rename(region = Location) %>% 
  filter(Dim1 != "Total") %>% 
  filter(Dim1 != "Towns") %>% 
  filter(Dim1 != "Cities")

new_pollution[new_pollution == "United States of America"] <- "USA"

world_shape <- map_data("world") %>% 
  left_join(new_pollution, by = "region") %>% 
  replace(is.na(.), 0) %>% 
  filter(Dim1 != 0)

# ----------------------END MAP Wrangling-------------------#

# ------------ data Wrangling clean_fuels bar chart ----------
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

# ------------End data Wrangling clean_fuels bar chart---------

# ----------- data wrangling mortality scatter plot -----------

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
  filter(Period == 2019) %>% 
  filter(Dim1 == "Both sexes")

mortality_colnames <- c("Region", "Country", "Year", "Sex", "Illness_Type","Mean_Death_Rate_per100k", "Low_Death_Rate", "High_Death_Rate", "Death_Rate_Range")
colnames(world_mortality) <- mortality_colnames

# ------------- End data wrangling mortality scatter plot-------


shinyServer(function(input, output) {

# ----------------------Map Mapping---------------------# 
output$map <- renderPlotly({
    
    validate(
      need(input$urban_rural, "")
    )
    
    world_plot <- world_shape %>% 
      filter(Dim1 %in% input$urban_rural)

    map <- ggplot(world_plot) +  
      geom_polygon(mapping = aes(x = long, 
                                 y = lat, 
                                 group = group, 
                                 fill = FactValueNumeric), 
                   color = "white", 
                   size = .1) +
      coord_map() +
      scale_fill_continuous(low = "#132B43", high = "Red") + labs(fill = "Levels of PM2.5") +
      ggtitle("World Concentrations of fine particulate matter (PM2.5)") + theme_bw() +
      theme(
        axis.line = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        axis.title = element_blank(),
        plot.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank()
      )
    
    plot <- ggplotly(map)
    return(plot)
  })
  
# ------------------------ End Mapping ------------------ # 

# ------------------------ scatter plot ------------------#
output$scatterplotly <- renderPlotly({
  # generate table based on input$illness_choice from ui.R
  plot_ly(
    data = data.frame(left_join(world_clean_fuels, data.frame(filter(world_mortality, Illness_Type %in% input$illness_choice)), by = c("Country"))),
    x = ~Mean_Percent_Reliance,
    y = ~Mean_Death_Rate_per100k,
    type = "scatter",
    mode = "markers"
  ) %>% 
    layout(
      title = paste0("Household Reliance on Clean Fuels and Prevalence of ",input$illness_choice),
      xaxis = list(title = "Reliance (%)"),
      yaxis = list(title = paste0("Death Rate Attributable to ",input$illness_choice," per 100,000"))
    )
})

# -----------------------End scatter plot ------------------#

# ------------------------ Bar plot ------------------------#
output$barplotly <- renderPlotly({
  plot_ly(
    data = data.frame(world_clean_fuels %>% 
                        group_by(Region, Area_Type) %>% 
                        summarize(Region_Mean_Reliance = mean(Mean_Percent_Reliance)) %>% 
                        filter(Region %in% input$region_choice) %>% 
                        filter(Area_Type != "Total")),
    x = ~Area_Type,
    y = ~Region_Mean_Reliance,
    type = "bar"
  )%>% 
    layout(
      title = paste0("Rural vs. Urban Clean Fuel Usage in ",input$region_choice),
      xaxis = list(title = "Area Type"),
      yaxis = list(title = paste0("Average Clean Fuel Usage (%)"))
    )
})

# ------------------------ End Bar plot --------------------#

})




