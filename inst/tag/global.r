source(file="shiny/utils/help.r")
source(file="shiny/utils/validate.r")

stopwords_list <- c("danish", "dutch", "english", "finnish", "french", "german", "hungarian", "italian", "norwegian", "portuguese", "russian", "spanish", "swedish")

booklist_names <- readLines("data/books/booklist_names.txt")
booklist <- dir("data/books/", pattern=".rda")


helpdirs <- dir("shiny/help")
helppages <- lapply(helpdirs, function(page) dir(paste0("shiny/help/", page), pattern="[.]md$"))
names(helppages) <- helpdirs
