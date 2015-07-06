library(TAG)
library(ggplot2)


shinyServer(
  function(input, output, session)
  {
    ### Any state objects should go here (treat it as a list)
    localstate <- reactiveValues()
    localstate$call <- localstate_init_call()
    localstate$tagversion <- get.tagversion() # state versioning
    
    ### Number of digits to round timing values to
    roundlen <- 3
    
    ### Set the max file (including state) upload size to 1/4*maxram (or 2 GiB if lookup fails)
    sysram <- try(as.numeric(memuse::Sys.meminfo()$totalram), silent=TRUE)
    if (inherits(sysram, "try-error"))
      sysram <- 2^31
    
    options(shiny.maxRequestSize = sysram)
    
    
    ### Load the app
    files <- dir("./shiny", recursive=TRUE, pattern="[.]r$")
    files <- paste0("./shiny/", files)
    for (file in files) source(file=file, local=TRUE)
    
    
    # Buttons in shiny are really annoying fyi
    set_data(input)
    tag_load_state(input)
    clear_data(input)
    analyse_lda(input)
    analyse_ngram(input)
  }
)
