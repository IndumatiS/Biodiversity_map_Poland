
#General overview: 
  #Build a dashboard that main purpose is to visualize selected species 
  #observations on the map and how often it is observed.
#Original dataset is large and covers the whole world. 
#Please use only observations from Poland.
#Specific requirements:
  #1)Users should be able to search for species by their vernacularName and scientificName. 
  #2)Search field should return matching names and after selecting one result, 
  #the app displays its observations on the map. selectizeInput()
  #3)Users should be able to view a visaualization of a timeline when selected 
  #species were observed.

#Default view when no species is selected yet should make sense to the user. It shouldn’t be just an empty map and plot. Please decide what you will display.
#[Optional] Use your creativity and add features that you would like to see in this application.
setwd("~/Desktop/What-if Project/Appsilon_Interview_Assignments/biodiversity-data")
library(dplyr)
library(readr)
x<-read.csv("sample1.csv")
Poland_data<-Poland_data[,-1]
Poland_data_col<-colnames(read.csv("col_header.csv")[1,])

sample<-read.csv("sample1.csv")
x<-rbind(x,Poland_data_col)
colnames(x) <- as.character(Poland_data_col)


x[] <- lapply(x, readr::parse_guess) 
x$longitudeDecimal<-as.numeric(x$longitudeDecimal)
x$latitudeDecimal<-as.numeric(x$latitudeDecimal)
x$eventDate<-(strptime(x$eventDate, format = "%Y-%m-%d"))
x$eventDate<-as.POSIXct(x$eventDate, format = "%d-%m-%Y")
x$individualCount<-as.numeric(x$individualCount)

library(leaflet)
library(ggplot2)

Poland_data%>% 
  filter(.,vernacularName== 'Bastard Cabbage')%>%
  leaflet() %>%
  addTiles() %>%
  addMarkers(lng= ~longitudeDecimal, lat=~latitudeDecimal, 
             popup = ~paste(vernacularName, scientificName, sep = '<br/>'))  


Poland_data%>% 
  filter(.,family== "ACCENTORS_PRUNELLIDAE")%>%
  ggplot(aes(x=eventDate, y=individualCount))+
  geom_point()


#Test shiny app
install.packages("shinytest")
library(shinytest)
recordTest("~/workspace/Appsilon_Feb2022_Interview_Assignment")
