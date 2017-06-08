library(shiny)


shinyUI(
  fluidPage(
    tags$head(
      tags$link(rel="stylesheet", type="text/css", href="css/bar.css"),
      
      tags$style(HTML(".shiny-output-error-validation {color: blue;}"))
    ),
    tags$footer(
      tags$link(rel="stylesheet", type="text/css", href="css/logo.css")
    ),
    
    navbarPage(
      title=div(a(href="http://github.com/wrathematics/TAG", target="new", img(src="img/tag_small.png"))), 
      windowTitle="TAG: Text Analytics Gateway", id="nav_tag", 
      inverse=TRUE, collapsible=FALSE, 
      
      tabPanel("Data", uiOutput('main_data')),
      tabPanel("Explore", uiOutput("main_explore")),
      navbarMenu("Analyse",
        tabPanel("N-Grams", uiOutput("main_analyse_ngram")),
        tabPanel("LDA", uiOutput("main_analyse_lda"))
      ),
      tabPanel("Script", uiOutput("main_script")),
      navbarMenu("Help",
        tabPanel("About", uiOutput('main_about')),
        tabPanel("Help", uiOutput('main_help'))
      )
    )
  )
)
