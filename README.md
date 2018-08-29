<!-- README.md is generated from README.Rmd. Please edit that file -->
compenginets: Data from CompEngine
==================================

The goal of compenginets is to provide all the time series from
<http://www.comp-engine.org/>.  
25648 time series are available as of 23rd August 2018.

Installation
------------

You can install the **development** version from
[Github](https://github.com/robjhyndman/compenginets)

``` r
# install.packages("devtools")
devtools::install_github("robjhyndman/compenginets")
```

Usage
-----

``` r
library(compenginets)
cets_finance <- get_cets("finance")
str(cets_finance[[1]])
#>  num [1:2391] 64.3 42 52.4 43.7 48 ...
#>  - attr(*, "Filename")= chr "FI_yahoo_HL_000001_SS.dat"
#>  - attr(*, "Keywords")= chr "finance,yahoo,opening"
#>  - attr(*, "Length")= num 2391
#>  - attr(*, "Description")= chr ""
#>  - attr(*, "SourceString")= chr "Yahoo Finance"
#>  - attr(*, "CategoryString")= chr "High low"
```

License
-------

This package is free and open source software, licensed under CC0
