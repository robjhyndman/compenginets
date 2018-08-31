#' Extracting time series from the CompEngine database
#'
#' Return time series where key matches some attribute
#' or is a logical vector indicating which rows of meta to return.
#'
#'
#' @param key A keyword describing attribute of the required time series.
#' @param category_only A logical value indicating whether the selection process
#' search \code{key} in \code{category} attribute only. If set to \code{FALSE},
#' the function will also search the keyword in \code{source}, \code{name},
#' \code{timeseries_id},  \code{contributor}, and \code{description} attributes.
#' @return A list consisting of the selected series.
#' @author Rob Hyndman
#' @examples
#' cets_finance <- get_cets("finance")
#' @export get_cets
get_cets <- function(key, category_only = TRUE)
{
  # Find index for the required series
  if(is.logical(key) & length(key)==NROW(compenginets::meta))
    idx <- which(key)  else
    {
      if(category_only == TRUE){
        idx <- grep(key, compenginets::meta$category, ignore.case = TRUE)
      } else {
        idx <- c(grep(key, compenginets::meta$category, ignore.case = TRUE),
                 grep(key, compenginets::meta$source, ignore.case = TRUE),
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
