
library(shiny)
library(dplyr)
library(dygraphs) #Time graphs
library(ggplot2)
library(plotly) #Interactive ggplots
library(leaflet) #Maps
library(lubridate) #Fix date formatting

#Call Data Script
source('Data_Call.R')


#---------------------------------------------------------------
#Interactive Bar Chart
#---------------------------------------------------------------
p <- trash_311Data %>%
  count(srtype, sort = TRUE) %>%
  ggplot() +
  geom_col (aes(x = reorder(srtype, n), y = n, fill = srtype)) +
  coord_flip() +
  xlab("Request Type") +
  ylab("Total Requests") +
  labs(
    title = "Service Requests"
  )


#changes date format to date
test_newFormat <- test_Data
test_newFormat$createddate <- date(test_newFormat$createddate)
test_newFormat$srtype <- as.factor(test_newFormat$srtype)


#Requests over time graph. 
test_newFormat %>%
  ggplot() +
  geom_freqpoly(aes(x = createddate, color = srtype)) 


# rea_citations %>%
#   ggplot() +
#   geom_freqpoly(aes(x = violation_date, color = description)) +
#   xlab("Date") +
#   ylab("Total Citations") +
#   labs(
#     title = glue::glue("Citations Over Time in {area_label}"),
#     color = "Citation Types"
#  )
#--------------------------------------------------------------------------------
# Application Interface
#--------------------------------------------------------------------------------
ui <- fluidPage(
    
    # App Tittle
    headerPanel('311 Service Request Data 2020'),
    
    #Bar graph
    ggplotly(p),
    
    #Service Requests Map
    leafletOutput("sr_map", width = "75%", height = "1000px")
    
    
)



#--------------------------------------------------------------------------------
# Application Server Stuff
#--------------------------------------------------------------------------------
server <- function(input, output) {
    
    
  #Service Requests Map
  output$sr_map <- renderLeaflet({
    leaflet() %>%
      #base map layer
      setView(lng = -76.6122, lat = 39.2904, zoom = 12) %>%
      addTiles() %>%
      #SR Type Layers
      addCircleMarkers(data = sanit_property, group = "HCD-Sanitation Property", color = sanit_property$srType) %>%
      addCircleMarkers(data = illegal_dumping, group = "HCD-Illegal Dumping", color = illegal_dumping$srType) %>%
      addCircleMarkers(data = dirty_alley, group = "SW-Dirty Alley", color = dirty_alley$srType) %>%
      addCircleMarkers(data = dirty_Street, group = "SW-Dirty Street", color = dirty_Street$srType) %>%
      addCircleMarkers(data = trash_can_concern, group = "SW-Municipal Trash Can Concern", color = trash_can_concern$srType) %>%
      addCircleMarkers(data = stolen_lost, group = "SW-Municipal Trash Can Stolen/Lost", color = stolen_lost$srType) %>%
      addCircleMarkers(data = trash_issue, group = "SW-Public (Corner) Trash Can Issue", color = trash_issue$srType) %>%
      addCircleMarkers(data = request_removal, group = "SW-Public (Corner) Trash Can Request/Removal", color = request_removal$srType) %>%
      addCircleMarkers(data = recycling_complain, group = "SW-Trash Can/Recycling Container Complaint", color = recycling_complain$srType) %>%
      addCircleMarkers(data = park_cans, group = "SW-Park Cans", color = park_cans$srType) %>%
      #Layer Controls
      addLayersControl(
        overlayGroups = c("HCD-Sanitation Property", 
                         "HCD-Illegal Dumping",
                         "SW-Dirty Street",
                         "SW-Dirty Alley" ,
                         "SW-Municipal Trash Can Concern",
                         "SW-Municipal Trash Can Stolen/Lost",
                         "SW-Public (Corner) Trash Can Issue",
                         "SW-Public (Corner) Trash Can Request/Removal",
                         "SW-Trash Can/Recycling Container Complaint",
                         "SW-Park Cans"),
        options = layersControlOptions(collapsed = TRUE),
      ) %>% 
      #Hide layers by default 
      hideGroup(c("HCD-Sanitation Property", 
                  "HCD-Illegal Dumping",
                  "SW-Dirty Street",
                  "SW-Dirty Alley",
                  "SW-Municipal Trash Can Concern",
                  "SW-Municipal Trash Can Stolen/Lost",
                  "SW-Public (Corner) Trash Can Issue",
                  "SW-Public (Corner) Trash Can Request/Removal",
                  "SW-Trash Can/Recycling Container Complaint",
                  "SW-Park Cans")) 
  })
  
  
  
  
} 

shinyApp(ui = ui, server = server)

