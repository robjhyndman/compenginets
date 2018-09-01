#' Extracting time series from the CompEngine database
#'
#' Return time series where key matches some attribute
#' or is a logical vector indicating which rows of meta to return.
#'
#'
#' @param key A keyword describing attribute of the required time series,
#' or a logical vector indicating which rows of meta to return.
#' @param category A logical value indicating whether the selection process
#' search \code{key} in \code{category} attribute. If \code{TRUE}, the \code{get_cets}
#' will return time series whose category match the keyword and the time series that belong to
#' some subcategory under the matched category. If \code{FALSE},
#' the function will return time series which have the keyword in their \code{source}, \code{name},
#' \code{timeseries_id},  \code{contributor}, or \code{description} attributes.
#' This argument is only valid when \code{key} is not a logical vector.
#' @return A list consisting of the selected series.
#' @author Rob J Hyndman
#' @author Yangzhuoran Yang
#' @examples
#' # Getting series within Finance category (including subcategory)
#' cets_finance <- get_cets("finance")
#' unique(mapply(attr, cets_finance, MoreArgs = list(which = "category")))
#'
#' # Getting series whose sourse is Macaulay Library
#' cets_ML <- get_cets("Macaulay Library", category = FALSE)
#' unique(mapply(attr, cets_ML, MoreArgs = list(which = "source")))
#'
#' # Extract time series by a logical vector with length equals to the number of series
#' idx <- sample(c(T, F), NROW(meta), T)
#' cets_logic <- get_cets(idx)
#' @export get_cets
get_cets <- function(key, category = TRUE){
  # Find index for the required series
  if(is.logical(key) & length(key)==NROW(compenginets::meta))
    idx <- which(key)  else
    {
      if(category == TRUE){
      category_list <- names(cate_path)
      cidx <- grep(key, category_list, ignore.case = TRUE)
      if(length(cidx)==0) stop("No category matches the keyword.")
      cidx <- cate_path[[cidx]]
      idx <- sapply(cidx, grep, x=compenginets::meta$category, ignore.case = TRUE)
      idx <- unlist(idx)
    } else {
      idx <- c(grep(key, compenginets::meta$source, ignore.case = TRUE),
               grep(key, compenginets::meta$name, ignore.case = TRUE),
               grep(key, compenginets::meta$timeseries_id, ignore.case = TRUE),
               grep(key, compenginets::meta$contributor, ignore.case = TRUE),
               grep(key, compenginets::meta$description, ignore.case = TRUE))
    }

      idx <- sort(unique(idx))
    }
  if(length(idx) == 0) stop("No matched time series was found")
  # Now go and grab the series from the various data objects
  mydata <- list()
  ns <- NROW(meta)
  for(j in seq(trunc(ns/1000)+1L)){
    # cets <- eval(paste0("cets",j))
    k <- idx[(trunc(idx / 1000) + 1L) == j & idx %% 1000 !=0]
    k <- c(k, idx[(trunc(idx / 1000) + 1L) == j+1 & idx %% 1000 ==0])
    if(length(k)==0) next
    tmpdata <- get(paste0("cets",j))
    mydata <-  append(mydata, tmpdata[k-(1000*(j-1))])
  }
  return(mydata)
}


# Old version
# get_cets <- function(key)
# {
#   # Find index for the required series
#   if(is.logical(key) & length(key)==NROW(compenginets::meta))
#     idx <- which(key)  else
#     {
#       idx <- c(grep(key, compenginets::meta$Filename),
#                grep(key, compenginets::meta$Keywords),
#                grep(key, compenginets::meta$Description),
#                grep(key, compenginets::meta$SourceString),
#                grep(key, compenginets::meta$CategoryString))
#       idx <- sort(unique(idx))
#     }
#   # Now go and grab the series from the various data objects
#   mydata <- list()
#   for(j in seq(26L)){
#     # cets <- eval(paste0("cets",j))
#     k <- idx[(trunc(idx / 1000) + 1L) == j & idx %% 1000 !=0]
#     k <- c(k, idx[(trunc(idx / 1000) + 1L) == j+1 & idx %% 1000 ==0])
#     if(length(k)==0) next
#     tmpdata <- get(paste0("cets",j))
#     mydata <-  append(mydata, tmpdata[k-(1000*(j-1))])
#   }
#   if(length(mydata) == 0) warning("No matched time series was found")
#   return(mydata)
# }

#get_cets("finance")
