source(file="shiny/utils/help.r")
source(file="shiny/utils/validate.r")


### Filter globals
stopwords_list <- c("danish", "dutch", "english", "finnish", "french", "german", "hungarian", "italian", "norwegian", "portuguese", "russian", "spanish", "swedish")


### Data import---book globals
datadir <- system.file(package="TAG", "extradata")
booklist_names <- readLines(paste0(datadir, "/books/booklist_names.txt"))
booklist <- dir(paste0(datadir, "/books/"), pattern=".rda")


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

