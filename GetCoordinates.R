# Code downloaded from http://stackoverflow.com/questions/28680992/geocode-batch-addresses-in-r-with-open-mapquestapi on 22 March 2016

#This code takes in a list of addresses as well as your API key.  
#It geocodes the addresses - i.e., it then finds the latitudes and longitudes of all 
#the addresses.  It's mostly accurate, but you should always double-check on a map.

# #Example
# addresses = c("1221 2nd Ave SW Rugby ND 58368","Wadena MN", "Dilworth MN")
# ApiKey = "get your own key from https://developer.mapquest.com/"
# geocodedData = geocodeBatch_attempt(addresses,yourApiKey)
# View(geocodedData)
#setwd("/Users/joehendrickson/Documents/R Working Directory")
#setwd("/Users/joehendrickson/Documents/Concordia/Senior/Operations Research/Moorhead Snow Piles")

addresses = read.csv(file="CDSAddresses.csv",header=FALSE,stringsAsFactors = FALSE)
ApiKey = "mPnhPWYa8kPw0cdO6MeHMlSEE4lNWgnf"
addresses = addresses[,1]

#Import RCurl and rjson packages
library("RCurl")
library("rjson")


#Define a function "geocodeBatch_attempt" that converts addresses to coordinates

geocodeBatch_attempt <- function(address, yourApiKey) {
  #URL for batch requests
  URL=paste("http://open.mapquestapi.com/geocoding/v1/batch?key=", yourApiKey, "&location=", paste(address,collapse="&location="),sep = "") 
  
  URL <- gsub(" ", "+", URL)
  
  data<-getURL(URL)
  data <- fromJSON(data)
  
  p<-sapply(data$results,function(x){
    if(length(x$locations)==0){
      c(NA,NA)
    } else{
      c(x$locations[[1]]$displayLatLng$lat, x$locations[[1]]$displayLatLng$lng)   
    }})
  return(t(p))
}

geocodeBatch_attempt(addresses,ApiKey)

#write the coordinates to a CSV file
write.csv(geocodeBatch_attempt(addresses,ApiKey),"CDSCoordinates.csv")
