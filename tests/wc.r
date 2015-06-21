library(TAG)

test <- wc(c("a b a c a b b", "1 2 3
     4   5        6 ", "1 2 3 4"))
stopifnot(test == 17)


load("../inst/tag/data/books/alice.rda")
buk <- corpus[[1]]$content[1:10]
test <- wc(buk)
stopifnot(test == 16)
