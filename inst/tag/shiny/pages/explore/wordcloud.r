wordcloud_inname <- c("Black/White", "Accent", "Dark", "Orange", "Green", "Purple", "Blue", "Grey")
wordcloud_outname <- c("black", "Accent", "Dark2", "Oranges", "Greens", "Purples", "Blues", "Greys")

output$explore_wordcloud <- renderUI(
  sidebarLayout(
    sidebarPanel(
      sliderInput("wordcloud_minfreq", "Minimum frequency:", min=1, max=50, value=15),
      sliderInput("wordcloud_maxwords", "Maximum words:", min=1, max=150, value=25),
      checkboxInput("wordcloud_random.order", "Random order?", value=FALSE),
      selectizeInput("wordcloud_colors", "Colors", wordcloud_inname, "alternating"),
      render_helpfile("Explore Wordcloud", "explore/plot_wordcloud.md")
    ),
    mainPanel(
      show_plotnote_message,
      
      renderPlot({
        must_have("corpus")
        
        colorname <- wordcloud_outname[which(input$wordcloud_colors == wordcloud_inname)]
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
