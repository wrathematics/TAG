### "Oh this seems like it won't be too ba---" *flips table*
evalfun <- function(arg, comment)
{
  call <- match.call()
  call[[1]] <- NULL
  call <- capture.output(call$arg)
  
  call <- gsub(call, pattern="localstate$", replacement="", fixed=TRUE)
  
  if (grepl(call, pattern="input$", fixed=TRUE))
  {
    split <- strsplit(call, split="input$", fixed=TRUE)[[1]]
    
    for (i in 2:length(split)) ### Here length is at least 2 b/c of grep; if you wonder why I'm bringing this up, 2:length(x) is non-empty if length(x) is 1. Welcome to R!
    {
      inputarg <- strsplit(split[i], split="(,|\\))")[[1]]
      inputarg_eval <- eval(parse(text=paste0("input$", inputarg[1])))
      
      for (finisher in c(",", ")"))
      {
        if (grepl(split[i], pattern=finisher))
        {
            split[i] <- paste0(inputarg_eval, finisher)
          
          if (length(inputarg) > 1)
            split[i] <- paste(split[i], paste(inputarg[2:length(inputarg)], collapse=", "), collapse=",")
        }
      }
    }
    
    call <- paste0(paste0(split, collapse=""), "\n")
  }
  
  if (!missing(comment))
    comment <- paste("#", comment)
  else
    comment <- ""
  
  localstate$call <- c(localstate$call, comment, call)
  
  arg
}


addto_call <- function(x)
{
  localstate$call <- c(localstate$call, x)
  
  invisible()
}

###input <- list(a=1, b=2)

###evalfun(c <- foo(input$a, x, y, input$b), input)
