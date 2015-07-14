## N-Grams

An n-gram is an ordered sequence of "words" taken n at a time from a
body of text.  They can be very useful for discovering commonly used phrases
in a text.



For example, consider the sequence of "words" (separated by at least
one space)

> A B A C A B B

If we examine the 2-grams (or bigrams) of this sequence, they are

> A B, B A, A C, C A, A B, B B

or without repetition:

> A B, B A, A C, C A, B B

That is, we take the input string and group the words 2 at a time (because
we wanted to look at bigrams, so n=2).  Notice that the number of n-grams and
the number of words are not obviously related; counting repetition, the number
of n-grams is equal to

```
num_words - n + 1
```

