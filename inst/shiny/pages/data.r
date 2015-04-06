output$main_data <- renderUI({
  list(
      mainPanel(id="datatabs", 
        tabsetPanel(
#          tabPanel("Manage", htmlOutput("data_manage")),
          tabPanel("Transform", htmlOutput("data_transform"))
        )
      )
    )
})

output$tabs_data <- renderUI({
  changed <- buttonfix(session, input$button_process)
  
  if (changed$button_process)
    "asfd"
  else
    "qwer"
})


