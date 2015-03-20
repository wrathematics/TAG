library(shiny)


pagetitle <- "Let's Get Textual"

shinyUI(
  navbarPage(pagetitle, id="nav_radiant", inverse=TRUE, collapsable=FALSE,
    
    tabPanel("About", uiOutput('main_about')),
    tabPanel("Data", uiOutput('main_data')),
    navbarMenu("Summarize",
      tabPanel("Basic", uiOutput("main_summarize_basic")),
      tabPanel("Plots", uiOutput("main_summarize_plot"))
    )
  )
)

