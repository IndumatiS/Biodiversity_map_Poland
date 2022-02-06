#Libraries
library(shiny)
library(leaflet)
library(ggplot2)
library(dplyr)
library(shinydashboard)
library(leaflet)
library(DT)
library(shinyalert)

#Load the data
Poland_data<-read.csv("./data/Poland_data.csv")
Poland_data$eventDate<-(strptime(Poland_data$eventDate, format = "%Y-%m-%d"))
Poland_data$eventDate<-as.POSIXct(Poland_data$eventDate, format = "%d-%m-%Y")

#-----------Rshiny------------------------

#-----------UI trial--------------------
header<-dashboardHeader(title="Poland biodiversity map")

body<-dashboardBody(
    fluidRow(
        column(width = 9,
               box(width = NULL, solidHeader = TRUE,
                   tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
                   leafletOutput("map")
               ),
               
        ),
        column(width=3,
               box(width=NULL,
                   selectInput("Select_animals", "How do you wish to select animals?", choice = c("Vernacular name", "Scientific name")),
                   selectizeInput("Animal_name", "Select name", choice = NULL),
                   actionButton("Submit_button", "Submit")
                   #uiOutput("moreControls"),
                   
               ),
               box(width=NULL,
                   #plotOutput("graph") ,
                   plotOutput("graph1")
               )
               
        )
    )
)

ui<-dashboardPage(
    header,
    dashboardSidebar(disable = TRUE),
    body
)


server <- function(input, output, session) {
    
    #Initilise the values
    values <- reactiveValues()
    values$vernacular <- "Common Crane"
    values$scientific <- "Grus grus"
    
    #Observe event when animal name changes
    observeEvent(input$Submit_button,
                 {
                     if(input$Select_animals== "Vernacular name"){
                         values$vernacular <- input$Animal_name
                     }
                     
                     else{
                         values$scientific <- input$Animal_name
                     }
                     
                     
                 })
    
    #Update Selectize Input
        observe({
            req(input$Select_animals)
            if(input$Select_animals== "Vernacular name"){
                updateSelectizeInput(session,"Animal_name", selected = "Common Crane",choices = unique(Poland_data$vernacularName, server = TRUE))
            }
            else {
                updateSelectizeInput(session,"Animal_name", selected = "Grus grus",choices = unique(Poland_data$scientificName, server = TRUE))
            }
            
        })
    
        
    #Filter out the data based on the vernacular name input
    Poland_data_vernacular<-reactive({
        a <- Poland_data%>% 
            filter(.,vernacularName== values$vernacular)
        
            if(is.na(a$longitudeDecimal) | is.na(a$latitudeDecimal)){
                a <- Poland_data%>% 
                    filter(.,vernacularName== "Common Crane")
                updateSelectizeInput(session,"Animal_name", selected = "Common Crane",choices = unique(Poland_data$vernacularName, server = TRUE))
                shinyalert("This animal has no data associated with it. Please select another animal", "Reverting to Common Crane selection", type = "error")
                values$vernacular <- "Common Crane"
            }
    
        return(a)
    })
    
    #Filter out the data based on the scientific name input
    Poland_data_scientific<-reactive({
        #req(input$Animal_name)
        a <- Poland_data%>% 
            filter(.,scientificName== values$scientific)
        if(is.na(a$longitudeDecimal) | is.na(a$latitudeDecimal)){
            a <- Poland_data%>% 
                filter(.,vernacularName== "Grus grus")
            updateSelectizeInput(session,"Animal_name", selected = "Grus grus",choices = unique(Poland_data$scientificName, server = TRUE))
            shinyalert("This animal has no data associated with it. Please select another animal", "Reverting to Grus grus selection", type = "warning")
            values$scientific <- "Grus grus"
        }
        return(a)
    })
    
    #Create base map
    map_reactive <- reactive({
        req(input$Select_animals)
        
        #Condition-is the selection through vernacular name or scientific name?
        if(input$Select_animals== "Vernacular name"){
            map<-Poland_data_vernacular()%>% 
                leaflet() %>%
                addTiles() %>%
                addMarkers(lng= ~longitudeDecimal, lat=~latitudeDecimal, 
                           popup = ~paste(vernacularName, scientificName, sep = '<br/>'))
                return(map)
        }
        
        else {
            map<-Poland_data_scientific()%>% 
                leaflet() %>%
                addTiles() %>%
                addMarkers(lng= ~longitudeDecimal, lat=~latitudeDecimal, 
                           popup = ~paste(vernacularName, scientificName, sep = '<br/>'))
                return(map)
            
        }
            
    })
    
    # Call the reactive map of the world to render on the screen
    output$map <- renderLeaflet({
        map_reactive()
    })
    
    #Create reactive graph to plot counts vs time 
    graph_reactive<-reactive({
        req(input$Select_animals)
        if(input$Select_animals== "Vernacular name"){
            graph1<-Poland_data_vernacular()%>%
                ggplot(aes(x=eventDate, y=individualCount))+
                geom_point()+
                xlab("Timeline (years)") +
                ylab ("Occurance") +
                ggtitle(paste("Distribution of", values$vernacular))
            return(graph1)
        }
        
        else {
            graph1<-Poland_data_scientific()%>%
                ggplot(aes(x=eventDate, y=individualCount))+
                geom_point()+
                xlab("Timeline (years)") +
                ylab ("Occurance")+
                ggtitle(paste("Distribution of", values$scientific))
            return(graph1)
        }
    })
    
    #Render the plot
    output$graph1<-renderPlot({
        graph_reactive()
    })
    
}

shinyApp(ui, server)
