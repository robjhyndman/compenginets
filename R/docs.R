#' Category hierarchy informarion of CompEngine database.
#'
#' A list containing the category hierarchy chain of CompEngine data.
#' Each list contains subcategories of the first category listed (the name of the list).
#'
#'
#' @source \url{https://www.comp-engine.org/#!browse}
"cate_path"






#' Metadata informarion of CompEngine database.
#'
#' A dataset containing the  attributes of \code{cets} data. Attributes include \code{category}, \code{timeseries_id},
#' \code{timestamp_created}, \code{source}, \code{contributor}, \code{name},
#' \code{description}, \code{sampling_unit}, and \code{sampling_rate}.
#'
#' @format A data frame with 9 variables (the number of rows varies depending on the current size of CompEngine database):
#' \describe{
#'   \item{timeseries_id}{id of the time series}
#'   \item{timestamp_created}{time when the time series created}
#'   \item{source}{source of data measured}
#'   \item{category}{most specific possible category}
#'   \item{contributor}{creator who measured the data}
#'   \item{name}{name of the time series}
#'   \item{description}{detailed description of the data}
#'   \item{sampling_unit}{unit used in the time series}
#'   \item{sampling_rate}{measuring rate, assuming the data was measured from uniform sampling of some system through time}
#' }
#' @source \url{https://www.comp-engine.org/#!browse}
"meta"

#' Time series data from CompEngine database.
#'
#' Lists containing time series of type "numeric". Attributes attached. See also \code{?meta}.
#' To extract specific type of time series, see \code{?get_cets}.
#'
#' @format An object of class \code{list} of length 1000 except for the last set.
#' The length of the last set depends on the current size of CompEngine database.
#' @source \url{https://www.comp-engine.org/#!browse}
#' @name cets
NULL


#' @rdname cets
"cets1"

#' @rdname cets
"cets2"

#' @rdname cets
"cets3"

#' @rdname cets
"cets4"

#' @rdname cets
"cets5"

#' @rdname cets
"cets6"

#' @rdname cets
"cets7"

#' @rdname cets
"cets8"

#' @rdname cets
"cets9"

#' @rdname cets
"cets10"

#' @rdname cets
"cets11"

#' @rdname cets
"cets12"

#' @rdname cets
"cets13"

#' @rdname cets
"cets14"

#' @rdname cets
"cets15"

#' @rdname cets
"cets16"

#' @rdname cets
"cets17"

#' @rdname cets
"cets18"

#' @rdname cets
"cets19"

#' @rdname cets
"cets20"

#' @rdname cets
"cets21"

#' @rdname cets
"cets22"

#' @rdname cets
"cets23"

#' @rdname cets
"cets24"

#' @rdname cets
"cets25"


