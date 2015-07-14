must_have <- function(obj, silent=FALSE)
{
  obj <- match.arg(tolower(obj), c("corpus", "tdm", "wordcount_table", "lda_mdl", "ng_mdl"))
  
  if (obj == "corpus" || obj == "tdm" || obj == "wordcount_table")
  {
    if (silent)
      msg <- ""
    else
      msg <- "You must first select a text source from the 'Import' sub-tab of the 'Data' tab."
    
    validate(need(!is.null(localstate$corpus), msg))
  }
  else if (obj == "lda_mdl")
  {
    if (silent)
      msg <- ""
    else
      msg <- "You must first fit an LDA model from the 'Fit' sub-tab of the 'LDA' tab in the 'Analyse' menu."
    
    validate(need(!is.null(localstate$lda_mdl), msg))
  }
  else if (obj == "ng_mdl")
  {
    if (silent)
      msg <- ""
    else
      msg <- "You must first fit an ngram model from the 'Fit' sub-tab of the 'Ngram' tab in the 'Analyse' menu."
    
    validate(need(!is.null(localstate$ng_mdl), msg))
  }
  
  invisible()
}
