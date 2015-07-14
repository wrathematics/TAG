source(file="shiny/utils/help.r")
source(file="shiny/utils/validate.r")



### Filter globals
stopwords_list <- c("danish", "dutch", "english", "finnish", "french", "german", "hungarian", "italian", "norwegian", "portuguese", "russian", "spanish", "swedish")



### Data import
extradata_data <- system.file(package="TAG", "extradata")

# book globals
extradata_books_titles <- readLines(paste0(extradata_data, "/books/titles"))
extradata_books <- dir(paste0(extradata_data, "/books/"), pattern=".rda")

# speech globals
extradata_speeches_titles <- readLines(paste0(extradata_data, "/speeches/titles"))
extradata_speeches <- dir(paste0(extradata_data, "/speeches/"), pattern=".rda")



### Help system globals
helpdirs <- dir("shiny/help")
helppages <- lapply(helpdirs, function(page) dir(paste0("shiny/help/", page), pattern="[.]md$"))
names(helppages) <- helpdirs
helpdirs_display <- c("", helpdirs)
names(helpdirs_display) <- c("", from_md_to_display(helpdirs))



### Misc globals
localstate_init_call <- function()
{
  "### WARNING: very experimental\nlibrary(TAG)\n\n"
}

plotnote <- HTML("NOTE: to save the image, right click it and select \"Save Image As\".")

