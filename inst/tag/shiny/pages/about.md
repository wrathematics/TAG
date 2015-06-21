# TAG: Text Analysis Gateway

## Basic Text Analysis Tools Without the Programming

* **Version:** 0.0.2
* ![Status](http://img.shields.io/badge/status-In_development_%28UNSTABLE%29-red.svg?style=flat)
* [![Build Status](https://travis-ci.org/XSEDEScienceGateways/textgateway.png)](https://travis-ci.org/XSEDEScienceGateways/textgateway)
* [![License](http://img.shields.io/badge/license-AGPL--3-orange.svg?style=flat)](https://www.gnu.org/licenses/agpl-3.0.html)
* **Authors:** &copy; Drew Schmidt and Mike Black


TAG is a web-app that contains a collection of useful utilities for
performing text analyses.  Each analysis element contains this icon:
<i title='Help' class='glyphicon glyphicon-question-sign'></i>.
If you click it, additional information and help will pop up.

Source code available on the project's [GitHub page](https://github.com/XSEDEScienceGateways/textgateway).
Powered by [Shiny](http://www.rstudio.com/shiny/).
All documentation is released under a
<a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank">Creative Commons License</a>.
<img alt="" style="border-width:0" src="img/cc.png">

This project's rapid creation would not have been possible without
the numerous excellent R packages available to us.  We wish to
acknowledge these and thank the authors for their work:

* [shiny](http://cran.r-project.org/web/packages/shiny/index.html), [markdown](http://cran.r-project.org/web/packages/markdown/index.html), and [rmarkdown](http://cran.r-project.org/web/packages/rmarkdown/index.html) --- the main interface for the gateway and help system
* [tm](http://cran.r-project.org/web/packages/tm/index.html), [SnowballC](http://cran.r-project.org/web/packages/SnowballC/index.html), [qdap](http://cran.r-project.org/web/packages/qdap/index.html), and [topicmodels](http://cran.r-project.org/web/packages/topicmodels/index.html) --- form the foundation of the preprocessing and analysis
* [ggplot2](http://cran.r-project.org/web/packages/ggplot2/index.html), [wordcloud](http://cran.r-project.org/web/packages/wordcloud/index.html), [RColorBrewer](http://cran.r-project.org/web/packages/RColorBrewer/index.html), and the incredible [LDAvis](http://cran.r-project.org/web/packages/LDAvis/index.html) --- the graphics and visualization stack

Additionally, we would like to thank Mikhail Popov for help with
a performance issue in our shiny usage.
