
library(shiny)
library(dplyr)
library(ggplot2)
library(plotly) #Interactive ggplots
library(leaflet) #Maps

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
                  multiple = TRUE)
      
      
      
    ),
    
    # Plots based on user selection(s)
    mainPanel(
      
  #--------------------------------------------
  # Status for each Service Request
  #-------------------------------------------
      h1("Service RequestsStatus"),
      
      #Practice reproducible text
      # textOutput("selected_var"),
      
      #Bar graph of Service Requests' status
      plotlyOutput("sr_status"),
      
      h1("Service Requests Over Time"),
      plotlyOutput("sr_over_time")
  
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
      filter(neighborhood %in% input$neighborhood_choice)
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
        title = "Total Service Requests in 2020"
      )
  })
  
  #Bar graph of total requests per neighborhood
  #----
  #----
  #----
  #----
  
  #Time graph for each Service Requests
  output$sr_over_time <- renderPlotly({
    graph <- ggplot(data(), aes(createddate, color = srtype))
    graph + geom_freqpoly() +
      xlab("Date") +
      ylab("Service Request") +
      labs(
        title = "Service Requests over time in 2020"
      )
    
  })

  
  
  
}


#------------------------------------------------------------------
# Run the application 
#------------------------------------------------------------------
shinyApp(ui = ui, server = server)


