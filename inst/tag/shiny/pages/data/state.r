output$data_state <- renderUI({
  sidebarLayout(
    sidebarPanel(
      h4("Manage TAG State"),
      h5("Save state"),
      downloadButton('data_state_save', 'Save', class="dlButton"),
      br(),br(),br(),
      h5("Load state"),
      fileInput('data_state_file', label=NULL, accept=".rda"),
      br(),br(),
      h5("Clear state"),
      actionButton("button_data_input_clear", "Clear")
    ),
    mainPanel(
      renderUI(localstate$state_out)
    )
  )
})



# --------------------------------------------------------
# Save state
# --------------------------------------------------------

output$data_state_save <- downloadHandler(
  filename=function(){
    paste0("TAGstate_", gsub(Sys.Date(), pattern="-", replacement="."), ".rda")
  },
  content=function(file){
    saveRDS(object=localstate, file=file)
  }
)



# --------------------------------------------------------
# Load state
# --------------------------------------------------------


tag_load_state <- function(input)
{
  observe({
    statefile <- input$data_state_file
    
    if (!is.null(statefile))
    {
      runtime <- system.time({
        tmp <- readRDS(statefile$datapath)
        
        ### Check for breakage in state across versions
        check.tagversion(tmp$tagversion)
        
        localstate$tagversion <- get.tagversion()
        
        localstate$corpus <- tmp$corpus
        localstate$tdm <- tmp$tdm
        localstate$wordcount_table <- tmp$wordcount_table
        
        localstate$out <- tmp$input_out
        localstate$call <- tmp$call
        
        localstate$lda_mdl <- tmp$lda_mdl
        localstate$lda_out <- tmp$lda_out
        
        ### ngram relies on external memory that we lose control over :()
        localstate$ng_mdl <- NULL
        localstate$ng_out <- NULL
#        localstate$ng_mdl <- tmp$ng_mdl
#        localstate$ng_out <- tmp$ng_out
        
        localstate$explore_wordlens <- tmp$explore_wordlens
        
        rm(tmp);invisible(gc())
      })
      
      localstate$state_out <- HTML(paste("TAG state successfully loaded in", round(runtime[3], roundlen), "seconds."))
    }
    else
      localstate$state_out <- HTML("")
  })
  
  invisible()
}




# --------------------------------------------------------
# Clear state
# --------------------------------------------------------


clear_data <- function(input)
{
  observeEvent(input$button_data_input_clear, {
    if (input$button_data_input_clear > 0)
    {
      clear_state()
      localstate$state_out <- HTML("Cleared all internal state data!")
    }
  })
  
  
  invisible()
}



clear_modelstate <- function()
{
  localstate$explore_wordlens <- NULL
  
  localstate$lda_mdl <- NULL
  localstate$lda_out <- NULL
  
  localstate$ng_mdl <- NULL
  localstate$ng_pt <- NULL
  localstate$ng_out <- NULL
  
  invisible()
}

clear_state <- function()
{
  localstate$corpus <- NULL
  localstate$tdm <- NULL
  localstate$wordcount_table <- NULL
  
  localstate$input_out <- NULL
  
  localstate$call <- localstate_init_call()
  
  clear_modelstate()
  
  invisible()
}

