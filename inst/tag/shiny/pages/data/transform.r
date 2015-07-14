output$data_transform <- renderUI({
  list(
    sidebarLayout(
      sidebarPanel(
        checkboxInput("data_transform_checkbox_makelower", "Make lowercase?", value=TRUE),
        checkboxInput("data_transform_checkbox_rempunct", "Remove punctuation?", value=TRUE),
        checkboxInput("data_transform_checkbox_remnum", "Remove numbers?", value=TRUE),
        checkboxInput("data_transform_checkbox_remws", "Remove extra whitespace?", value=TRUE),
        checkboxInput("data_transform_checkbox_stem", "Stem?", value=FALSE),
        
        actionButton("button_data_transform", "Transform"),
        render_helpfile("Data Transform", "data/transform.md")
      ),
      mainPanel(
        renderUI({
          must_have("corpus")
          
          data_transform_reactive()
        })
      )
    )
  )
})



data_transform_reactive <- eventReactive(input$button_data_transform, {
  withProgress(message='Processing...', value=0, {
    
    n <- input$data_transform_checkbox_makelower + 
         input$data_transform_checkbox_rempunct + 
         input$data_transform_checkbox_remnum + 
         input$data_transform_checkbox_remws + 
         input$data_transform_checkbox_stem
    
    if (n > 0)
      addto_call("### Transform text\n")
    
    runtime <- system.time({
      if (input$data_transform_checkbox_makelower)
      {
        incProgress(0, message="Setting to lowercase...")
        evalfun(localstate$corpus <- tm::tm_map(localstate$corpus, tm::content_transformer(base::tolower)), 
          comment="Set lowercase")
        incProgress(1/n/2)
      }
      if (input$data_transform_checkbox_rempunct)
      {
        incProgress(0, message="Removing punctuation...")
        evalfun(localstate$corpus <- tm::tm_map(localstate$corpus, tm::removePunctuation), 
          comment="Remove punctuation")
        incProgress(1/n/2)
      }
      if (input$data_transform_checkbox_remnum)
      {
        incProgress(0, message="Removing numbers...")
        evalfun(localstate$corpus <- tm::tm_map(localstate$corpus, tm::removeNumbers), 
          comment="Remove numbers")
        incProgress(1/n/2)
      }
      if (input$data_transform_checkbox_remws)
      {
        incProgress(0, message="Stripping whitespace...")
        evalfun(localstate$corpus <- tm::tm_map(localstate$corpus, tm::stripWhitespace), 
          comment="Remove extra whitespace")
        incProgress(1/n/2)
      }
      if (input$data_transform_checkbox_stem)
      {
        incProgress(0, message="Stemming...")
        evalfun(localstate$corpus <- tm::tm_map(localstate$corpus, tm::stemDocument), 
          comment="Stem")
        incProgress(1/n/2)
      }
      
      incProgress(0, message="Updating tdm...")
      update_tdm()
      setProgress(3/4, message="Updating wordcounts...")
      update_wordcount()
      
      if (n > 0)
        addto_call("\n")
      
      
      clear_modelstate()
    })
    
    setProgress(1)
  })
  
  paste("Processing finished in", round(runtime[3], roundlen), "seconds.")
})

