output$main_data <- renderUI({
  mainPanel(id="datatabs", 
    tabsetPanel(
      tabPanel("Manage", htmlOutput("data_manage")),
      tabPanel("Transform", htmlOutput("data_transform"))
    )
  )
})

