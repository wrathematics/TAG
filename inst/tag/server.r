library(TAG)
library(ggplot2)


shinyServer(
  function(input, output, session)
  {
    ### Any state objects should go here (treat it as a list)
    localstate <- reactiveValues()
    
    ### Number of digits to round timing values to
    roundlen <- 3
    
    ### Load the app
    files <- dir("./shiny", recursive=TRUE, pattern="[.]r$")
    files <- paste0("./shiny/", files)
    for (file in files) source(file=file, local=TRUE)
    
    
    localstate$out <- ""
    set_data(input)
  }
)
