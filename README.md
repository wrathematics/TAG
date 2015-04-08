# Text Gateway [![Build Status](https://travis-ci.org/XSEDEScienceGateways/textgateway.png)](https://travis-ci.org/XSEDEScienceGateways/textgateway) [![License](http://img.shields.io/badge/license-AGPL--3-orange.svg?style=flat)](https://www.gnu.org/licenses/agpl-3.0.html)



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
* rmarkdown (>= 0.5.1)


The easiest way to install is to use the devtools package, which
you can install via:

```r
install.packages("devtools")
```

From then on, you can install the textgateway package via:

```r
devtools::install_github("XSEDEScienceGateways/textgateway")
```



## Launching

You can launch the app via the `runapp.sh` script.  Use the url/port
combo that it prints it's "listening on" in your web browser.



