output$explore_dispersionplot <- renderUI(
  sidebarLayout(
    sidebarPanel(
      h5(strong("Search Strictness")),
      checkboxInput("plot_dispersion_checkbox_findclosest", "Find closest match?", value=FALSE),
      textInput("dispersionplot_word", "Word(s) (comma separated)", ""),
      render_helpfile("Explore Dispersion", "explore/plot_dispersion.md")
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

