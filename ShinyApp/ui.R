#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(shinythemes)


# --------------Page 1 Introduction ---------------
intro_panel <- tabPanel(
  "Introduction",
  h5("Clean Fuel Usage, Pollution, and Illness Around the World")
)

# --------------End Page 1 Introduction -----------

# ------------------------Page 2 Map-----------------
map_content <- mainPanel(
  plotlyOutput(outputId = "map"),
  h4(strong("Map Analysis:")),
  p("From the interactive map, we can see the level of environmental pollution around the world. 
    This world map shows us that the PM2.5 level is higher in Asia, followed by Africa. 
    From the graph, we are able to see that the PM2.5 level in North America is lower compared to other continents, but we cannot exclude that demographic reasons cause it.")
)

map_control <- sidebarPanel(
  selectInput(inputId = "urban_rural",
              label = "Please select urban-rural",
              choices = unique(world_shape$Dim1),
              selected = "Rural"),
  img(src = "https://raw.githubusercontent.com/info201a-au2022/project-group-4-section-aa/main/source/patient.png", width = 355, length = 300)
)


map_panel <- tabPanel(
  "World Levels of Pollution",
  sidebarLayout(
    map_control,
    map_content
  )
)
# -------------------End Page 2 Map--------------------

# ----------------- Page 3 Scatter Plot ---------------
scatter_content <- mainPanel(
  plotlyOutput("scatterplotly"),
  h4(strong("Scatterplot Analysis:")),
  p("From this interactive chart, we can see that overall, there does not seem to be a strong correlation between household clean fuel usage 
  and the frequency of air-pollution related deaths. However, it is interesting to note that some of the highest frequencies of death from 
  these causes occur in places with an average reliance on clean fuels of less than 80%. When considering the different specific types of illnesses, 
  it again appears that there is no clear correlation, except in the case of lower respiratory infections. With these infections, it appears that 
  there is a higher frequency of death with lower clean fuel reliance.")
)

scatter_control <- sidebarPanel(
  selectInput("illness_choice",
              "Choose an illness",
              choices = unique(world_mortality$Illness_Type),
              selected = "Total")
)

scatter_panel <- tabPanel(
  "Pollution-Related Illness",
  sidebarLayout(
    scatter_content,
    scatter_control
  )
)
# ---------------- End Page 3 Scatter plot------------------

# ----------------- Page 4 Bar Plot ---------------
bar_content <- mainPanel(
  plotlyOutput("barplotly"),
  h4(strong("Bar Chart Analysis:")),
  p("Here we can see that clean fuel reliance is on average higher in urban areas than rural areas in every region of the world. 
  Urban areas of these regions tend to have a clean fuel reliance percentage of over 70%, but there is an exception in Africa, 
  which shows one of around 36%, and a much lower reliance in rural areas, of only about 14%.")
  
)

bar_control <- sidebarPanel(
  selectInput("region_choice",
              "Choose a region",
              choices = unique(world_clean_fuels$Region),
              selected = "Africa")
)

bar_panel <- tabPanel(
  "Rural vs. Urban",
  sidebarLayout(
    bar_content,
    bar_control
  )
)
# ------------------- End Page 4 Bar plot -----------

ui <- navbarPage(
  theme = shinythemes::shinytheme("paper"),
  "Air Pollution Analysis",
  intro_panel,
  map_panel,
  scatter_panel,
  bar_panel
)
