output$summarize_top10 <- renderUI(
  verticalLayout(
    plotOutput("summarize_top10_plot"),
    render_helpfile("Top 10", "summarize/plot_top10.md")
  )
)

#wct <- reactive({
#  get("wordcount_table", envir=session)
#})

output$summarize_top10_plot <- renderPlot({
#  wordcount_table <- wct()
  get("wordcount_table", envir=session)
  withProgress(message='Rendering plot...', value=0,
  {
    tot <- sum(wordcount_table)
    v <- wordcount_table[1:min(length(wordcount_table), 10)]
    
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
})



output$summarize_wordcorr <- renderUI(
  sidebarLayout(
    sidebarPanel(
      h5("Correlation Plot Options"),
      sliderInput("wordcorr_corr", "Minimum Correlation", min=.05, max=1.0, value=.750000000),
      tags$textarea(id="wordcorr_word", rows=1, cols=60, ""),
      render_helpfile("Correlation Plot", "summarize/plot_wordcorr.md")
    ),
    mainPanel(
      plotOutput("summarize_wordcorr_plot")
    )
  )
)

output$summarize_wordcorr_plot <- renderPlot(
  withProgress(message='Rendering plot...', value=0,
  {
    if (input$wordcorr_word == "")
    {
      plot.new()
    }
    else
    {
      corpus <- get("corpus", envir=session)
      cor_list <- qdap::apply_as_df(corpus, qdap::word_cor, word=input$wordcorr_word, r=input$wordcorr_corr)
      
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
    }
  })
)



output$summarize_zipf <- renderUI(
  verticalLayout(
    plotOutput("summarize_zipf_plot"),
    render_helpfile("Zipf Plot", "summarize/plot_zipf.md")
  )
)

output$summarize_zipf_plot <- renderPlot(
  withProgress(message='Rendering plot...', value=0,
  {
    tdm <- get("tdm", envir=session)
    tm::Zipf_plot(tdm)
  })
)



output$summarize_wordcloud <- renderUI(
  sidebarLayout(
    sidebarPanel(
      h5("Wordcloud Options"),
      sliderInput("wordcloud_minfreq", "Minimum Frequency:", min=1, max=50, value=15),
      sliderInput("wordcloud_maxwords", "Maximum Number of Words:", min=1, max=150, value=25),
      selectizeInput("wordcloud_colors", "Colors", c("Black/White", "Accent", "Dark", "Orange", "Green", "Purple", "Blue", "Grey"), "alternating"),
      render_helpfile("Wordcloud", "summarize/plot_wordcloud.md")
    ),
    mainPanel(
      plotOutput("summarize_wordcloud_plotter")
    )
  )
)

output$summarize_wordcloud_plotter <- renderPlot({
  if (input$wordcloud_colors == "Black/White")
    colors <- "black"
  else if (input$wordcloud_colors == "Accent")
    colors <- RColorBrewer::brewer.pal(8,"Accent")
  else if (input$wordcloud_colors == "Dark")
    colors <- RColorBrewer::brewer.pal(8,"Dark2")
  else if (input$wordcloud_colors == "Orange")
    colors <- RColorBrewer::brewer.pal(8,"Oranges")
  else if (input$wordcloud_colors == "Green")
    colors <- RColorBrewer::brewer.pal(8,"Greens")
  else if (input$wordcloud_colors == "Purple")
    colors <- RColorBrewer::brewer.pal(8,"Purples")
  else if (input$wordcloud_colors == "Blue")
    colors <- RColorBrewer::brewer.pal(8,"Blues")
  else if (input$wordcloud_colors == "Grey")
    colors <- RColorBrewer::brewer.pal(8,"Greys")
  
  withProgress(message='Rendering plot...', value=0, 
  {
    corpus <- get("corpus", envir=session)
    wordcloud::wordcloud(corpus, min.freq=input$wordcloud_minfreq, max.words=input$wordcloud_maxwords, random.order=FALSE, random.color=FALSE, colors=colors, scale=c(8, .2))
  })
})

