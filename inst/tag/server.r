library(TAG)
library(ggplot2)


shinyServer(
  function(input, output, session)
  {
    ### Any state objects should go here (treat it as a list)
    localstate <- reactiveValues()
    localstate$out <- "" # data loading output --- kind of a hack, but it seems necessary
    localstate$call <- "### WARNING: very experimental\nlibrary(TAG)\n\n" # R Markdown document for reproducibility
    localstate$tagversion <- get.tagversion()
    
    ### Number of digits to round timing values to
    roundlen <- 3
    
    options(shiny.maxRequestSize = 9*1024^2)
    
    
    ### Load the app
    files <- dir("./shiny", recursive=TRUE, pattern="[.]r$")
    files <- paste0("./shiny/", files)
    for (file in files) source(file=file, local=TRUE)
    
    
    set_data(input)
    clear_data(input)
  }
)
