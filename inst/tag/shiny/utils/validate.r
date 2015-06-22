must_have <- function(obj)
{
  obj <- match.arg(tolower(obj), c("corpus", "tdm", "wordcount_table", "lda_mdl"))
  
  if (obj == "corpus" || obj == "tdm" || obj == "wordcount_table")
    validate(need(!is.null(localstate$corpus), 
      "You must first select a corpus from the 'Import' sub-tab of the 'Data' tab."))
  else if (obj == "lda_mdl")
    validate(need(!is.null(localstate$lda_mdl), 
      "You must first fit an LDA model from the 'Fit' sub-tab of the 'LDA' tab in the 'Analyse' menu."))
  
  invisible()
}
