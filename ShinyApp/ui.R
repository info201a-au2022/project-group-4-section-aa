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
  img(src = "https://raw.githubusercontent.com/info201a-au2022/project-group-4-section-aa/main/source/patient.png", width = 350, length = 300)
)


map_panel <- tabPanel(
  "Levels of PM2.5",
  sidebarLayout(
    map_control,
    map_content
  )
)
# -------------------End Page 2 Map--------------------

# ----------------- Page 3 Scatter Plot ---------------
scatter_content <- mainPanel(
  h5("Clean Fuel Usage in Households and Prevalence of Certain Illness"),
  plotlyOutput("scatterplotly")
)

scatter_control <- sidebarPanel(
  selectInput("illness_choice",
              "Choose an illness",
              choices = unique(world_mortality$Illness_Type),
              selected = "Total")
)

scatter_panel <- tabPanel(
  "Illness",
  sidebarLayout(
    scatter_content,
    scatter_control
  )
)
# ---------------- End Page 3 Scatter plot------------------

# ----------------- Page 4 Bar Plot ---------------
bar_content <- mainPanel(
  h5("Clean Fuel Usage in Rural vs. Urban Areas"),
  plotlyOutput("barplotly")
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
