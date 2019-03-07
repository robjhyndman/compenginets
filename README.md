<!-- README.md is generated from README.Rmd. Please edit that file -->

# compenginets: Data from CompEngine

The goal of compenginets is to provide all the time series from
<http://www.comp-engine.org/>.

## Installation

`compenginets` currently isn’t on CRAN.  
You can install the **development** version from
[Github](https://github.com/robjhyndman/compenginets)

``` r
# install.packages("devtools")
devtools::install_github("robjhyndman/compenginets")
```

## Usage

``` r
library(compenginets)
# cets_finance <- get_cets("finance")
W138_finance_m4 <- get_cets("M4_W138_Finance_1", category = FALSE)
str(W138_finance_m4)
#>  Time-Series [1:1044] from 1 to 1044: 2062 2086 2026 2076 2077 ...
#>  - attr(*, "name")= chr "M4_W138_Finance_1"
#>  - attr(*, "description")= chr ""
#>  - attr(*, "samplingInformation.samplingRate")= chr "1.00"
#>  - attr(*, "samplingInformation.samplingUnit")= chr "/week"
#>  - attr(*, "tags")= chr [1:3] "finance" "M4" "weekly"
#>  - attr(*, "category.name")= chr "Finance"
#>  - attr(*, "category.uri")= chr "real/finance/"
#>  - attr(*, "sfi.name")= chr [1:16] "CO_Embed2_Basic_tau.incircle_1" "CO_Embed2_Basic_tau.incircle_2" "FC_LocalSimple_mean1.taures" "DN_HistogramMode_10" ...
#>  - attr(*, "sfi.prettyName")= chr [1:16] "Autocorrelation measure" "Autocorrelation measure" "Predictability measure" "Distribution measure" ...
#>  - attr(*, "sfi.value")= num [1:16] 58.907 0.207 11.641 83.933 18.947 ...
#>  - attr(*, "source")= logi NA
```

## License

This package is free and open source software, licensed under CC0
