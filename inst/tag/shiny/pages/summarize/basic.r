output$summarize_corpus <- renderUI({
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
        <td>", tm::nTerms(localstate$tdm), "</td>
      </tr>
      <tr>
        <td>Documents:</td>
        <td>", tm::nDocs(localstate$tdm), "</td>
      </tr>
      <tr>
        <td>Memory Usage:</td>
        <td>", memuse::swap.prefix(memuse::swap.names(memuse::object.size(localstate$corpus))), "</td>
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
        checkboxInput("basic_termsearch_checkbox_findclosest", "Find closest match?", value=FALSE),
        tags$textarea(id="summarize_termsearchbox", rows=1, cols=10, ""),
        render_helpfile("Term Search", "summarize/basic_termsearch.md")
      ),
      mainPanel(
        uiOutput("tabs_search")
      )
    )
  )
})



output$tabs_search <- renderUI({
  if (input$summarize_termsearchbox == "")
    return("")
  
  term <- input$summarize_termsearchbox
  
  if (input$basic_termsearch_checkbox_findclosest)
    term <- find_closest_word(term, names(localstate$wordcount_table))$word
  
  freq <- localstate$wordcount_table[term]
  
  if (is.na(freq))
    HTML("Term not found! <br><br> You may need to transform the data first (stem, lowercase, etc.).  See the Data--Transform tab.")
  else
    paste0("\"", term, "\" occurs ", freq, " times in the corpus.")
})

