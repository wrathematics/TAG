#' TAG Versioning
#' 
#' Utilities used by the TAG system to ensure proper versioning across saved
#' state files.
#' 
#' @name versioning
#' @rdname versioning
NULL



#' @rdname versioning
#' @export
get.tagversion  <- function() packageVersion("TAG")



#' @param version A package version.
#' @rdname versioning
#' @export
check.tagversion <- function(version)
{
  OLDEST_SUPPORTED = as.package_version("0.0.7")
  if (version < OLDEST_SUPPORTED)
    stop(paste0("The version this TAG statefile was created under (", version, ") is no longer supported.  You will need to recreate your analysis."))
  
  invisible(TRUE)
}
