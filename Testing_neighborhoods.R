library(dplyr)
library(sf)
library(leaflet) #Maps

neighborhoods <- st_read("Neighborhoods.geojson")
source('Prototype_Data.R')

#creates labels for neighborhood names using html code
labels <- sprintf(
  "<strong>%s</strong>",
  neighborhoods$name
) %>% lapply(htmltools::HTML)

leaflet() %>%
  addTiles() %>%
  addPolygons(
    data = neighborhoods,
    color = "black",
    weight = 1.5,
    highlightOptions = highlightOptions(
      weight = 5,
      color = "black",
      fillOpacity = 0.5
    ),
    label = labels,
    labelOptions = labelOptions(
      style = list("font-weight" = "normal"),
      textsize = "15px",
      direction = "auto"
    )
  ) 
# %>%
#   addCircleMarkers(data = sr_311Data)
