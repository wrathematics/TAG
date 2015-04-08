localsrc <- function(file) source(file=paste0("shiny/pages/", file), local=TRUE)


localsrc(file="about.r")

localsrc(file="data.r")
localsrc(file="data/manage.r")
localsrc(file="data/transform.r")

localsrc(file="summarize.r")
localsrc(file="summarize/basic.r")
localsrc(file="summarize/plot.r")

localsrc(file="analyse.r")
localsrc(file="analyse/lda.r")
