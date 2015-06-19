output$analyse_lda_fit <- renderUI(
  sidebarLayout(
    sidebarPanel(
      h5("Latent Dirichlet Allocation"),
      sliderInput("lda_ntopics", "Number of Topics", min=1, max=20, value=3),
      selectizeInput("lda_method", "Method", c("Gibbs", "VEM"), "Gibbs"),
      actionButton("lda_button_fit", "Fit"),
      render_helpfile("LDA", "analyse/lda_fit.md")
    ),
    mainPanel(
      textOutput("analyse_lda_fit_")
    )
  )
)

output$analyse_lda_fit_ <- renderText({
  observeEvent(input$lda_button_fit, {
    withProgress(message='Fitting the model...', value=0,
    {
      incProgress(0, message="Transforming to document-term matrix...")
      DTM <- qdap::as.dtm(localstate$corpus)
      
      print("asdf") # watch the terminal and be amazed!
      
      incProgress(1/2, message="Fitting the model...")
      localstate$lda_mdl <- topicmodels::LDA(DTM, k=input$lda_ntopics, method=input$lda_method)
    })
  })
  
  if (is.null(localstate$lda_mdl))
    "Press 'Fit' to fit an LDA model."
  else
    capture.output(localstate$lda_mdl)
})



output$analyse_lda_topics <- renderUI(
  sidebarLayout(
    sidebarPanel(
      h5("Latent Dirichlet Allocation"),
      sliderInput("lda_nterms", "Number of Terms", min=1, max=50, value=10),
      actionButton("lda_button_topics", "Update Topics"),
      render_helpfile("LDA", "analyse/lda_topics.md")
    ),
    mainPanel(
      renderTable({
        button <- buttonfix(session, input$lda_button_topics)
        
        if (button$lda_button_topics)
        {
          if (exists("lda_mdl", envir=session))
          {
            lda_mdl <- get("lda_mdl", envir=session)
            topicmodels::terms(lda_mdl, input$lda_nterms)
          }
          else
            stop("You must first fit a model in the 'Fit' tab!")
        }
        else
          data.frame("Fit a model in the 'Fit' tab and then generate topics by clicking the 'Update Topics' button.")
      })
    )
  )
)

