### 'About' tab

output$main_about <- renderUI({
  HTML(markdown::markdownToHTML("pages/about.md", fragment.only=TRUE, options=c("")))
})


