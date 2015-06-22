library(TAG)
library(ggplot2)



source(file="shiny/utils/help.r")
source(file="shiny/utils/validate.r")

stopwords_list <- c("danish", "dutch", "english", "finnish", "french", "german", "hungarian", "italian", "norwegian", "portuguese", "russian", "spanish", "swedish")

booklist_names <- readLines("data/books/booklist_names.txt")
booklist <- dir("data/books/", pattern=".rda")



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
  }
)
