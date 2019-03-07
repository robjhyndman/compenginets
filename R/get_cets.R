
#' Extracting time series from the CompEngine database
#'
#' Return a time series with a specified name or a list of time series in a specified category.
#'
#' @param key The name of the time series or the name of the category,
#' depending on value of \code{category}
#' @param category If \code{TRUE}, the \code{get_cets}
#' will return time series whose category match the keyword or belong to
#' some subcategory under the matched category. If \code{FALSE},
#' the function will return time series with the name of \code{key}.
#' @param maxpage The maximum number of pages to extract.
#' Due to the number of time series that can be returned, a maximum of 10 time series are returned per page.
#' The default is 10 pages (100 time series). This argument is only valid when \code{category} is set to \code{TRUE}.
#' @return A list consisting of the selected series with class \code{ts}.
#'
#' NOTE: Due to the large variation in the properties of time series stored in the CompEngine database,
#' the \code{tsp} attribute (the start time in time units, the end time and the frequency) is not tailor made for each time series.
#' If needed, user can customize the \code{tsp} attribute based on the output attribute of \code{samplingInformation}.
#'
#' Some of the attributes are listed as follow:
#' \item{name}{The name of the time series}
#' \item{description}{the description of the time series}
#' \item{samplingInformation}{Indicating the frequency and other sampling related information}
#' \item{tags}{The tags in the database}
#' \item{category}{The name of the category and the hierarchy of the current category. See also \code{\link{category_scraping}}.}
#' \item{sfi}{"special feature identification" information}
#' \item{source}{The source of the time series}
#' \item{tsp}{Tsp Attribute of Time-Series-like Objects. See \code{\link{tsp}}}
#'
#'
#'
#' @author Yangzhuoran Yang
#' @examples
#' # Getting series within Finance category (including subcategory)
#' cets_finance <- get_cets("finance")
#' unique(mapply(attr, cets_finance, MoreArgs = list(which = "category.name")))
#' # Getting series by its name
#' W138_finance_m4 <- get_cets("M4_W138_Finance_1", category = FALSE)
#' @seealso \code{\link{category_scraping}}
#' @export
get_cets <- function(key, category = TRUE, maxpage = 10){
  URL <- "https://www.comp-engine.org"

  if(category){
    PATH <- paste0("api/public/timeseries/filter?format=json&category=",key,"&page=",1)
    content <- access_api(url = URL, path = PATH)
    content_list <- get_datalist(content)
    if(content$totalPages > 1 & maxpage > 1){
      content_rest <- lapply(2:min(maxpage, content$totalPages),
                             category_rest, key = key, URL = URL, PATH = PATH)
    }
    rest_list <- do.call(c,lapply(content_rest, get_datalist))

    end <- c(content_list, rest_list)
  } else {
    PATH <- paste0("api/public/timeseries?name=", key)
    content <- access_api(url = URL, path = PATH)

    name <- content$name
    description <- content$description
    samplingInformation <- content$samplingInformation
    source <- try(content$source, silent = TRUE)
    if(is.null(source)) source <- NA
    tags <- content$tags$name
    cnu <- as.data.frame(content$category[c("name","uri")], stringsAsFactors = F)

    sfi <- content$sfi
    data <- content$timeSeries[["raw"]]
    end <- give_attributes(data = data, name = name, description = description,
                  samplingInformation = samplingInformation,
                  tags = tags,  cnu = cnu, sfi = sfi, source = source)
  }
  return(end)
}



access_api <- function(url, path){
  raw_response <- httr::GET(url = url, path = path)
  raw_content <- rawToChar(raw_response$content)
  content <- jsonlite::fromJSON(raw_content)
  return(content)
}

category_rest <- function(key, page, URL, PATH){
  PATH <- paste0("api/public/timeseries/filter?format=json&category=",key,"&page=",page)
  access_api(url = URL, path = PATH)
}

get_datalist <- function(content){
  name <- content$timeSeries[,c("name")]
  name <- split(name, seq(NROW(name)))

  description <- content$timeSeries[,c("description")]
  description <- split(description, seq(NROW(description)))

  samplingInformation <- content$timeSeries[,c("name", "description", "samplingInformation")]
  samplingInformation <- split(samplingInformation, seq(NROW(samplingInformation)))

  source <- try(content$timeSeries[,"source"][,"name"], silent = TRUE)
  if(class(source) == "try-error") source <- rep(NA, NROW(name)) else
    source <- split(source, seq(NROW(source)))

  tags <- lapply(content$timeSeries[,"tags"], function(x) x[,"name"])

  cnu <- content$timeSeries[,"category"][,c("name","uri")]
  cnu <- split(cnu, seq(NROW(cnu)))

  sfi <- content$timeSeries[,"sfi"]
  data <- content$timeSeries$timeSeries[,"raw"]
  end <- mapply(give_attributes,data = data, name = name, description = description,
                samplingInformation = samplingInformation,
                tags = tags,  cnu = cnu, sfi = sfi, source = source, SIMPLIFY = FALSE)
  names(end) <- name
  return(end)
}

give_attributes <- function(data, name, description, samplingInformation, tags, cnu, sfi, source){
  attributes(data) <- c(name = name, description = description,
                        samplingInformation = samplingInformation,
                        tags = list(tags),  category = cnu, sfi = sfi, source = source)
  data <- ts(data)
  return(data)
}
