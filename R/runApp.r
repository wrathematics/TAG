#' Run the Text Gateway App
#'
#' @export
runTAG <- function()
{
  shiny::runApp(file.path(system.file("tag", package="TAG")))
}
