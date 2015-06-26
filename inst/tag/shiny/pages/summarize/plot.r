output$summarize_top10 <- renderUI(
  verticalLayout(
    renderPlot({
      must_have("corpus")
      
      withProgress(message='Rendering plot...', value=0,
      {
        tot <- sum(localstate$wordcount_table)
        v <- localstate$wordcount_table[1:min(length(localstate$wordcount_table), 10)]
        
        df <- data.frame(terms=names(v), counts=v, stringsAsFactors=FALSE)
        
        top10 <- cbind(df, pcttot=df$counts / tot * 100)
        top10$terms <- factor(top10$terms, levels=top10$terms)
        
        g <- ggplot(top10, aes(x=terms, y=pcttot)) + 
             geom_point() + 
             ylab("Percentage of Corpora") + 
             xlab("Term") + 
             theme_bw() + 
             theme(axis.text.x=element_text(angle=22, hjust=1))
        
        g
      })
    }),
    
    render_helpfile("Top 10", "summarize/plot_top10.md")
  )
)



output$summarize_wordcorr <- renderUI(
  sidebarLayout(
    sidebarPanel(
      h5("Correlation Plot Options"),
      checkboxInput("plot_termsearch_checkbox_findclosest", "Find closest match?", value=FALSE),
      sliderInput("wordcorr_corr", "Minimum Correlation", min=.05, max=1.0, value=.750000000),
      textInput("wordcorr_word", ""),
      render_helpfile("Correlation Plot", "summarize/plot_wordcorr.md")
    ),
    mainPanel(
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



output$summarize_zipf <- renderUI(
  verticalLayout(
    renderPlot(
      withProgress(message='Rendering plot...', value=0,
      {
        must_have("tdm")
        
        tm::Zipf_plot(localstate$tdm)
      })
    ),
    
    render_helpfile("Zipf Plot", "summarize/plot_zipf.md")
  )
)



inname <- c("Black/White", "Accent", "Dark", "Orange", "Green", "Purple", "Blue", "Grey")
outname <- c("black", "Accent", "Dark2", "Oranges", "Greens", "Purples", "Blues", "Greys")

output$summarize_wordcloud <- renderUI(
  sidebarLayout(
    sidebarPanel(
      h5("Wordcloud Options"),
      sliderInput("wordcloud_minfreq", "Minimum frequency:", min=1, max=50, value=15),
      sliderInput("wordcloud_maxwords", "Maximum words:", min=1, max=150, value=25),
      checkboxInput("wordcloud_random.order", "Random order?", value=FALSE),
      selectizeInput("wordcloud_colors", "Colors", inname, "alternating"),
      render_helpfile("Wordcloud", "summarize/plot_wordcloud.md")
    ),
    mainPanel(
      renderPlot({
        must_have("corpus")
        
        colorname <- outname[which(input$wordcloud_colors == inname)]
        if (colorname == "black")
          colors <- colorname
        else
          colors <- RColorBrewer::brewer.pal(8, colorname)
        
        withProgress(message='Rendering plot...', value=0, 
        {
          wordcloud::wordcloud(localstate$corpus, min.freq=input$wordcloud_minfreq, 
            max.words=input$wordcloud_maxwords, random.order=input$wordcloud_random.order, 
            random.color=FALSE, colors=colors, scale=c(8, .2))
        })
      })
    )
  )
)



output$summarize_dispersionplot <- renderUI(
  sidebarLayout(
    sidebarPanel(
      h5("Dispersion Plot"),
      checkboxInput("plot_dispersion_checkbox_findclosest", "Find closest match?", value=FALSE),
      textInput("dispersionplot_word", "Word(s) (comma separated)", ""),
      render_helpfile("Dispersion", "summarize/plot_dispersion.md")
    ),
    mainPanel(
      renderPlot({
        must_have("corpus")
        
        term <- input$dispersionplot_word
        if (term == "")
          return("")
        
        withProgress(message='Validating inputs...', value=0,
        {
          terms <- unlist(strsplit(term, split=","))
          names <- names(localstate$wordcount_table)
          nb.terms <- sapply(terms, function(term) find_closest_word(term, names)$word)
          
          if (input$plot_dispersion_checkbox_findclosest)
            terms <- nb.terms
          else if (!all(terms == nb.terms))
          {
            bad <- which(terms!=nb.terms)
            if (length(bad) == 1)
              badterms <- paste("Term", terms[bad])
            else
              badterms <- paste("Terms", paste(terms[bad], collapse=", "))
            
            stop(paste(badterms, "not found!"))
          }
          
          setProgress(1/2, message="Rendering plot...")
          qdap::dispersion_plot(localstate$corpus, terms, color="black", bg.color="white")
        })
      })
    )
  )
)

