#' Extracting time series from the CompEngine database
#'
#' Return time series where key matches some attribute
#' or is a logical vector indicating which rows of meta to return.
#'
#'
#' @param key A keyword describing attribute of the required time series
#' @return A list consisting of the selected series.
#' @author Rob Hyndman
#' @examples
#' cets_finance <- get_cets("finance")
#' @export get_cets
get_cets <- function(key)
{
  # Find index for the required series
  if(is.logical(key) & length(key)==NROW(meta))
    idx <- which(key)  else
  {
    idx <- c(grep(key, meta$Filename),
             grep(key, meta$Keywords),
             grep(key, meta$Description),
             grep(key, meta$SourceString),
             grep(key, meta$CategoryString))
    idx <- sort(unique(idx))
  }
  # Now go and grab the series from the various data objects
  mydata <- list()
  for(j in seq(26L)){
   # cets <- eval(paste0("cets",j))
    k <- idx[(trunc(idx / 1000) + 1L) == j & idx %% 1000 !=0]
    k <- c(k, idx[(trunc(idx / 1000) + 1L) == j+1 & idx %% 1000 ==0])
    if(length(k)==0) next
    tmpdata <- get(paste0("cets",j))
    mydata <-  append(mydata, tmpdata[k-(1000*(j-1))])
  }
  if(length(mydata) == 0) warning("No matched time serie was found")
  return(mydata)
}

#get_cets("finance")
