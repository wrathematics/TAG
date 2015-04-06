output$summarize_termsearch <- renderUI({
  list(
    sidebarLayout(
      sidebarPanel(
        h5("Term Frequency"),
        tags$textarea(id="summarize_termsearchbox", rows=1, cols=60, ""),
        actionButton("button_process", "Process")
      ),
    mainPanel(
      uiOutput("tabs_search")
      )
    )
  )
})

output$tabs_search <- renderUI({ ## FIXME broken
  button <- buttonfix(session, input$button_process)
  
  if (button$button_process)
  {
    wordcount_table <- get("wordcount_table", envir=session)
    
    term <- wordcount_table[input$summarize_termsearchbox]
    
    if (is.na(term))
      HTML("Term not found! <br><br> You may need to transform the data first (stem, lowercase, etc.).  See the Data--Transform tab.")
    else
      paste0("\"", input$summarize_termsearchbox, "\" occurs ", term, " times in the corpus.")
  }
  else
    ""
})
