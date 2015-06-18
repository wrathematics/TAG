output$data_transform <- renderUI({
  list(
    sidebarLayout(
      sidebarPanel(
        checkboxInput("data_transform_checkbox_makelower", "Make lowercase?", value=TRUE),
        checkboxInput("data_transform_checkbox_rempunct", "Remove punctuation?", value=TRUE),
        checkboxInput("data_transform_checkbox_remnum", "Remove numbers?", value=FALSE),
        checkboxInput("data_transform_checkbox_remws", "Remove extra whitespace?", value=FALSE),
        checkboxInput("data_transform_checkbox_stem", "Stem?", value=FALSE),
        selectizeInput("data_stopwords_lang", "Stopwords Language", stopwords_list, "english"),
        checkboxInput("data_transform_checkbox_remstop", "Remove stopwords?", value=TRUE),
        actionButton("button_data_transform", "Transform"),
        render_helpfile("Transform", "data/transform.md")
      ),
      mainPanel(
        htmlOutput("data_transform_buttonaction")
      )
    )
  )
})



output$data_transform_buttonaction <- renderUI({
  button <- buttonfix(session, input$button_data_transform)
  
  print(button)
  if (button$button_data_transform)
  {
    withProgress(message='Processing...', value=0, {
      corpus <- get("corpus", envir=session)
      
      if (input$data_transform_checkbox_makelower)
        corpus <- tm::tm_map(corpus, tm::content_transformer(tolower))
      if (input$data_transform_checkbox_rempunct)
        corpus <- tm::tm_map(corpus, tm::removePunctuation)
      if (input$data_transform_checkbox_remnum)
        corpus <- tm::tm_map(corpus, tm::removeNumbers)
      if (input$data_transform_checkbox_remws)
        corpus <- tm::tm_map(corpus, tm::stripWhitespace)
      if (input$data_transform_checkbox_stem)
        corpus <- tm::tm_map(corpus, tm::stemDocument)
      if (input$data_transform_checkbox_remstop)
        corpus <- tm::tm_map(corpus, tm::removeWords, tm::stopwords(input$data_stopwords_lang))
      
      assign("corpus", corpus, envir=session)
      tdm <- tm::TermDocumentMatrix(corpus)
      assign("tdm", tdm, envir=session)
      
      wordcount_table <- sort(rowSums(as.matrix(tdm)), decreasing=TRUE)
      assign("wordcount_table", wordcount_table, envir=session)
      
      
      "Done processing!"
    })
  }
  else
    "Do something"
})

