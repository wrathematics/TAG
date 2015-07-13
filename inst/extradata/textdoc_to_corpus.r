### Process a raw text document as a tm corpus and output the
### file as an RData file.

# Folder structure is extradata/type/raw; formatted results go in 'type'

library(tm)

dirskip <- function(files, skipdir) files[!grepl(files, pattern=skipdir)]



files <- dir("./", pattern="[.]txt$", recursive=TRUE)
files <- dirskip(files, "books")
#files <- dirskip(files, "speeches")

for (file in files){
  cat(file, "\n")
  
  name <- sub(file, pattern=".txt", replacement="")
  name <- sub(name, pattern="^(.*/)", replacement="")
  
  rawdir <- sub(file, pattern="/[^/]*$", replacement="")
  outdir <- paste0(rawdir, "/../")
  
  corpus <- tm::Corpus(tm::DirSource(rawdir, pattern=paste0(name, ".txt"))
  tdm <- tm::TermDocumentMatrix(corpus)
  wordcount_table <- sort(rowSums(as.matrix(tdm)), decreasing=TRUE)
  
  save(corpus, tdm, wordcount_table, 
       file=paste0(outdir, name, ".rda"), 
       compress="xz")
  
}

