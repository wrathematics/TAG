output$summarize_corpus <- renderUI({
  must_have("corpus")
  
  html <- paste("
    <table>
      <tr>
        <td>Total Letters:</td>
        <td>", sum(sapply(localstate$corpus, function(i) nchar(i$content))), "</td>
      </tr>
      <tr>
        <td>Total Words:</td>
        <td>", sum(sapply(localstate$corpus, function(i) wc(i$content))), "</td>
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
        textInput("summarize_termsearchbox", ""),
        render_helpfile("Term Search", "summarize/basic_termsearch.md")
      ),
      mainPanel(
        uiOutput("tabs_search")
      )
    )
  )
})



output$tabs_search <- renderUI({
  must_have("wordcount_table")
  
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

