### Process a book in raw text format (e.g., from Project Gutenberg)
### as a tm corpus and output the file as an RData file.

library(tm)
sourcedir <- "./"

files <- dir(sourcedir)

for (file in files){
  name <- sub(file, pattern=".txt", replacement="")
  tmp <- Corpus(DirSource(sourcedir, pattern=name))
  saveRDS(file=paste0("../", name, ".rda"), object=tmp)
}

# readRDS()
