output$data_state <- renderUI({
  sidebarLayout(
    sidebarPanel(
      h4("Manage TAG State"),
      downloadButton('data_state_save', 'Save', class="dlButton"),
      fileInput('data_state_file', 'Choose file to upload', accept=".rda")
    ),
    mainPanel(
      htmlOutput("data_state_load")
    )
  )
})



output$data_state_save <- downloadHandler(
  filename=function(){
    paste0("TAGstate_", gsub(Sys.Date(), pattern="-", replacement="."), ".rda")
  },
  content=function(file){
    saveRDS(object=localstate, file=file)
  }
)



output$data_state_load <- renderUI({
  statefile <- input$data_state_file
  if (!is.null(statefile))
  {
    runtime <- system.time({
      tmp <- readRDS(statefile$datapath)
      
      localstate$tagversion <- get.tagversion()
      
      localstate$corpus <- tmp$corpus
      localstate$tdm <- tmp$tdm
      localstate$wordcount_table <- tmp$wordcount_table
      
      localstate$out <- tmp$out
      localstate$call <- tmp$call
      
      localstate$lda_mdl <- tmp$lda_mdl
      localstate$lda_out <- tmp$lda_out
      
      localstate$ng_mdl <- tmp$ng_mdl
      
      localstate$explore_wordlens <- tmp$explore_wordlens
      
      rm(tmp)
      gc()
    })
    
    HTML(paste("TAG state successfully loaded in", round(runtime[3], roundlen), "seconds."))
  }
  else
    HTML("")
})



