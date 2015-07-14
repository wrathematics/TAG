output$main_analyse_lda <- renderUI({
  mainPanel(id="analysetabs", 
    tabsetPanel(
      tabPanel("Fit", uiOutput("analyse_lda_fit")),
      tabPanel("Topics", uiOutput("analyse_lda_topics")),
      tabPanel("Vis", uiOutput("analyse_lda_vis"))
    )
  )
})



output$main_analyse_ngram <- renderUI({
  mainPanel(id="analysetabs", 
    tabsetPanel(
      tabPanel("Fit", uiOutput("analyse_ngram_fit")),
#      tabPanel("Phrase Table", uiOutput("analyse_ngram_phrasetable")),
      tabPanel("Babble", uiOutput("analyse_ngram_babble"))
    )
  )
})

