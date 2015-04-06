output$main_summarize_basic <- renderUI({
  list(
      mainPanel(id="summarizetabs_basic", 
        tabsetPanel(
          tabPanel("Corpus Summary", uiOutput("summarize_corpus")),
          tabPanel("Term Search", uiOutput("summarize_termsearch"))
        )
      )
    )
})

output$summarize_corpus <- renderUI({
  tdm <- get("tdm", envir=session)
  HTML(
    paste("
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
  )
})

