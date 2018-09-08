

#ui function
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Dynamic Filter Test App"),
  
#call selection boxes in the sidebar
  sidebarLayout(
    sidebarPanel(
       uiOutput("cutlist"),
       uiOutput("colorlist")
    ),
    
    #call the filtered data table in the main panel
    mainPanel(
      dataTableOutput("table")
    )
  )
))
