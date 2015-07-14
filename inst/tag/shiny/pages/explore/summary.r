output$explore_summary <- renderUI({
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
  
  fluidRow(
    column(4, 
      renderTable(df, align=c("l", "r"))
    ),
    column(8, 
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
  )
})
