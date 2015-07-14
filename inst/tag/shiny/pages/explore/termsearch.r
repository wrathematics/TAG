output$explore_termsearch <- renderUI({
  list(
    sidebarLayout(
      sidebarPanel(
        radioButtons(inputId="explore_termsearch_type", 
                   label="Search by...", c("Term"="Term", "Count"="Count", "Frequency"="Frequency"), 
                   selected="", inline=FALSE),
        
        br(),
        
        conditionalPanel(condition = "input.explore_termsearch_type == 'Term'",
          h5(strong("Search Strictness")),
          checkboxInput("basic_termsearch_checkbox_findclosest", "Find closest match?", value=FALSE),
          textInput("explore_termsearchbox", "")
        ),
        
        conditionalPanel(condition = "input.explore_termsearch_type == 'Count'",
          numericInput("explore_termsearch_minwordcount", "Minimum Count", min=1, value=5),
          numericInput("explore_termsearch_maxwordcount", "Maximum Count", min=1, value=100)
        ),
        
        conditionalPanel(condition = "input.explore_termsearch_type == 'Frequency'",
          sliderInput("explore_termsearch_minwordfreq", "Minimum Frequency %", min=0, max=100, value=1),
          sliderInput("explore_termsearch_maxwordfreq", "Maximum Frequency %", min=0, max=100, value=100)
        ),
        
        render_helpfile("Explore Search", "explore/basic_termsearch.md")
      ),
      mainPanel(
        renderUI({
          must_have("wordcount_table")
          
          
          if (is.null(input$explore_termsearch_type))
            return("")
          
          if (input$explore_termsearch_type == "Term")
          {
            if (input$explore_termsearchbox == "")
              return("")
            
            term <- input$explore_termsearchbox
            
            if (input$basic_termsearch_checkbox_findclosest)
              term <- find_closest_word(term, names(localstate$wordcount_table))$word
            
            freq <- localstate$wordcount_table[term]
            
            nwords <- sum(localstate$wordcount_table)
            
            if (is.na(freq))
              HTML("Term not found! <br><br> You may need to transform the data first (stem, lowercase, etc.).  See the Data--Transform tab.")
            else
              paste0("\"", term, "\" occurs ", freq, " times, and accounts for ", round(freq/nwords, roundlen)*100, "% of the text.")
          }
          else
          {
            DT::dataTableOutput("explore_termsearch_frequency_rendertable")
          }
        })
      )
    )
  )
})


output$explore_termsearch_frequency_rendertable <- DT::renderDataTable({
    if (input$explore_termsearch_type == "Count")
    {
      min <- input$explore_termsearch_minwordcount
      max <- input$explore_termsearch_maxwordcount
      
      if (min == '' || max == '')
        stop("Bad inputs; min and max count values must be supplied")
      else if (min > max)
        stop("Bad inputs; must have max count >= min count")
      else if (min < 1 || max < 1)
        stop("Bad inputs; min and max count must be at least 1 each.")
      
      tab <- localstate$wordcount_table
      
      
      if (max == "")
        ind <- which(tab >= min)
      else
        ind <- which(tab >= min & tab <= max)
    }
    else if (input$explore_termsearch_type == "Frequency")
    {
      min <- input$explore_termsearch_minwordfreq
      max <- input$explore_termsearch_maxwordfreq
      
      if (min > max)
        stop("Bad inputs; must have max frequency >= min frequency")
      
      tab <- localstate$wordcount_table*100/sum(localstate$wordcount_table)
      
      ind <- which(tab >= min & tab <= max)
    }
    
    df <- data.frame(Count=localstate$wordcount_table[ind], Frequency=tab[ind])
    
    
    DT::datatable(df, extensions="Scroller", escape=TRUE,
      options = list(
        searching = FALSE,
        deferRender = TRUE,
        dom = "frtiS",
        scrollY = 300,
        width = 500,
        scrollCollapse = TRUE
      )
    )
})
