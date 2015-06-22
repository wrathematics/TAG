output$data_filter <- renderUI({
  list(
    sidebarLayout(
      sidebarPanel(
        checkboxInput("data_filter_checkbox_makelower", "Make lowercase?", value=TRUE),
        checkboxInput("data_filter_checkbox_rempunct", "Remove punctuation?", value=TRUE),
        checkboxInput("data_filter_checkbox_remnum", "Remove numbers?", value=TRUE),
        checkboxInput("data_filter_checkbox_remws", "Remove extra whitespace?", value=TRUE),
        checkboxInput("data_filter_checkbox_stem", "Stem?", value=FALSE),
        selectizeInput("data_stopwords_lang", "Stopwords Language", stopwords_list, "english"),
        checkboxInput("data_filter_checkbox_remstop", "Remove stopwords?", value=TRUE),
        actionButton("button_data_filter", "Filter"),
        render_helpfile("Filter", "data/filter.md")
      ),
      mainPanel(
        htmlOutput("data_filter_buttonaction")
      )
    )
  )
})



output$data_filter_buttonaction <- renderUI({
  must_have("corpus")
  
  temp <- eventReactive(input$button_data_filter, {
    withProgress(message='Processing...', value=0, {
      
      n <- input$data_filter_checkbox_makelower + 
           input$data_filter_checkbox_rempunct + 
           input$data_filter_checkbox_remnum + 
           input$data_filter_checkbox_remws + 
           input$data_filter_checkbox_stem + 
           input$data_filter_checkbox_remstop
      
      runtime <- system.time({
        if (input$data_filter_checkbox_makelower)
        {
          incProgress(0, message="Setting to lowercase...")
          localstate$corpus <- tm::tm_map(localstate$corpus, tm::content_filterer(tolower))
          incProgress(1/n/2)
        }
        if (input$data_filter_checkbox_rempunct)
        {
          incProgress(0, message="Removing punctuation...")
          localstate$corpus <- tm::tm_map(localstate$corpus, tm::removePunctuation)
          incProgress(1/n/2)
        }
        if (input$data_filter_checkbox_remnum)
        {
          incProgress(0, message="Removing numbers...")
          localstate$corpus <- tm::tm_map(localstate$corpus, tm::removeNumbers)
          incProgress(1/n/2)
        }
        if (input$data_filter_checkbox_remws)
        {
          incProgress(0, message="Stripping whitespace...")
          localstate$corpus <- tm::tm_map(localstate$corpus, tm::stripWhitespace)
          incProgress(1/n/2)
        }
        if (input$data_filter_checkbox_stem)
        {
          incProgress(0, message="Stemming...")
          localstate$corpus <- tm::tm_map(localstate$corpus, tm::stemDocument)
          incProgress(1/n/2)
        }
        if (input$data_filter_checkbox_remstop)
        {
          incProgress(0, message="Removing stopwords...")
          localstate$corpus <- tm::tm_map(localstate$corpus, tm::removeWords, tm::stopwords(input$data_stopwords_lang))
          incProgress(1/n/2)
        }
        
        incProgress(0, message="Updating tdm...")
        localstate$tdm <- tm::TermDocumentMatrix(localstate$corpus)
        setProgress(3/4, message="Updating wordcounts...")
        localstate$wordcount_table <- sort(rowSums(as.matrix(localstate$tdm)), decreasing=TRUE)
      })
      
      setProgress(1)
    })
    
    paste("Processing finished in", round(runtime[3], roundlen), "seconds.")
  })
  
  temp()
})

