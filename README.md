# Text Gateway 




* **Version:** 0.0.4
* ![Status](http://img.shields.io/badge/status-In_development_%28UNSTABLE%29-red.svg?style=flat)
* [![Build Status](https://travis-ci.org/XSEDEScienceGateways/textgateway.png)](https://travis-ci.org/XSEDEScienceGateways/textgateway)
* [![License](http://img.shields.io/badge/license-AGPL--3-orange.svg?style=flat)](https://www.gnu.org/licenses/agpl-3.0.html)
* **Authors:** &copy; Drew Schmidt and Mike Black


The Text Analytics Gateway (TAG) is an interactive webapp for
performing simple analyses on unstructured text.

When the gateway becomes mature enough, it will be made available
one XSEDE compute resources.  However, it is completely open
source and you are free to install it on your laptop or a different
remote resource.


## Installation

In addition to needing R, you need the following packages:

* shiny (>= 0.11.1),
* ggplot2 (>= 1.0.0),
* memuse (>= 1.1),
* tm (>= 0.6),
* wordcloud (>= 2.5),
* RColorBrewer (>= 1.0.5),
* SnowballC (>= 0.5.1),
* qdap (>= 2.2.0),
* markdown (>= 0.7.4),
* rmarkdown (>= 0.5.1),
* topicmodels (>= 0.2.1),
* LDAvis (>= 0.3.1),
* DT (>= 0.1),
* ngram (>= 2.0)


The easiest way to install this package is use the devtools package,
which will handle dependency resolution for you.  To install devtools,
you can run the following from R:

```r
install.packages("devtools")
```

From then on, you can install the current build of the textgateway
package via:

```r
devtools::install_github("XSEDEScienceGateways/textgateway")
```



## Launching

From a terminal, you can launch the app via the `runapp.sh` script.
If your web browser does not automatically open the web app, use
the url/port combo that it prints it's "listening on" in your
web browser.

You can also easily run the app from any interactive R session:

```r
library(textgateway)
textgateway()
```

