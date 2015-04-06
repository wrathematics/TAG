library(shiny)
library(memuse)
library(tm)
library(wordcloud)
library(memoise)
library(RColorBrewer)
library(SnowballC)
library(ggplot2)
#library(qdap)


source(file="utils.r")
stopwords_list <- c("danish", "dutch", "english", "finnish", "french", "german", "hungarian", "italian", "norwegian", "portuguese", "russian", "spanish", "swedish")


# manage, view, visualize, explore, transform
shinyServer(
  function(input, output, session)
  {
    ### Data preprocessing TODO
    data("crude")
    corpus <- crude
    assign("corpus", corpus, envir=session)
    
    tdm <- tm::TermDocumentMatrix(corpus)
    assign("tdm", tdm, envir=session)
    
    wordcount_table <- sort(rowSums(as.matrix(tdm)), decreasing=TRUE)
    assign("wordcount_table", wordcount_table, envir=session)
    
    source(file="sourceror.r", local=TRUE)
  }
)
