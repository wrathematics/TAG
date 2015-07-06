# ----------------------------------------------------------
# UI
# ----------------------------------------------------------

output$main_explore <- renderUI({
  mainPanel(id="exploretabs_plot", 
    tabsetPanel(
      tabPanel("Summary", 
        sliderInput("explore_corpus_maxwordlen", "Maximum Word Length", min=1, max=128, value=15),
        uiOutput("explore_corpus"), 
        plotOutput("explore_corpus_wordlengths")
      ),
      tabPanel("Search", uiOutput("explore_termsearch")),
      tabPanel("Top 10", uiOutput("explore_top10")),
      tabPanel("Correlation", uiOutput("explore_wordcorr")),
      tabPanel("Dispersion", uiOutput("explore_dispersionplot")),
      tabPanel("Zipf", uiOutput("explore_zipf")),
      tabPanel("Wordcloud", uiOutput("explore_wordcloud"))
    )
  )
})



show_plotnote_message <- renderUI({
  must_have("corpus", silent=TRUE)
  plotnote
})



# ----------------------------------------------------------
# Server
# ----------------------------------------------------------

output$explore_corpus <- renderUI({
  must_have("corpus")
  
  s <- wc(sapply(localstate$corpus, function(i) i$content), input$explore_corpus_maxwordlen)
  localstate$explore_wordlens <- s$wordlens
  
  s$wordlens <- NULL
  
  distinct <- tm::nTerms(localstate$tdm)
  ndocs <- tm::nDocs(localstate$tdm)
  ram <- paste(memuse::object.size(localstate$corpus))
  
  l <- list(Characters=s$chars, Letters=s$letters, Digits=s$digits,
            Whitespace=s$whitespace, Punctuation=s$punctuation,
            Words=s$words, "Distinct Words"=distinct, 
            Sentences=s$sentences, Lines=s$lines, 
            Documents=ndocs, RAM=ram)
  
  df <- data.frame(Count=sapply(l, identity))
  
  verticalLayout(
    renderTable(df, align=c("l", "r")),
    br(),
    renderPlot({
      must_have("corpus")
      
      df <- data.frame(length=1:length(localstate$explore_wordlens), characters=localstate$explore_wordlens)
      indices <- df$characters > 0
      df <- df[indices, ]
      df$characters <- 100*df$characters/sum(df$characters)
      
      breaks <- df$length
      labs <- as.character(breaks)
      if (input$explore_corpus_maxwordlen == labs[length(labs)])
        labs[length(labs)] <- paste0(tail(labs, 1), "+")
      
      ggplot(data=df, aes(length, characters)) + 
        geom_bar(stat="identity") + 
        scale_x_continuous(breaks=breaks, labels=labs) +
        xlab("Characters") +
        ylab("Percentage of Corpus") +
        ggtitle("Distribution of Words by Character Length") + 
        theme_bw()
    })
  )
})





output$explore_termsearch <- renderUI({
  list(
    sidebarLayout(
      sidebarPanel(
        h5("Term Frequency"),
        checkboxInput("basic_termsearch_checkbox_findclosest", "Find closest match?", value=FALSE),
        textInput("explore_termsearchbox", ""),
        render_helpfile("Term Search", "explore/basic_termsearch.md")
      ),
      mainPanel(
        renderUI({
          must_have("wordcount_table")
          
          if (input$explore_termsearchbox == "")
            return("")
          
          term <- input$explore_termsearchbox
          
          if (input$basic_termsearch_checkbox_findclosest)
            term <- find_closest_word(term, names(localstate$wordcount_table))$word
          
          freq <- localstate$wordcount_table[term]
          
          if (is.na(freq))
            HTML("Term not found! <br><br> You may need to transform the data first (stem, lowercase, etc.).  See the Data--Transform tab.")
          else
            paste0("\"", term, "\" occurs ", freq, " times in the corpus.")
        })
      )
    )
  )
})




output$explore_top10 <- renderUI(
  verticalLayout(
    show_plotnote_message,
    
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
    
    render_helpfile("Top 10", "explore/plot_top10.md")
  )
)



output$explore_wordcorr <- renderUI(
  sidebarLayout(
    sidebarPanel(
      h5("Correlation Plot Options"),
      checkboxInput("plot_termsearch_checkbox_findclosest", "Find closest match?", value=FALSE),
      sliderInput("wordcorr_corr", "Minimum Correlation", min=.05, max=1.0, value=.750000000),
      textInput("wordcorr_word", ""),
      render_helpfile("Correlation Plot", "explore/plot_wordcorr.md")
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



output$explore_zipf <- renderUI(
  verticalLayout(
    show_plotnote_message,
    renderPlot(
      withProgress(message='Rendering plot...', value=0,
      {
        must_have("tdm")
        
        tm::Zipf_plot(localstate$tdm)
      })
    ),
    
    render_helpfile("Zipf Plot", "explore/plot_zipf.md")
  )
)



inname <- c("Black/White", "Accent", "Dark", "Orange", "Green", "Purple", "Blue", "Grey")
outname <- c("black", "Accent", "Dark2", "Oranges", "Greens", "Purples", "Blues", "Greys")

output$explore_wordcloud <- renderUI(
  sidebarLayout(
    sidebarPanel(
      h5("Wordcloud Options"),
      sliderInput("wordcloud_minfreq", "Minimum frequency:", min=1, max=50, value=15),
      sliderInput("wordcloud_maxwords", "Maximum words:", min=1, max=150, value=25),
      checkboxInput("wordcloud_random.order", "Random order?", value=FALSE),
      selectizeInput("wordcloud_colors", "Colors", inname, "alternating"),
      render_helpfile("Wordcloud", "explore/plot_wordcloud.md")
    ),
    mainPanel(
      show_plotnote_message,
      
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



output$explore_dispersionplot <- renderUI(
  sidebarLayout(
    sidebarPanel(
      h5("Dispersion Plot"),
      checkboxInput("plot_dispersion_checkbox_findclosest", "Find closest match?", value=FALSE),
      textInput("dispersionplot_word", "Word(s) (comma separated)", ""),
      render_helpfile("Dispersion", "explore/plot_dispersion.md")
    ),
    mainPanel(
      show_plotnote_message,
      
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

