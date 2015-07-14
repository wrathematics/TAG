output$data_filter <- renderUI({
  list(
    sidebarLayout(
      sidebarPanel(
        selectizeInput("data_filter_stopwords_lang", "Stopwords Language", stopwords_list, "english"),
        checkboxInput("data_filter_checkbox_remstop", "Remove stopwords?", value=TRUE),
        hr(),
        
        checkboxInput("data_filter_checkbox_exclude", "Exclude list?", value=TRUE),
        checkboxInput("data_filter_checkbox_greedy", "Exclude greedily?", value=TRUE),
        checkboxInput("data_filter_checkbox_greedy", "Exclude ignores case?", value=FALSE),
        textInput("data_filter_exclude", "Exclude Text"),
        
        actionButton("button_data_filter", "Filter"),
        render_helpfile("Data", "data/filter.md")
      ),
      mainPanel(
        renderUI({
          must_have("corpus")
          
          data_filter_reactive()
        })
      )
    )
  )
})



data_filter_reactive <- eventReactive(input$button_data_filter, {
  withProgress(message='Processing...', value=0, {
    
    n <- input$data_filter_checkbox_remstop
    
    if (n > 0)
      addto_call("### Filter text\n")
    
    runtime <- system.time({
      
      if (input$data_filter_checkbox_remstop)
      {
        incProgress(0, message="Removing stopwords...")
        evalfun(localstate$corpus <- tm::tm_map(localstate$corpus, tm::removeWords, tm::stopwords(input$data_filter_stopwords_lang)), 
          comment="Remove stopwords")
        
        incProgress(1/n/2)
      }
      if (input$data_filter_checkbox_exclude)
      {
        print(input$data_filter_exclude)
        if (input$data_filter_exclude != "")
        {
          evalfun({
            terms <- input$data_filter_exclude
            terms <- unlist(strsplit(terms, split=","))
            
            localstate$corpus <- tm::tm_map(localstate$corpus, tm::removeWords, terms)
          })
        }
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

### TODO
#        terms <- input$data_filter_exclude
##          terms <- paste0("(", paste0(unlist(strsplit(terms, split=",")), collapse="|"), ")")
#        terms <- unlist(strsplit(terms, split=","))
#        
#        localstate$corpus <- tm::tm_map(localstate$corpus, tm::removeWords, terms)
##          endofword <- paste0(terms, "(.*?)(\\s|\\n|[:punct:])")
##          endofline <- paste0(terms, "(.*?)")
##          
##          for (i in 1:length(localstate$corpus))
##          {
##            
##            localstate$corpus[[i]]$content <- gsub(localstate$corpus[[i]]$content, pattern=endofword, replacement="")
##            localstate$corpus[[i]]$content <- gsub(localstate$corpus[[i]]$content, pattern=endofline, replacement="")
##          }

