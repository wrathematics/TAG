#' Text Analytics Gateway
#' 
#' TODO
#' 
#' \tabular{ll}{ 
#'    Package: \tab textgateway \cr 
#'    Type: \tab Package \cr 
#'    License: \tab AGPL-3 \cr 
#' }
#' 
#' @name textgateway-package
#' @docType package
#' @author Drew Schmidt
#' 
#' @references 
#' Project home page: \url{https://github.com/XSEDEScienceGateways/textgateway}
#' 
#' @useDynLib TAG R_levenshtein_dist R_find_closest_word R_wc
#' 
#' @import shiny ggplot2 memuse SnowballC tm
#' 
#' @importFrom wordcloud wordcloud
#' @importFrom RColorBrewer brewer.pal
#' @importFrom qdap apply_as_df word_cor as.dtm
#' @importFrom markdown markdownToHTML
#' @importFrom rmarkdown render html_fragment
#' @importFrom topicmodels LDA terms
#' 
#' @keywords Package
NULL

