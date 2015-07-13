# -----------------------------------------------------------
# Utils --- must be loaded here
# -----------------------------------------------------------

update_tdm <- function()
{
  evalfun(localstate$tdm <- tm::TermDocumentMatrix(localstate$corpus),
    comment="Update term-document matrix")
}


update_wordcount <- function()
{
  evalfun(localstate$wordcount_table <- sort(rowSums(as.matrix(localstate$tdm)), decreasing=TRUE), 
    comment="Update wordcount table")
}



# -----------------------------------------------------------
# shiny
# -----------------------------------------------------------

output$data_import <- renderUI({
  sidebarLayout(
    sidebarPanel(
      ### TODO
#      radioButtons(inputId="data_infile", label="Select File:", c("txt"="txt", "dir"="dir", "rda"="rda"), selected="txt", inline=TRUE),
      conditionalPanel(condition = "input.data_infile == 'state'",
        fileInput('uploadState', 'Load previous app state:', accept=".rda"),
        uiOutput("refreshOnUpload")
      ),
      selectizeInput("data_books", "Books", extradata_books_titles),
      actionButton("button_data_input_books", "Load Book"),
      
      br(),br(),
      
      selectizeInput("data_speeches", "Speeches", extradata_speeches_titles),
      actionButton("button_data_input_speeches", "Load Speech")
    ),
    mainPanel(
      renderUI(localstate$input_out)
    )
  )
})



set_data <- function(input)
{
  observeEvent(input$button_data_input_books, {
    if (input$button_data_input_books > 0)
    {
      clear_state()
      
      withProgress(message='Loading data...', value=0, {
        runtime <- system.time({
          book <- input$data_books
          bookfile <- extradata_books[which(extradata_books_titles == book)]
          
          load(paste0(extradata_data, "/books/", bookfile))
          
          localstate$corpus <- corpus
          localstate$tdm <- tdm
          localstate$wordcount_table <- wordcount_table
        })
        
        setProgress(1)
      })
      
      localstate$input_out <- HTML(paste("The<i>", input$data_books, "</i>corpus is now ready to use!\nLoading finished in", round(runtime[3], roundlen), "seconds."))
    }
  })
  
  
  observeEvent(input$button_data_input_speeches, {
    if (input$button_data_input_speeches > 0)
    {
      clear_state()
      
      withProgress(message='Loading data...', value=0, {
        runtime <- system.time({
          speech <- input$data_speeches
          speechfile <- extradata_speeches[which(extradata_speeches_titles == speech)]
          
          load(paste0(extradata_data, "/speeches/", speechfile))
          
          localstate$corpus <- corpus
          localstate$tdm <- tdm
          localstate$wordcount_table <- wordcount_table
        })
        
        setProgress(1)
      })
      
      localstate$input_out <- HTML(paste("The<i>", input$data_speeches, "</i>corpus is now ready to use!\nLoading finished in", round(runtime[3], roundlen), "seconds."))
    }
  })
  
  
  invisible()
}


#          data(crude, package="tm")
#          localstate$corpus <- crude
#          localstate$tdm <- tm::TermDocumentMatrix(localstate$corpus)
#          localstate$wordcount_table <- sort(rowSums(as.matrix(localstate$tdm)), decreasing=TRUE)
