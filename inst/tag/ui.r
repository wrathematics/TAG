library(shiny)


shinyUI(
  fluidPage(
    tags$head(
      tags$style(HTML("
        .shiny-output-error-validation {
          color: green;
        }
      "))
    ),
    tags$footer(
      tags$link(rel="stylesheet", type="text/css", href="css/logo.css")
    ),
    
    navbarPage(
      title=div(a(href="http://xsede.org", target="new", img(src="img/xsede_small.png"))), 
      windowTitle="TAG: Text Analytics Gateway", id="nav_tag", 
      inverse=TRUE, collapsible=FALSE, 
      
      tabPanel("About", uiOutput('main_about')),
      tabPanel("Data", uiOutput('main_data')),
      tabPanel("Explore", uiOutput("main_explore")),
      navbarMenu("Analyse",
        tabPanel("N-Grams", uiOutput("main_analyse_ngram")),
        tabPanel("LDA", uiOutput("main_analyse_lda"))
      ),
      tabPanel("Help", uiOutput('main_help'))
    )
  )
)

