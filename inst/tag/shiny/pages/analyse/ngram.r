output$analyse_ngram_fit <- renderUI(
  sidebarLayout(
    sidebarPanel(
      h5("N-Grams"),
      sliderInput("ngram_n", "Number of words per 'gram' (n)", min=1, max=10, value=2),
      actionButton("ngram_button_fit", "Fit"),
      downloadButton('ngram_phrasetable_save', 'Save', class="dlButton"),
      render_helpfile("Analyse Ngrams", "analyse/ngram_fit.md")
    ),
    mainPanel(
      renderUI({
        must_have("corpus")
        
        verticalLayout(
          HTML(localstate$ng_out),
          br(),br(),
          DT::dataTableOutput("analyse_ngram_inspect_")
        )
      })
    )
  )
)



analyse_ngram <- function(input)
{
  observeEvent(input$ngram_button_fit, {
    withProgress(message='', value=0,
    {
      runtime <- system.time({
        addto_call("### Ngrams\n")
        
        incProgress(0, message="Collapsing corpus...")
        evalfun(text <- ngram::concatenate(sapply(localstate$corpus, function(i) i$content), collapse=" "), 
          comment="Collapse corpus to a single character vector")
        
        incProgress(1/3, message="Fitting the model...")
        evalfun(localstate$ng_mdl <- ngram::ngram(text, n=input$ngram_n), 
          comment="Fit an n-gram model")
        
        incProgress(1/3, message="Get the n-gram phrasetable")
        evalfun(localstate$ng_pt <- ngram::get.phrasetable(localstate$ng_mdl),
          comment="Generate the n-gram phrasetable")
        
        setProgress(1)
      })
    })
    
    addto_call("\n")
    
    localstate$ng_out <- HTML(paste0("Fit an ngram model with ", localstate$ng_mdl@ngsize, " ", localstate$ng_mdl@n, "-grams in ", round(runtime[3], roundlen), " seconds."))
  })
  
  invisible()
}



output$analyse_ngram_inspect_ <- DT::renderDataTable({
  must_have("corpus")
  
  validate(need(!is.null(localstate$ng_mdl), ""))
  
  withProgress(message='Updating phrase table...', value=0, {
    pt <- localstate$ng_pt
    pt$prop <- round(pt$prop, roundlen)
    rownames(pt) <- NULL
    colnames(pt)[2:3] <- c("frequency", "proportion")
    
    localstate$ng_pt <- pt
    
    incProgress(3/4, message="Rendering...")
    DT::datatable(localstate$ng_pt, extensions="Scroller", escape=TRUE,
      options = list(
        deferRender = TRUE,
        dom = "frtiS",
        scrollY = 300,
        width = 500,
        scrollCollapse = TRUE
      )
    )
  })
})

output$ngram_phrasetable_save <- downloadHandler(
  filename=function(){
    "ngram_phrasetable.csv"
  },
  content=function(file){
    if (is.null(localstate$ng_mdl))
      stop("ERROR: You must first fit an ngram model before you can download an n-gram phrasetable!")
    
    write.csv(localstate$ng_pt, file=file, row.names=FALSE)
  }
)



analyse_ngram_babble_reactive <- eventReactive(input$ngram_button_babble, {
  withProgress(message='Generating nonsense...', value=0,
  {
    seed <- input$ngram_babble_seed
    if (seed == "")
      seed <- ngram:::getseed()
    else if (is.na(as.integer(seed)))
      stop("Seed must be a number or blank!")
    else
      seed <- as.integer(seed) ### FIXME warning for non-ints
    
    res <- ngram::babble(localstate$ng_mdl, genlen=input$ngram_babble_genlen, seed=seed)
  })
  
  res
})

output$analyse_ngram_babble <- renderUI({
  sidebarLayout(
    sidebarPanel(
      h5("Ngram Babbling"),
      sliderInput("ngram_babble_genlen", "Number of terms", min=5, max=500, value=100),
      textInput("ngram_babble_seed", "Seed"),
      actionButton("ngram_button_babble", "Generate"),
      render_helpfile("Ngram Babbling", "analyse/ngram_babble.md")
    ),
    mainPanel(
      renderText({
        must_have("corpus")
        must_have("ng_mdl")
        
        analyse_ngram_babble_reactive()
      })
    )
  )
})
