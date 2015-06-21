output$main_analyse_lda <- renderUI({
  mainPanel(id="analysetabs", 
    tabsetPanel(
      tabPanel("Fit", uiOutput("analyse_lda_fit")),
      tabPanel("Topics", uiOutput("analyse_lda_topics")),
      tabPanel("Vis", uiOutput("analyse_lda_vis"))
    )
  )
})

