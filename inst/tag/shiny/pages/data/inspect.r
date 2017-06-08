output$data_inspect <- renderUI({
  mainPanel(
    DT::dataTableOutput("data_inspect_")
  )
})

output$data_inspect_ <- DT::renderDataTable({
  must_have("corpus")
  
  withProgress(message='Collapsing the corpus...', value=0, {

    dt <- sapply(localstate$corpus, function(elem) elem$content)
    names(dt) <- NULL
    dim(dt) <- c(length(dt), 1L)
    colnames(dt) <- "Corpus"
    
    incProgress(3/4, message="Rendering...")

    DT::datatable(dt, 
                  extensions="Scroller", 
                  escape=TRUE,
                  options = list( deferRender = TRUE,
                                  dom = "frtiS",
                                  scrollY = 300,
                                  width = 500,
                                  scrollCollapse = TRUE
                                )
                 )
  })
})


