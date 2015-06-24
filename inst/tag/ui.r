library(shiny)


shinyUI(
  fluidPage(
    tags$footer(
      tags$link(rel="stylesheet", type="text/css", href="css/logo.css")
    ),
    
    navbarPage(
      title=div(a(href="http://xsede.org", target="new", img(src="img/xsede_small.png"))), 
      windowTitle="TAG: Text Analytics Gateway", id="nav_tag", 
      inverse=TRUE, collapsible=FALSE, 
      
      tabPanel("About", uiOutput('main_about')),
      tabPanel("Data", uiOutput('main_data')),
      navbarMenu("Summarize",
        tabPanel("Basic", uiOutput("main_summarize_basic")),
        tabPanel("Plots", uiOutput("main_summarize_plot"))
      ),
      navbarMenu("Analyse",
        tabPanel("LDA", uiOutput("main_analyse_lda")),
        tabPanel("N-Grams", uiOutput("main_analyse_ngram"))
      ),
      tabPanel("Help", uiOutput('main_help'))
    )
  )
)

