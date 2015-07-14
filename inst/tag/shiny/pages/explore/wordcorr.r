output$explore_wordcorr <- renderUI(
  sidebarLayout(
    sidebarPanel(
      h5("Correlation Plot Options"),
      checkboxInput("plot_termsearch_checkbox_findclosest", "Find closest match?", value=FALSE),
      sliderInput("wordcorr_corr", "Minimum Correlation", min=.05, max=1.0, value=.750000000),
      textInput("wordcorr_word", ""),
      render_helpfile("Explore Word Correlation", "explore/plot_wordcorr.md")
    ),
    mainPanel(
      show_plotnote_message,
      
      renderPlot({
        must_have("corpus")
        
        term <- input$wordcorr_word
        if (term == "")
          return("")
        
        withProgress(message='Rendering plot...', value=0,
        {
          if (input$plot_termsearch_checkbox_findclosest)
            term <- find_closest_word(term, names(localstate$wordcount_table))$word
          
          cor_list <- qdap::apply_as_df(localstate$corpus, qdap::word_cor, word=term, r=input$wordcorr_corr)
          
          print(cor_list)
          
          if (is.null(cor_list))
          {
            plot.new()
            text("Term not found\nin corpus!", x=.45, y=.5, cex=3, col="red")
          }
          else
          {
            len <- length(cor_list[[1L]])
            if (len > 10) len <- 10
            cor_list[[1L]] <- sort(cor_list[[1L]], decreasing=TRUE)[1L:len]
            
            plot(cor_list) + theme_bw()
          }
        })
      })
    )
  )
)

