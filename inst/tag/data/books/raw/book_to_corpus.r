### Process a book in raw text format (e.g., from Project Gutenberg)
### as a tm corpus and output the file as an RData file.

library(tm)
sourcedir <- "./"

files <- dir(sourcedir, pattern="[.]txt")

for (file in files){
  name <- sub(file, pattern=".txt", replacement="")
  
  corpus <- Corpus(DirSource(sourcedir, pattern=name))
  tdm <- tm::TermDocumentMatrix(corpus)
  wordcount_table <- sort(rowSums(as.matrix(tdm)), decreasing=TRUE)
  
  save(corpus, tdm, wordcount_table, file=paste0("../", name, ".rda"))
}

