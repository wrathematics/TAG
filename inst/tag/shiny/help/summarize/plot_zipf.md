## Zipf Plot

<a href="https://en.wikipedia.org/wiki/Zipf%27s_law" target="_blank">Zipf's law</a>
says that the frequency of a word's occurrence in a text is 
inversely proportional to its rank in a frequency table.

While not particularly useful for understanding a corpus, it is
an interesting fact and the plot is useful for demonstration
purposes.

The Zipf plot from the `tm` package plots the logarithm of the
frequency against the logarithm of the rank, and evaluates the
goodness of fit of a linear model.
