
trash_311Data <- read.csv("311_Customer_Service_Requests_2020.csv")

# Request types filter
request_types <- as.factor(
  c("HCD-Sanitation Property", 
    "HCD-Illegal Dumping",
    "SW-Dirty Street",
    "SW-Dirty Alley" ,
    "SW-Municipal Trash Can Concern",
    "SW-Municipal Trash Can Stolen/Lost",
    "SW-Public (Corner) Trash Can Issue",
    "SW-Public (Corner) Trash Can Request/Removal",
    "SW-Trash Can/Recycling Container Complaint",
    "SW-Park Cans"
  )
)

# Update dataset with only the needed requests
trash_311Data <- trash_311Data %>%
  filter(srtype %in% request_types)   

# Remove empty srtypes 
trash_311Data <- droplevels(trash_311Data)

#-----------------------------------------------------------
# SR Type SUbsets
sanit_property <- trash_311Data %>%
  filter(srtype == "HCD-Sanitation Property")

illegal_dumping <- trash_311Data %>%
  filter(srtype == "HCD-Illegal Dumping")

dirty_Street <- trash_311Data %>%
  filter(srtype == "SW-Dirty Street")

dirty_alley <- trash_311Data %>%
  filter(srtype == "SW-Dirty Alley")

trash_can_concern <- trash_311Data %>%
  filter(srtype == "SW-Municipal Trash Can Concern")

stolen_lost <- trash_311Data %>%
  filter(srtype == "SW-Municipal Trash Can Stolen/Lost")

trash_issue <- trash_311Data %>%
  filter(srtype == "SW-Public (Corner) Trash Can Issue")

request_removal <- trash_311Data %>%
  filter(srtype == "SW-Public (Corner) Trash Can Request/Removal")

recycling_complain <- trash_311Data %>%
  filter(srtype == "SW-Trash Can/Recycling Container Complaint")

park_cans <- trash_311Data %>%
  filter(srtype == "SW-Park Cans")

#-----------------------------------------------------------

#TEST DATA WITH 2 SERVICE REQUEST TYPES

test_srtypes <- as.factor(
  c("SW-Trash Can/Recycling Container Complaint",
    "SW-Park Cans"
  )
)

# Update dataset with only the needed requests
test_Data <- trash_311Data %>%
  filter(srtype %in% test_srtypes)   

# Remove empty srtypes 
test_Data <- droplevels(test_Data)
