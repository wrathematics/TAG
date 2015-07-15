output$explore_termsearch <- renderUI({
  list(
    sidebarLayout(
      sidebarPanel(
        radioButtons(inputId="explore_termsearch_type", 
                   label="Search by...", c("Term"="Term", "Count"="Count", "Percent"="Percent"), 
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
        
        conditionalPanel(condition = "input.explore_termsearch_type == 'Percent'",
          sliderInput("explore_termsearch_minwordfreq", "Minimum %", min=0, max=100, value=1),
          sliderInput("explore_termsearch_maxwordfreq", "Maximum %", min=0, max=100, value=100)
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
              HTML("Term not found! <br><br> You may need to transform the data first (stem, lowercase, etc.), or try the 'Find closest match' feature.")
            else
              paste0("\"", term, "\" occurs ", freq, " times, and its usage accounts for ", round(freq/nwords, roundlen)*100, "% of the text.")
          }
          else
          {
            DT::dataTableOutput("explore_termsearch_rendertable")
          }
        })
      )
    )
  )
})


output$explore_termsearch_rendertable <- DT::renderDataTable({
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
      tab_pct <- tab*100/sum(tab)
      
      if (max == "")
        ind <- which(tab >= min)
      else
        ind <- which(tab >= min & tab <= max)
    }
    else if (input$explore_termsearch_type == "Percent")
    {
      min <- input$explore_termsearch_minwordfreq
      max <- input$explore_termsearch_maxwordfreq
      
      if (min > max)
        stop("Bad inputs; must have max frequency >= min frequency")
      
      tab <- localstate$wordcount_table
      tab_pct <- tab*100/sum(tab)
      
      ind <- which(tab_pct >= min & tab_pct <= max)
    }
    
    df <- data.frame(Count=tab[ind], Percent=tab_pct[ind])
    
    
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
