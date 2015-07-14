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
    
    render_helpfile("Explore Zipf's Law", "explore/plot_zipf.md")
  )
)
