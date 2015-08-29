# -----------------------------------------------------------
# Utils --- must be loaded here
# -----------------------------------------------------------

### Demand updates
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



### Updates lazily
update_secondary <- function()
{
  n <- 0L
  if (is.null(localstate$tdm))
    n <- n+1L
  if (is.null(localstate$wordcount_table))
    n <- n+1L
  
  if (n == 0L) 
    return(invisible())
  
  withProgress(message='', value=0, {
    i = 0
    
    if (is.null(localstate$tdm))
    {
      incProgress(0, message="Updating tdm...")
      update_tdm()
      setProgress(i/n)
      i <- i+1
    }
    
    if (is.null(localstate$wordcount_table))
    {
      incProgress(0, message="Updating wordcounts...")
      update_wordcount()
      setProgress(i/n)
    }
  })
  
  invisible()
}



# -----------------------------------------------------------
# shiny
# -----------------------------------------------------------

output$data_import <- renderUI({
  sidebarLayout(
    sidebarPanel(
      
      h4("Data Import"),
      
      radioButtons(inputId="data_input_type", 
                   label="Select Input Type",
                   c("Custom Data"="custom", "Example Data"="example"),
                   selected="", inline=FALSE),
      
      
      ### Custom data
      conditionalPanel(condition = "input.data_input_type == 'custom'",
        br(),
        radioButtons(inputId="data_input_method_custom", 
                     label="Input Method", 
                     c("Local File"="files", "Text Box"="box", "List of URL's"="urls"), 
                     selected="", inline=FALSE)
      ),
      
      # Local file
      conditionalPanel(condition = "input.data_input_type == 'custom' && input.data_input_method_custom == 'files'",
        br(),
        fileInput('data_localtext_file', label="Input File", 
        multiple=FALSE, ### FIXME
        accept=c(".txt"))
      ),
      
      # Text box
      conditionalPanel(condition = "input.data_input_type == 'custom' && input.data_input_method_custom == 'box'",
        br(),
        tags$textarea(id="data_input_textbox", rows=6, cols=40, ""),
        actionButton("button_data_input_textbox", "Load Textbox")
      ),
      
      # Lise of url's
      conditionalPanel(condition = "input.data_input_type == 'custom' && input.data_input_method_custom == 'urls'",
        br(),
        tags$textarea(id="data_input_urls", rows=6, cols=40, ""),
        actionButton("button_data_input_urls", "Scrape URL's")
      ),
      
      
      
      ### Example data
      conditionalPanel(condition = "input.data_input_type == 'example'",
        br(),
        radioButtons(inputId="data_input_method_example", 
                     label="Example Source", 
                     c("Book"="book", "Speech"="speech"), 
                     selected="", inline=FALSE)
      ),
      
      # Book
      conditionalPanel(condition = "input.data_input_type == 'example' && input.data_input_method_example == 'book'",
        br(),
        selectizeInput("data_books", "Books", extradata_books_titles),
        actionButton("button_data_input_books", "Load Book")
      ),
      
      # Speech
      conditionalPanel(condition = "input.data_input_type == 'example' && input.data_input_method_example == 'speech'",
        br(),
        selectizeInput("data_speeches", "Speeches", extradata_speeches_titles),
        actionButton("button_data_input_speeches", "Load Speech")
      ),
      
      render_helpfile("Data Input", "data/import.md")
    ),
    mainPanel(
      renderUI(localstate$input_out)
    )
  )
})




set_data <- function(input)
{
  ### Custom data
  
  # Local file
  tmp <- eventReactive(input$data_localtext_file, {
    textfile <- input$data_localtext_file
    
    if (!is.null(textfile))
    {
      clear_state()
      
      withProgress(message='Reading data...', value=0, {
        runtime <- system.time({
          dir <- sub(textfile$datapath, pattern="/[^/]*$", replacement="")
          
          setProgress(1/4, message="Creating corpus...")
          localstate$corpus <- tm::Corpus(tm::DirSource(dir))
          
          setProgress(1/2, message="Creating tdm...")
          localstate$tdm <- tm::TermDocumentMatrix(localstate$corpus)
          
          setProgress(3/4, message="Creating wordcounts...")
          localstate$wordcount_table <- sort(rowSums(as.matrix(localstate$tdm)), decreasing=TRUE)
        })
      })
      
      localstate$input_out <- HTML(paste("Successfully loaded and processed", length(dir(dir)), "file(s) in", round(runtime[3], roundlen), "seconds."))
    }
    else
      localstate$input_out <- HTML("")
  })
  
  observe(tmp())
  
  
  
  # Text box
  observeEvent(input$button_data_input_textbox, {
    if (input$button_data_input_textbox > 0)
    {
      clear_state()
      
      withProgress(message='Reading data...', value=0, {
        runtime <- system.time({
          text <- unlist(strsplit(input$data_input_textbox, split="\n"))
          
          setProgress(1/4, message="Creating corpus...")
          localstate$corpus <- tm::Corpus(tm::VectorSource(text))
          
          setProgress(1/2, message="Creating tdm...")
          localstate$tdm <- tm::TermDocumentMatrix(localstate$corpus)
          
          setProgress(3/4, message="Creating wordcounts...")
          localstate$wordcount_table <- sort(rowSums(as.matrix(localstate$tdm)), decreasing=TRUE)
        })
        
        setProgress(1)
      })
      
      localstate$input_out <- HTML(paste("Your text box corpus is now ready to use!\nLoading and processing finished in", round(runtime[3], roundlen), "seconds."))
    }
  })
  
  
  
  # List of url's
  observeEvent(input$button_data_input_urls, {
    if (input$button_data_input_urls > 0)
    {
      clear_state()
      
      withProgress(message='Scraping pages...', value=0, {
        runtime <- system.time({
          urls <- unlist(strsplit(input$data_input_urls, split="\n"))
          
          pages <- sapply(urls, function(url) rvest::html_text(rvest::html(url)))
          
          setProgress(1/2, message="Creating corpus...")
          localstate$corpus <- tm::Corpus(tm::VectorSource(pages))
        })
        
        setProgress(1)
      })
      
      localstate$input_out <- HTML(paste("Your web corpus is now ready to use!\nLoading and processing finished in", round(runtime[3], roundlen), "seconds."))
    }
  })
  
  
  
  
  ### Example data
  
  # Book
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
  
  
  
  # Speech
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
