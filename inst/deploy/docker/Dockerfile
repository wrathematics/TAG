FROM rocker/shiny
MAINTAINER "Drew Schmidt" wrathematics@gmail.com

RUN apt-get update      \
  && apt-get install -y \
    libnetcdf-dev       \
    libssl-dev          \
    openjdk-8-jdk       \
    openjdk-8-jre       \
    libxml2-dev         \
    libgsl-dev


# some CRAN dependencies
RUN apt-get install -y  \
  r-cran-curl           \
  r-cran-rcpp           \
  r-cran-curl           \
  r-cran-ggplot2        \
  r-cran-knitr          \
  r-cran-gsl            \
  r-cran-rjava          \
  r-cran-xml2           \
  r-cran-tm

RUN R CMD javareconf

RUN r -e "install.packages(c('remotes', 'memuse', 'RColorBrewer', 'SnowballC',  \
  'qdap', 'markdown', 'rmarkdown', 'topicmodels', 'LDAvis', 'DT', 'ngram',      \
  'rvest'), repos='https://cran.rstudio.com/', dependencies='Imports')"



# install latest TAG R package build from github - WARNING THIS TAKES FOREVER
RUN r -e "remotes::install_github('XSEDEScienceGateways/TAG')"



# install tag shiny app build
ENV SHINY_PATH /srv/shiny-server
ENV TAG_PATH /usr/local/lib/R/site-library/TAG/tag/
RUN rm -rf ${SHINY_PATH}/*
RUN cp -r ${TAG_PATH}* ${SHINY_PATH}



# run the gateway
# CMD ["bash"] ### for debugging
CMD ["/usr/bin/shiny-server.sh"]
