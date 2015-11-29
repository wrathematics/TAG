output$explore_summary <- renderUI({
  list(
    sidebarLayout(
      sidebarPanel(
        sliderInput("explore_corpus_maxwordlen", "Maximum Word Length", min=1, max=128, value=15),
        sliderInput("explore_corpus_maxsenlen", "Maximum Sentence Length", min=1, max=512, value=60),
        sliderInput("explore_corpus_maxsyllen", "Maximum Syllable Length", min=1, max=128, value=10),
        
        render_helpfile("Explore Summary", "explore/basic_summary.md")
      ),
      mainPanel(
        uiOutput("explore_summary_")
      )
    )
  )
})



TAG_summary_plotter <- function(x, maxlen)
{
  df <- data.frame(length=1:length(x), sentences=x)
  indices <- df$sentences > 0
  df <- df[indices, ]
  df$sentences <- 100*df$sentences/sum(df$sentences)
  
  breaks <- df$length
  labs <- as.character(breaks)
  if (maxlen == labs[length(labs)])
    labs[length(labs)] <- paste0(tail(labs, 1), "+")
  
  ggplot(data=df, aes(length, sentences)) + 
    geom_bar(stat="identity") + 
    scale_x_continuous(breaks=breaks, labels=labs) +
    theme_bw()
}


countmean <- function(x) sum(1:length(x) * x) / sum(x)
countvar <- function(x, avg) sum(sapply(1:length(x), function(i) x[i]*(i-avg)^2)) / sum(x)



output$explore_summary_ <- renderUI({
  must_have("corpus")
  must_have("tdm")
  
  s <- TAG::wc(sapply(localstate$corpus, function(i) i$content), input$explore_corpus_maxwordlen, input$explore_corpus_maxsenlen)
  
  verticalLayout(
    ### Top row
    fluidRow(
      # Count table
      column(4, 
        renderTable(align=c("l", "r"), {
          distinct <- tm::nTerms(localstate$tdm)
          ndocs <- tm::nDocs(localstate$tdm)
          ram <- paste(memuse::memuse(localstate$corpus))
          
          l <- list(Characters=s$chars, Letters=s$letters, Digits=s$digits,
                    Whitespace=s$whitespace, Punctuation=s$punctuation,
                    Words=s$words, "Distinct Words"=distinct, 
                    Sentences=s$sentences, Lines=s$lines, 
                    Documents=ndocs, RAM=ram)
          
          data.frame(Count=sapply(l, identity))
        })
      ),
      
      # Stat table
      column(4, 
        renderTable(align=c("l", "r"), {
          avg.wordlen <- countmean(s$wordlens)
          var.wordlen <- countvar(s$wordlens, avg.wordlen)
          avg.senlen <- countmean(s$senlens)
          var.senlen <- countvar(s$senlens, avg.senlen)
          avg.syllen <- countmean(s$syllens)
          var.syllen <- countvar(s$syllens, avg.syllen)
          
          rownames <- c("Avg word len", "Word len variance", "Avg sentence len", "Sentence len variance", "Avg syllable len", "Syllable len variance")
          
          df <- data.frame("Stat"=c(avg.wordlen, var.wordlen, avg.senlen, var.senlen, avg.syllen, var.syllen))
          rownames(df) <- rownames
          df
        })
      ),
    
    # Fleisch-Kincaid table
      column(4, 
        renderTable(align=c("l", "r"), {
          ### readability:  206.876-1.015(total words / total sentences) - 84.6(total syllables / total words)
          total.words <- sum(s$wordlens)
          total.sentences <- sum(s$senlens)
          total.syllables <- sum(1:length(s$syllens)*s$syllens)
          
          readability <- 206.876 - 1.015*total.words/total.sentences - 84.6*total.syllables/total.words
          
          ### reading age:  .39*(total words / total sentences) + 11.8*(total syllables / total words) - 15.59
          grade.level <- .39*total.words/total.sentences + 11.8*total.syllables/total.words - 15.59
          
          
          rownames <- c("Readability", "Grade Level")
          
          df <- data.frame("Fleisch-Kincaid"=c(readability, grade.level))
          rownames(df) <- rownames
          df
        })
      )
    ),
    
    ### Wordlen plot
    renderPlot({
      g <- TAG_summary_plotter(s$wordlens, input$explore_corpus_maxwordlen)
      
      g + 
        xlab("Characters Per Word") +
        ylab("Percentage of Corpus") +
        ggtitle("Word Length Distribution")
    }),
    
    ### Senlen plot
    renderPlot({
      if (all(s$senlen == 0))
      {
        return("")
      }
      
      g <- TAG_summary_plotter(s$senlens, input$explore_corpus_maxsenlen)
      
      g + 
        xlab("Words Per Sentence") +
        ylab("Percentage of Corpus") +
        ggtitle("Sentence Length Distribution")
    }),
    
    ### Syllen plot
    renderPlot({
      g <- TAG_summary_plotter(s$syllens, input$explore_corpus_maxsyllen)
      
      g + 
        xlab("Syllables Per Word") +
        ylab("Percentage of Corpus") +
        ggtitle("Syllable Length Distribution")
    })
  )
})
