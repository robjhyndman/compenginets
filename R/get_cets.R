
# Return time series where key matches some attribute
# or is a logical vector indicating which rows of meta to return.
get_cets <- function(key)
{
  # Find index for the required series
  if(is.logical(key) & length(key)==NROW(meta))
    idx <- key
  else
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
  for(j in seq(26L))
  {
    cets <- eval(paste("cets",1))
    k <- idx[(trunc(idx / 1000) + 1L) == j]
  }
  return(idx)
}

get_cets("finance")
