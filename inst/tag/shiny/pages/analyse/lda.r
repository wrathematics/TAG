output$analyse_lda_fit <- renderUI(
  sidebarLayout(
    sidebarPanel(
      h5("Latent Dirichlet Allocation"),
      sliderInput("lda_ntopics", "Number of Topics", min=1, max=20, value=3),
      selectizeInput("lda_method", "Method", c("Gibbs", "VEM"), "Gibbs"),
      actionButton("lda_button_fit", "Fit"),
      render_helpfile("LDA Fit", "analyse/lda_fit.md")
    ),
    mainPanel(
      textOutput("analyse_lda_fit_")
    )
  )
)

output$analyse_lda_fit_ <- renderText({
  temp <- eventReactive(input$lda_button_fit, {
    withProgress(message='Fitting the model...', value=0,
    {
      runtime <- system.time({
        incProgress(0, message="Building to dtm...")
        DTM <- qdap::as.dtm(localstate$corpus)
        
        incProgress(1/2, message="Fitting the model...")
        localstate$lda_mdl <- topicmodels::LDA(DTM, k=input$lda_ntopics, method=input$lda_method)
        
        setProgress(1)
      })
    })
    
    paste("Fit a", input$lda_method, "LDA topic model in", round(runtime[3], roundlen), "seconds.")
  })
  
  temp()
})



output$analyse_lda_topics <- renderUI(
  sidebarLayout(
    sidebarPanel(
      h5("Latent Dirichlet Allocation"),
      sliderInput("lda_nterms", "Number of terms", min=5, max=50, value=10),
      render_helpfile("LDA Topics", "analyse/lda_topics.md")
    ),
    mainPanel(
      renderTable({
        if (!is.null(localstate$lda_mdl))
          topicmodels::terms(localstate$lda_mdl, input$lda_nterms)
        else
          stop("You must first fit a model in the 'Fit' tab!")
      })
    )
  )
)



output$analyse_lda_vis <- renderUI({
  sidebarLayout(
    sidebarPanel(
      h5("LDA Vis"),
      sliderInput("lda_vis_nterms", "Number of terms", min=5, max=50, value=10),
      render_helpfile("LDA Vis", "analyse/lda_vis.md")
    ),
    mainPanel(
      LDAvis::visOutput('analyse_lda_vis_')
    )
  )
})


output$analyse_lda_vis_ <- LDAvis::renderVis({
  withProgress(message='Preparing the data...', value=0,
  {
    post <- topicmodels::posterior(localstate$lda_mdl)
    setProgress(1/3)
    
    phi <- post$terms
    theta <- post$topics
    doc.length <- sapply(localstate$corpus, function(i) length(i$content))
    vocab <- localstate$lda_mdl@terms
    term.frequency <- localstate$wordcount_table[vocab]
    
    setProgress(1/2, message="Visualizing the model...")
    LDAvis::createJSON(phi, theta, doc.length, vocab, term.frequency, R=input$lda_vis_nterms)
  })
})

