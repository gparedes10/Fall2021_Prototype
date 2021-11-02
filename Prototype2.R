
library(shiny)
library(dplyr)
library(ggplot2)
library(plotly) #Interactive ggplots
library(leaflet) #Maps
library(mapbaltimore) #Get neighborhood outlines

#Call Data. Only need to run it once for the app to work, hence it is located up here.
source('Prototype_Data.R')

#------------------------------------------------------------------
# Define UI for application 
#------------------------------------------------------------------
ui <- fluidPage(
  
  # Application title
  titlePanel("Prototype Application - Reactive plots"),
  
  sidebarLayout(
    
    # Sidebar on the left
    sidebarPanel(
      
      #Add Select Neighborhood Menu
      selectInput(inputId = "neighborhood_choice",
                  label = "Choose a Neighboor",
                  "Names",
                  multiple = TRUE),
      
      #Drop down menu with Service Requests options.
      selectInput(inputId = "service_request_choice", 
                  label = "Choose a Service Request",
                  "Names",
                  multiple = TRUE),
      
      #Date range menu
      dateRangeInput(inputId = "daterange",
                     label = "Select a date range",
                     start = "2020-01-01",
                     end = "2020-12-31",
                     min = "2020-01-01",
                     max = "2020-12-31")
    ),
    
    # Plots based on user selection(s)
    mainPanel(
      
  #--------------------------------------------
  # Status for each Service Request
  #-------------------------------------------
      h1("Service Requests Status"),
  
      #Requests per neighborhood
      plotlyOutput("tota_requests"),
  
      #Total Service Request Status graph
      plotlyOutput("sr_status"),
      
      h1("Service Requests Over Time"),
      plotlyOutput("sr_over_time"),
  
      h1("Service Requests Map"),
      leafletOutput("sr_map", width = "50%", height = "500px")
  
  #Practice reproducible text
  # textOutput("selected_var")
  
    )
  )
 
)


#------------------------------------------------------------------
# Define server logic
#------------------------------------------------------------------
server <- function(input, output, session) {


  # output$selected_var <- renderText({
  #   paste("Your selected Service Request is: ", input$service_request_choice)
  #   
  # })
    
  #Filter data based on user selection
  data <- reactive({
    req(input$service_request_choice, input$neighborhood_choice)
    
    filtered_data <- sr_311Data %>%
      filter(srtype %in% input$service_request_choice) %>%
      filter(neighborhood %in% input$neighborhood_choice) %>%
      filter(createddate >= input$daterange[1] & createddate <= input$daterange[2])
  })
  
  #Create drop-down menus automatically
  observe({
    updateSelectInput(session, "service_request_choice", choices = unique(sr_311Data$srtype))
    
    updateSelectInput(session, "neighborhood_choice", choices = sort(unique(sr_311Data$neighborhood)))
  })
  

  #Service Request status based on user selection
  output$sr_status <- renderPlotly({
    g <- ggplot(data(), aes(x = srstatus, fill = srtype))
    g + geom_bar(position="dodge") + #Makes bars appear next to each other
      xlab("Service Request Type") +
      ylab("Total Requests") +
      labs(
        title = "Total Service Request Status"
      )
  })
  
  #Bar graph of total requests per neighborhood
  output$tota_requests <- renderPlotly({
    totalSR <- ggplot(data(), aes(x = srtype, fill = neighborhood))
    totalSR + geom_bar(position = "dodge") +
    xlab("Service Request Type") +
      ylab("Requests per Neighborhood") +
      labs(
        title = "Service Requests per Neighborhood"
      )
  })
  
  
  #Time graph for each Service Requests
  output$sr_over_time <- renderPlotly({
    graph <- ggplot(data(), aes(createddate, color = srtype))
    graph + geom_freqpoly() +
      xlab("Date") +
      ylab("Service Request") +
      labs(
        title = " Total Service Requests Over Time in 2020"
      )
  })
  
  pal <- colorFactor(c("navy"), domain = c("HCD-Sanitation Property"))
  
  #Service Requests Map
  output$sr_map <- renderLeaflet({
    leaflet(data()) %>%
      #base map layer
      setView(lng = -76.6122, lat = 39.2904, zoom = 12) %>%
      addTiles() %>%
      addCircleMarkers()
    
  })

  
  
  
}


#------------------------------------------------------------------
# Run the application 
#------------------------------------------------------------------
shinyApp(ui = ui, server = server)


