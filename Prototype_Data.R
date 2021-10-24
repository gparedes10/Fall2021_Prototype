
#------------------------------------------------------------------
#Filter 311 Dataset into the trash-related requests only
#------------------------------------------------------------------
sr_311Data <- read.csv("311_Customer_Service_Requests_2020.csv")

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
sr_311Data <- sr_311Data %>%
  filter(srtype %in% request_types)   

# Remove empty srtypes 
sr_311Data <- droplevels(sr_311Data)

#------------------------------------------------------------------
# Change date formats
#------------------------------------------------------------------
# Change date format for createddate, statusdate, duedate
# closedate, and lastactivitydate give an error while trying to change format to date (possible NA values) -
# character string is not in a standard unambiguous format

library(lubridate) #date formatting

sr_311Data$createddate <- date(sr_311Data$createddate)
sr_311Data$statusdate <- date(sr_311Data$statusdate)
sr_311Data$duedate <- date(sr_311Data$duedate)


#------------------------------------------------------------------
# Change srtype to factors
#------------------------------------------------------------------

#sr_311Data$srtype <- as.factor(sr_311Data$srtype)






