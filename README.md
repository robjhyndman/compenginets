<!-- README.md is generated from README.Rmd. Please edit that file -->
compenginets: Data from CompEngine
==================================

The goal of compenginets is to provide all the time series from
<http://www.comp-engine.org/>.  
24902 time series are available as of 2018-09-01.

Installation
------------

`compenginets` currently isn’t on CRAN.  
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
#>  num [1:10000] 333 333 340 328 330 ...
#>  - attr(*, "timeseries_id")= chr "003da696-3872-11e8-8680-0242ac120002"
#>  - attr(*, "timestamp_created")= chr "2018-04-05 01:38:11"
#>  - attr(*, "source")= chr "Yahoo Finance"
#>  - attr(*, "category")= chr "Opening prices"
#>  - attr(*, "contributor")= chr ""
#>  - attr(*, "name")= chr "FI_yahoo_Op_DJU"
#>  - attr(*, "description")= chr ""
#>  - attr(*, "sampling_unit")= chr ""
#>  - attr(*, "sampling_rate")= num NA
```

License
-------

This package is free and open source software, licensed under CC0
