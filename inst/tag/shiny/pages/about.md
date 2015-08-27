<!--- 
  NOTE: this file is modified by running `redocument`, via `README.Rmd`
  only the Version line is modified.
 -->

# TAG: Text Analysis Gateway

### Basic Text Analysis Tools Without the Programming

* **Version:** 0.0.11
* ![Status](http://img.shields.io/badge/status-In_development_%28UNSTABLE%29-red.svg?style=flat)
* [![Build Status](https://travis-ci.org/XSEDEScienceGateways/textgateway.png)](https://travis-ci.org/XSEDEScienceGateways/textgateway)
* [![License](http://img.shields.io/badge/license-AGPL--3-orange.svg?style=flat)](https://www.gnu.org/licenses/agpl-3.0.html)
* **Source:** [GitHub](https://github.com/XSEDEScienceGateways/textgateway)
* **Problems:** [Bug reports and feature reqests](https://github.com/XSEDEScienceGateways/textgateway/issues)
* **Authors:** The TAG Team:  Drew Schmidt and Mike Black



### Acknowledgements

This project's rapid creation would not have been possible without
the numerous excellent R packages available to us.  We wish to
acknowledge these and thank the authors for their work:

* [shiny](http://cran.r-project.org/web/packages/shiny/index.html), [markdown](http://cran.r-project.org/web/packages/markdown/index.html), and [rmarkdown](http://cran.r-project.org/web/packages/rmarkdown/index.html) --- the main interface for the gateway and help system
* [tm](http://cran.r-project.org/web/packages/tm/index.html), [SnowballC](http://cran.r-project.org/web/packages/SnowballC/index.html), [qdap](http://cran.r-project.org/web/packages/qdap/index.html), and [topicmodels](http://cran.r-project.org/web/packages/topicmodels/index.html) --- form the foundation of the preprocessing and analysis
* [ggplot2](http://cran.r-project.org/web/packages/ggplot2/index.html), [wordcloud](http://cran.r-project.org/web/packages/wordcloud/index.html), [RColorBrewer](http://cran.r-project.org/web/packages/RColorBrewer/index.html), and the incredible [LDAvis](http://cran.r-project.org/web/packages/LDAvis/index.html) --- the graphics and visualization stack
* Several features, such as the "popover" documentation and live markdown help rendering, inspired by [radiant](https://github.com/vnijs/radiant).

Additionally, we would like to thank: 

* Joe Cheng for answering several shiny questions.
* Mikhail Popov for help with a performance issue in our shiny usage.
* Bob Muenchen for his numerous helpful comments and suggestions.
* Christian Heckendorf for help with an innumerable number of questions.

Additionally, this project was created using XSEDE resources, services,
and expertise:

> John Towns, Timothy Cockerill, Maytal Dahan, Ian Foster, Kelly Gaither, Andrew Grimshaw, Victor Hazlewood, Scott Lathrop, Dave Lifka, Gregory D. Peterson, Ralph Roskies, J. Ray Scott, Nancy Wilkins-Diehr, "XSEDE: Accelerating Scientific Discovery", Computing in Science & Engineering, vol.16, no. 5, pp. 62-74, Sept.-Oct. 2014, doi:10.1109/MCSE.2014.80



### Theme

Note:  changing the theme may break everything; it's very experimental.

