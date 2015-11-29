output$explore_top10 <- renderUI(
  list(
    sidebarLayout(
      sidebarPanel(
        radioButtons(inputId="explore_top10_yaxis", 
                     label="Y-Axis", c("Count"="Count", "Percent"="Percent"), 
                     selected="Count", inline=FALSE),
        render_helpfile("Explore Top 10", "explore/plot_top10.md")
      ),
      mainPanel(
        verticalLayout(
          show_plotnote_message,
          
          renderPlot({
            must_have("corpus")
            
            update_secondary()
            
            withProgress(message='Rendering plot...', value=0,
            {
              tot <- sum(localstate$wordcount_table)
              v <- localstate$wordcount_table[1:min(length(localstate$wordcount_table), 10)]
              
              df <- data.frame(terms=names(v), counts=v, stringsAsFactors=FALSE)
              
              top10 <- cbind(df, pcttot=df$counts)
              if (input$explore_top10_yaxis == "Percent")
                top10$pcttot <- top10$pcttot / tot * 100
              
              top10$terms <- factor(top10$terms, levels=top10$terms)
              
              g <- ggplot(top10, aes(x=terms, y=pcttot)) + 
                   geom_point() + 
                   xlab("Term") + 
                   theme_bw() + 
                   theme(axis.text.x=element_text(angle=22, hjust=1))
              
              if (input$explore_top10_yaxis == "Count")
                g <- g + ylab("Total Occurrences")
              else if (input$explore_top10_yaxis == "Percent")
                g <- g + ylab("Percentage of Corpora")
              
              g
            })
          })
        )
      )
    )
  )
)
