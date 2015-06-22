output$main_data <- renderUI({
  mainPanel(id="datatabs", 
    tabsetPanel(
      tabPanel("Import", htmlOutput("data_import")),
      tabPanel("Filter", htmlOutput("data_filter")),
      tabPanel("Inspect", htmlOutput("data_inspect"))
    )
  )
})

