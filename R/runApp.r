#' Run the Text Gateway App
#'
#' @export
textgateway <- function()
{
  shiny::runApp(file.path(system.file("shiny", package="textgateway")))
}
