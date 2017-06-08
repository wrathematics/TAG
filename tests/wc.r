library(TAG)

text <- c("a b a c a b b", "1 2 3
     4   5        6 ", "1 2 3 4")

test <- wc(text)
truth <-
structure(list(chars = 46L, letters = 7L, whitespace = 28L, punctuation = 0L, 
    digits = 10L, words = 17L, sentences = 0L, lines = 4L, wordlens = c(17L, 
    0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L
    ), senlens = c(0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 
    0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L), syllens = c(3L, 0L, 
    0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L)), .Names = c("chars", "letters", 
"whitespace", "punctuation", "digits", "words", "sentences", 
"lines", "wordlens", "senlens", "syllens"))

stopifnot(identical(test, truth))





load("../inst/extradata/books/alice.rda")
buk <- corpus[[1]]$content[1:10]
test <- wc(buk)
truth <-
structure(list(chars = 110L, letters = 92L, whitespace = 12L, 
    punctuation = 4L, digits = 2L, words = 16L, sentences = 2L, 
    lines = 10L, wordlens = c(0L, 2L, 3L, 1L, 1L, 0L, 5L, 0L, 
    0L, 3L, 1L, 0L, 0L, 0L, 0L, 0L), senlens = c(1L, 0L, 0L, 
    1L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 
    0L, 0L), syllens = c(5L, 2L, 2L, 0L, 0L, 0L, 0L, 0L, 0L, 
    0L)), .Names = c("chars", "letters", "whitespace", "punctuation", 
"digits", "words", "sentences", "lines", "wordlens", "senlens", 
"syllens"))

stopifnot(identical(test, truth))




buk <- corpus[[1]]$content[21:27]
test <- wc(buk)
truth <-
structure(list(chars = 359L, letters = 281L, whitespace = 66L, 
    punctuation = 12L, digits = 0L, words = 72L, sentences = 5L, 
    lines = 7L, wordlens = c(2L, 16L, 16L, 13L, 12L, 3L, 4L, 
    4L, 0L, 1L, 1L, 0L, 0L, 0L, 0L, 0L), senlens = c(1L, 1L, 
    0L, 1L, 0L, 0L, 1L, 0L, 0L, 0L, 0L, 0L, 0L, 1L, 0L, 0L, 0L, 
    0L, 0L, 0L), syllens = c(41L, 13L, 5L, 1L, 0L, 0L, 0L, 0L, 
    0L, 0L)), .Names = c("chars", "letters", "whitespace", "punctuation", 
"digits", "words", "sentences", "lines", "wordlens", "senlens", 
"syllens"))

stopifnot(identical(test, truth))
