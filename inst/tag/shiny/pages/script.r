output$main_script <- renderUI({
  mainPanel(
    verticalLayout(
      renderUI(
        HTML(get_callscript())
      )
    )
  )
})


get_callscript <- function()
{
  code <- paste0(
"# TAG Script
This script is roughly what is run underneath TAG as you perform your
analysis.  The goal is to be able to enhance reproducibility, and
so that you can just re-run an analysis script if a small change is
needed, rather than remember what you clicked and in what order, etc.

HOWEVER, this feature is currently very experimental and should not be
considered fully implemented.

```r 
", paste0(localstate$call, collapse="\n"), 
"\n```")
  
  unclass(markdown::markdownToHTML(text=code, fragment.only=TRUE))
}

