library(shiny)


shinyUI(
  navbarPage("TAG", windowTitle="TAG: Text Analytics Gateway", id="nav_tag", 
    inverse=TRUE, collapsible=FALSE, 
#    theme="superhero.css", 
    
    
    tabPanel("About", uiOutput('main_about')),
    tabPanel("Data", uiOutput('main_data')),
    navbarMenu("Summarize",
      tabPanel("Basic", uiOutput("main_summarize_basic")),
      tabPanel("Plots", uiOutput("main_summarize_plot"))
    ),
    navbarMenu("Analyse",
      tabPanel("LDA", uiOutput("main_analyse_lda"))
    )
  )
)

