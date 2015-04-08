output$summarize_corpus <- renderUI({
  tdm <- get("tdm", envir=session)
  html <- paste("
    <table>
      <tr>
        <td>Total Letters:</td>
        <td>", print('FIXME'), "</td>
      </tr>
      <tr>
        <td>Total Words:</td>
        <td>", print('FIXME'), "</td>
      </tr>
      <tr>
        <td>Distinct Terms:</td>
        <td>", tm::nTerms(tdm), "</td>
      </tr>
      <tr>
        <td>Documents:</td>
        <td>", tm::nDocs(tdm), "</td>
      </tr>
      <tr>
        <td>Memory Usage:</td>
        <td>", memuse::swap.prefix(memuse::swap.names(memuse::object.size(corpus))), "</td>
      </tr>
    </table> 
  ")
  verticalLayout(
    HTML(html),
    render_helpfile("Corpus Summary", "summarize/basic_summary.md")
  )
})



output$summarize_termsearch <- renderUI({
  list(
    sidebarLayout(
      sidebarPanel(
        h5("Term Frequency"),
        tags$textarea(id="summarize_termsearchbox", rows=1, cols=60, ""),
        actionButton("button_process", "Process"),
        render_helpfile("Term Search", "summarize/basic_termsearch.md")
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

