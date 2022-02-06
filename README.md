# Appsilon_interview

The following set of files were created to produce an Rshiny application which showcases animal biodiversity across a certain period within Poland region. The data is derived from the Global Biodiversity Information Facility. The data was downloaded into the local folder, and was then filtered for keyword "Poland" using _grep_ within the Bash environment. 

The filtered file was then processed as follows:
- Added colnames
- Added appropriate class types to the columns
- Converted timestamp character to data objects using as.POSIXct()

The final processed file was then used to create the Rshiny application. 

Trial_script contains trial code to generate the Rshiny components. It also contains shinyTest to automate testing. 
app.R contains the actual UI and server components of the Rshiny app. The app has very basic features to render the locations of the selected species. The input asks to select species by their vernacular name/ scientific name. Upon selection the map then displays the locations in which they were spoted within Poland. The graph shows the timeline vs frequency of occurance of selected species of interest. 
If the user selects an animal which has no co-ordinate data associated, the app handles such error buy displaying the error message "This animal has no data associated with it. Please select another animal."
