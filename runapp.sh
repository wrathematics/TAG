#!/bin/sh

Rscript -e "library(methods);shiny::runApp('./inst/tag', launch.browser=TRUE)"
