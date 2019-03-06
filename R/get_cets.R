
#' Extracting time series from the CompEngine database
#'
#'
#'
#'
#'
#'
#'
#' @examples
#' finance_m4 <- get_cets("M4_W138_Finance_1", category = FALSE)
#' a <- get_cets("real")
get_cets <- function(key, category = TRUE, maxpage = 10){
  URL <- "https://www.comp-engine.org"

  if(category){
    PATH <- paste0("api/public/timeseries/filter?format=json&category=",key,"&page=",1)
    content <- access_api(url = URL, path = PATH)
    content_list <- get_datalist(content)
    if(content$totalPages > 1 & maxpage !=1){
      content_rest <- lapply(2:min(maxpage, content$totalPages), category_rest, key = key)
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

category_rest <- function(key, page){
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
