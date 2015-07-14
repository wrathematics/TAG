output$main_explore <- renderUI({
  mainPanel(id="exploretabs_plot", 
    tabsetPanel(
      tabPanel("Summary", 
        sliderInput("explore_corpus_maxwordlen", "Maximum Word Length", min=1, max=128, value=15),
        uiOutput("explore_summary")
      ),
      tabPanel("Search", uiOutput("explore_termsearch")),
      tabPanel("Top 10", uiOutput("explore_top10")),
#      tabPanel("Correlation", uiOutput("explore_wordcorr")),
      tabPanel("Dispersion", uiOutput("explore_dispersionplot")),
      tabPanel("Zipf", uiOutput("explore_zipf")),
      tabPanel("Wordcloud", uiOutput("explore_wordcloud"))
    )
  )
})



show_plotnote_message <- renderUI({
  must_have("corpus", silent=TRUE)
  plotnote
})

