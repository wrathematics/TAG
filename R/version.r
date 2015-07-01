#' @export
get.tagversion  <- function() packageVersion("TAG")



### Define breakages in state, if they ever are created.
get.oldestsupported <- function() as.package_version("0.0.7")



#' @export
check.tagversion <- function(version)
{
  if (version < get.oldestsupported())
    stop(paste0("The version this TAG statefile was created under (", version, ") is no longer supported.  You will need to recreate your analysis."))
  
  invisible(TRUE)
}
