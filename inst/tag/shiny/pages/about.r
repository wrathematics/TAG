### 'About' tab

output$main_about <- renderUI({
  HTML(markdown::markdownToHTML("shiny/pages/about.md", fragment.only=TRUE, options=c("")))
})


