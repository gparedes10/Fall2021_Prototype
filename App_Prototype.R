
library(shiny)
library(dplyr)
library(ggplot2)
library(plotly) #Interactive ggplots
library(leaflet) #Maps




#Call Data Script
source('Prototype_Data.R')


#------------------------------------------------------------------
# Define UI for application 
#------------------------------------------------------------------
ui <- fluidPage(

  # App Tittle
  headerPanel('311 Service Request Data 2020'),
  
  h2("Total Service Requests"), #Section Title
  
  #Service Requests bar chart
  #ggplotly(p),
  
  #----Service Requests over time graphs----
  h2("Service Requests Over Time"), #Section Title
  
  #Total requests over time
  ggplotly(total_sr_over_time),
  
  #Requests over time
  ggplotly(sr_over_time),
  
  #----Service Requests status graphs----
  h2("Service Requests' Status"), #Section Title
  
  #Request Status bar chart
  ggplotly(total_status),
  
  #Status per Request
  ggplotly(request_status),
  
  
  #----Neighborhood Requests status graphs----
  #ggplotly(neighborhood_total)
  
  
  
  
  
  
)


#------------------------------------------------------------------
# Define server logic
#------------------------------------------------------------------
server <- function(input, output) {


  #Service Request bar chart
  # p <- sr_311Data %>%
  #   count(srtype, sort = TRUE) %>%
  #   ggplot() +
  #   geom_col(aes(x = reorder(srtype, n), y = n, fill = srtype)) +
  #   coord_flip() +
  #   xlab("Request Type") +
  #   ylab("Total Requests") +
  #   labs(
  #     title = "Service Requests"
  #   )
    
  #Time graph for total number of requests
  total_sr_over_time <- sr_311Data %>%
    ggplot() +
    geom_freqpoly(aes(x = createddate)) +
    xlab("Date") +
    ylab("Total Service Requests") +
    labs(
      title = "Service Requests over time in 2020"
    )
  
  #Time graph for each Service Requests
  sr_over_time <- sr_311Data %>%
    ggplot() +
    geom_freqpoly(aes(x = createddate, color = srtype)) +
    xlab("Date") +
    ylab("Service Requests") +
    labs(
      title = "Service Requests over time in 2020" 
    )
  
  #Total Requests status bar chart
  total_status <- sr_311Data %>%
    count(srstatus, sort = TRUE) %>%
    ggplot() +
    geom_col(aes(x = reorder(srstatus, -n), y = n, fill = srstatus))
  
  #Status for each Request
  request_status <- sr_311Data %>%
    ggplot() +
    geom_bar(aes(x = srtype, fill = srstatus)) +
    coord_flip()
  
  #Requests per Neighborhood
  # neighborhood_total <- sr_311Data %>%
  #   ggplot() +
  #   geom_bar(aes(x = neighborhood, fill = srstatus)) +
  #   coord_flip()
  

    
  
}


#------------------------------------------------------------------
# Run the application 
#------------------------------------------------------------------
shinyApp(ui = ui, server = server)


