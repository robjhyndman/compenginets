library(tidyverse)
meta <- read.csv2("data_meta_export.csv", stringsAsFactors = FALSE) %>%
  as_tibble() %>%
  mutate(Length = as.numeric(Length))
# Remove strange rows
meta <- meta[-24949,]

# Function to return file as numeric object
cefile <- function(metarow)
{
  filename <- metarow$Filename
  j <- 0
  while(j < 8)
  {
    file <- paste0("Web_Time_Series_Files_",j,"/",filename)
    if(file.exists(file))
    {
      cets <- try(scan(file, quiet=TRUE), silent=TRUE)
      if("try-error" %in% class(cets))
      {
        cets <- try(scan(file, quiet=TRUE,sep=","), silent=TRUE)
        if("try-error" %in% class(cets))
          stop(paste("File",filename,"not readable"))
      }
      j <- 10
    }
    else
      j <- j+1
  }
  if(j == 8)
    stop(paste("File",filename,"not found"))
  attributes(cets) <- metarow
  return(cets)
}

# Read data
ns <- NROW(meta)
cets <- vector("list", ns)
names(cets) <- meta$Filename
for(i in seq_along(cets))
  cets[[i]] <- cefile(meta[i,])

# Store in objects of size 1000
ns <- length(cets)
for(i in seq(trunc(ns/1000)+1L))
{
  idx <- (i-1)*1000 + seq(1000)
  idx <- idx[idx < ns]
  z <- cets[idx]
  assign(paste0("cets", i), z)
  eval(parse(text =
               paste0("save(cets",i,", file=\"../data/cets",i,".rda\",compress=\"bzip2\")")))
  # save(z, file=paste0("../data/cets",i,".rda"),compress="bzip2")
}
save(meta, file="../data/meta.rda",compress="bzip2")


# # Find major category info
# category <- purrr::map_chr(strsplit(meta$Keywords,","),
#                            function(x){x[[1]][1]})
#
# tablecat <- table(category)
# majorcat <- names(tablecat)[tablecat > 300]
# for(cat in majorcat)
# {
#   z <- cets[category==cat]
#   save(z, file=paste0("../data/",cat,".rda"),compress="bzip2")
# }
# z <- cets[!(category %in% majorcat)]
# save(z, file="../data/other.rda", compress='bzip2')
#
#
