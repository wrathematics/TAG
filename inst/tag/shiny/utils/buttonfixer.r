# Shiny buttons record the number of clicks (rather than TRUE/FALSE
# or clicked/not clicked). This function is a little gross, but gets
# the job done of managing the state of buttons in the user's 
# session and each function call.  It returns a vector of logicals 
# that indicate whether or not a button's new state is different 
# from our last known value for it.
# 
# I'm assuming that only one button can be pressed at a time.
buttonfix <- function(session, ...)
{
  vals <- unlist(list(...))
  names <- paste0(".__shinyshim_", 1L:length(vals))
  changed <- rep(FALSE, length(names))
  
  changednames <- deparse(substitute(list(...)))
  changednames <- sub(x=changednames, pattern="list\\(", replacement="")
  changednames <- sub(x=changednames, pattern=".$", replacement="")
  changednames <- unlist(strsplit(changednames, ","))
  changednames <- sub(x=changednames, pattern=" +", replacement="")
  changednames <- sub(x=changednames, pattern="^[^\\$]*\\$", replacement="")
  names(changed) <- changednames
  
  if (!exists(names[1L], envir=session))
  {
    for (i in 1L:length(names))
      assign(x=names[i], value=vals[i], envir=session)
  }
  else
  {
    for (i in 1:length(names))
    {
      nm <- names[i]
      
      val <- get(x=nm, envir=session)
      if (val != vals[i])
      {
        assign(x=nm, value=vals[i], envir=session)
        changed[i] <- TRUE
        break
      }
    }
  }
  
  return(as.list(changed))
}


