output$explore_summary <- renderUI({
  list(
    sidebarLayout(
      sidebarPanel(
        sliderInput("explore_corpus_maxwordlen", "Maximum Word Length", min=1, max=128, value=15),
        sliderInput("explore_corpus_maxsenlen", "Maximum Sentence Length", min=1, max=512, value=60),
        
        render_helpfile("Explore Summary", "explore/basic_summary.md")
      ),
      mainPanel(
        uiOutput("explore_summary_")
      )
    )
  )
})



output$explore_summary_ <- renderUI({
  must_have("corpus")
  
  s <- TAG::wc(sapply(localstate$corpus, function(i) i$content), input$explore_corpus_maxwordlen, input$explore_corpus_maxsenlen)
  
  verticalLayout(
    ### Top row
    fluidRow(
      # Count table
      column(6, 
        renderTable(align=c("l", "r"), {
          distinct <- tm::nTerms(localstate$tdm)
          ndocs <- tm::nDocs(localstate$tdm)
          ram <- paste(memuse::object.size(localstate$corpus))
          
          l <- list(Characters=s$chars, Letters=s$letters, Digits=s$digits,
                    Whitespace=s$whitespace, Punctuation=s$punctuation,
                    Words=s$words, "Distinct Words"=distinct, 
                    Sentences=s$sentences, Lines=s$lines, 
                    Documents=ndocs, RAM=ram)
          
          data.frame(Count=sapply(l, identity))
        })
      ),
      
      # Stat table
      column(6, 
        renderTable(align=c("l", "r"), {
          ### TODO syllables, Fleisch-Kincaid
              ### readability:  206.876-1.015(total words / total sentences) - 84.6(total syllables / total words)
              ### reading age:  .39*(avg senlen) + 11.8*(avg syllables per word) - 15.59
          
          countmean <- function(x) sum(1:length(x) * x) / sum(x)
          countvar <- function(x, avg) sum(sapply(1:length(x), function(i) x[i]*(i-avg)^2)) / sum(x)
          
          avg.wordlen <- countmean(s$wordlen)
          var.wordlen <- countvar(s$wordlen, avg.wordlen)
          avg.senlen <- countmean(s$senlen)
          var.senlen <- countvar(s$senlen, avg.senlen)
          
          rownames <- c("Avg word len", "Word len variance", "Avg sentence len", "Sentence len variance")
          
          df <- data.frame("Stat"=c(avg.wordlen, var.wordlen, avg.senlen, var.senlen))
          rownames(df) <- rownames
          df
        })
      )
    ),
    
    ### Wordlen plot
    renderPlot({
      df <- data.frame(length=1:length(s$wordlens), characters=s$wordlens)
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
        xlab("Characters Per Word") +
        ylab("Percentage of Corpus") +
        ggtitle("Word Length Distribution") + 
        theme_bw()
    }),
    
    ### Senlen plot
    renderPlot({
      if (all(s$senlen == 0))
      {
        warning("No sentences detected!")
        return("")
      }
      
      df <- data.frame(length=1:length(s$senlens), sentences=s$senlens)
      indices <- df$sentences > 0
      df <- df[indices, ]
      df$sentences <- 100*df$sentences/sum(df$sentences)
      
      breaks <- df$length
      labs <- as.character(breaks)
      if (input$explore_corpus_maxsenlen == labs[length(labs)])
        labs[length(labs)] <- paste0(tail(labs, 1), "+")
      
      ggplot(data=df, aes(length, sentences)) + 
        geom_bar(stat="identity") + 
        scale_x_continuous(breaks=breaks, labels=labs) +
        xlab("Words Per Sentence") +
        ylab("Percentage of Corpus") +
        ggtitle("Sentence Length Distribution") + 
        theme_bw()
    })
  )
})
