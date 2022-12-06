library(shiny)
library(plotly)
library(tidyverse)
library(ggplot2)

# define ui and server
source("server.R")
source("ui.R")

# Run the application 
shinyApp(ui = ui, server = server)

rsconnect::setAccountInfo(name='shuneng',
                          token='63E35A33676C4DA55375E8D4801AB7B5',
                          secret='<SECRET>')