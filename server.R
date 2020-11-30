#  raw = raw data
# data() = raw data filtered by user selection
# data = stores raw data filtered by cut only, used to filter color list by cut
# cutlist = list of cut types the user can select
# filt1 = cut filter argument based on if statement
# cutchoose = name of cut selection box for the ui (user input)
# colortlist = list of cut types the user can select
# colorchoose = name of color selection box for the ui (user input)
# filt2 = color filter argument based on if statement

#packages
library(dplyr)
library(ggplot2)
library(shiny)

#server function
shinyServer(function(input, output) {
  
  #raw data
  raw <- diamonds
  
  
  #dynmaic cut list "cutlist is called in the ui
  output$cutlist <- renderUI({
    
    #create list with unqiue values of cut column sort a-z
    
    cutlist <- sort(unique(as.vector(raw$cut)), decreasing = FALSE)
    #append list to inlcude 'All' and force value to top of list
    cutlist <- append(cutlist, "All", after =  0)
    
    #create ui selection list box
    selectizeInput("cutchoose", "Cut:", cutlist, multiple = TRUE, selected = "All")
    
  })
  
  
  #dynmaic color list "colorlist is called in the ui
  output$colorlist <- renderUI({
    
    #filter by user selection of the cut selection
    #only colors associated with the selected cuts will appear
    data <- dplyr::filter(raw, cut %in% input$cutchoose)
    
    #create list with unqiue values of colo column sort a-z
    colorlist <- sort(unique(as.vector(data$color)), decreasing = FALSE)
    #append list to inlcude 'All' and force value to top of list
    
    colorlist <- append(colorlist, "All", 0)
    #create ui selection list box
    selectizeInput("colorchoose", "color:", colorlist, multiple = TRUE, selected = "All")
    
  }) 
  
  #filter data based on user selections
  data <- reactive({
    
    #dont initialise inputs until they are needed
    req(input$colorchoose)
    req(input$cutchoose)
    
    #if all is selected, return everything else only return selected 
    if (input$cutchoose == "All") {
      
      #proxy for all -> no cut called @?><
      filt1 <- quote(cut != "@?><")
      
      
    } else {
      
      filt1 <- quote(cut %in% input$cutchoose)
      
    }
    
    #if all is selected, return everything else only return selected colors 
    if (input$colorchoose == "All") {
        
      #proxy for all -> no color called @?><
        filt2 <- quote(color != "@?><")
        
        
      } else {
        
        filt2 <- quote(color %in% input$colorchoose) 
        
      }
      
       #filter raw data by user selections
      raw %>%
        filter_(filt1) %>%
        filter_(filt2)
      
    })
    
  #create datatable
  output$table <- renderDataTable({
    
    #call dymaic data
    data()
      
    })
  
})