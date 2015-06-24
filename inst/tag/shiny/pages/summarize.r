output$main_summarize_basic <- renderUI({
  mainPanel(id="summarizetabs_basic", 
    tabsetPanel(
      tabPanel("Corpus Summary", uiOutput("summarize_corpus")),
      tabPanel("Term Search", uiOutput("summarize_termsearch"))
    )
  )
})



output$main_summarize_plot <- renderUI({
  mainPanel(id="summarizetabs_plot", 
    tabsetPanel(
      tabPanel("Top 10", uiOutput("summarize_top10")),
      tabPanel("Correlation", uiOutput("summarize_wordcorr")),
      tabPanel("Dispersion", uiOutput("summarize_dispersionplot")),
      tabPanel("Zipf Plot", uiOutput("summarize_zipf")),
      tabPanel("Wordcloud", uiOutput("summarize_wordcloud"))
    )
  )
})

