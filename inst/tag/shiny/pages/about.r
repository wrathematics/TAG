### 'About' tab

#output$main_about <- renderUI({
#  HTML(markdown::markdownToHTML("shiny/pages/about.md", fragment.only=TRUE, options=c("")))
#})


get_themes <- function() dir("www/css/themes/")

get_theme_names <- function()
{
  themes <- get_themes()
  themes <- gsub(themes, pattern="[.]min[.]css", replacement="")
  themes
}



output$main_about <- renderUI({
  verticalLayout(
    HTML(markdown::markdownToHTML("shiny/pages/about.md", fragment.only=TRUE, options=c(""))),
    tabPanel("Settings", 
      selectInput("tag_theme", label=h5("TAG Theme"), 
      choices=get_theme_names(), 
      selected="shiny"), type="pills"
    ),
    renderUI(
#      tags$head(tags$link(rel="stylesheet", type="text/css", href="css/shiny.css")),
      tags$head(tags$link(rel="stylesheet", type="text/css", href=paste0("css/themes/", input$tag_theme, ".min.css")))
    )
  )
})

