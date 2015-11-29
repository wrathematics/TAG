### "Oh this seems like it won't be too ba---" *flips table*
evalfun <- function(arg, comment)
{
  call <- match.call()
  call[[1]] <- NULL
  call <- capture.output(call$arg)
  
  call <- gsub(call, pattern="localstate$", replacement="", fixed=TRUE)
  
  if (grepl(call, pattern="input$", fixed=TRUE))
  {
    m <- gregexpr(call, pattern="input\\$.*,", perl=TRUE)
    l1 <- regmatches(call, m)
    m <- gregexpr(call, pattern="input\\$[^,]*\\)", perl=TRUE)
    l2 <- regmatches(call, m)
    call_in <- c(l1, l2)
    
    ### Here length is at least 2 b/c of grep; if you wonder why I'm bringing this up, 2:length(x) is non-empty if length(x) is 1. Welcome to R!
    for (i in 1:length(call_in))
    {
      if (length(call_in[[i]]) == 0)
        next
      
      finisher <- regmatches(call_in[[i]], regexpr(call_in[[i]], pattern="(,|\\))"))
      inputarg <- gsub(call_in[[i]], pattern=finisher, replacement="")
      inputarg_eval <- eval(parse(text=inputarg))
      
      call <- gsub(call, pattern=inputarg, replacement=inputarg_eval)
    }
  }
  
  if (!missing(comment))
    comment <- paste("#", comment)
  else
    comment <- ""
  
  localstate$call <- c(localstate$call, comment, call)
  
  eval(arg)
}


addto_call <- function(x)
{
  localstate$call <- c(localstate$call, x)
  
  invisible()
}
