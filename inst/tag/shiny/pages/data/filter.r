output$data_filter <- renderUI({
  list(
    sidebarLayout(
      sidebarPanel(
        
        radioButtons(inputId="data_filter_type", 
                   label="Select Filter Method", 
                   c("Stopwords"="stopwords", "Custom"="custom"), 
                   selected="", inline=FALSE),
        
        # Stopwords
        conditionalPanel(condition = "input.data_filter_type == 'stopwords'",
          br(),
          selectizeInput("data_filter_stopwords_lang", "Stopwords Language", stopwords_list, "english"),
          checkboxInput("data_filter_checkbox_remstop", "Remove stopwords?", value=TRUE),
          actionButton("button_data_filter_stopwords", "Filter Stopwords"),
          hr()
        ),
        
        # Custom
        conditionalPanel(condition = "input.data_filter_type == 'custom'",
          br(),
          checkboxInput("data_filter_checkbox_greedy", "Exclude greedily?", value=FALSE),
          checkboxInput("data_filter_checkbox_greedy", "Exclude ignores case?", value=FALSE),
          textInput("data_filter_exclude", "Exclude Text"),
          actionButton("button_data_filter_custom", "Filter Custom"),
          hr()
        ),
        
        
        render_helpfile("Data Filter", "data/filter.md")
      ),
      mainPanel(
        renderUI({
          must_have("corpus")
          
          a <- data_filter_stopwords_reactive()
          b <- data_filter_custom_reactive()
          
          if (!is.null(a)) a
          else
            b
        })
      )
    )
  )
})



data_filter_stopwords_reactive <- eventReactive(input$button_data_filter_stopwords, {
  withProgress(message='Processing...', value=0, {
    
    addto_call("### Filter stopwords\n")
    
    runtime <- system.time({
      incProgress(0, message="Removing stopwords...")
      evalfun(localstate$corpus <- tm::tm_map(localstate$corpus, tm::removeWords, tm::stopwords(input$data_filter_stopwords_lang)), 
        comment="Remove stopwords")
      
      clear_secondary()
      
      addto_call("\n")
      
      clear_modelstate()
    })
    
    setProgress(1)
  })
  
  paste("Processing finished in", round(runtime[3], roundlen), "seconds.")
})




data_filter_custom_reactive <- eventReactive(input$button_data_filter_custom, {
  withProgress(message='Processing...', value=0, {
    
    addto_call("### Filter custom list\n")
    
    runtime <- system.time({
      
      if (input$data_filter_exclude != "")
      {
        evalfun({
          terms <- input$data_filter_exclude
          terms <- unlist(strsplit(terms, split=","))
          
          localstate$corpus <- tm::tm_map(localstate$corpus, tm::removeWords, terms)
        })
      }
      else
        stop("Exclusion list is empty!")
      
      cleare_secondary()
      
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

