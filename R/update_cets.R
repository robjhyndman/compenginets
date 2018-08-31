update_cets <- function(rm.old = TRUE){

  download.file("https://www.comp-engine.org/api/time-series/export?token=GN3hytnQKP8gfXFcmJwMgwWRs",
                "data-raw/data_raw.zip",
                mode = "wb")
  unzip("data-raw/data_raw.zip", exdir = "data-raw")
  cat("Data is downloaded and unziped.\n")
  datapoints <- paste0("data-raw/comp-engine-export-datapoints.",gsub("-", "", Sys.Date()), ".csv")
  metadata <- paste0("data-raw/comp-engine-export-metadata.",gsub("-", "", Sys.Date()), ".csv")
  meta <- read.csv(metadata, stringsAsFactors = FALSE)
  points <- read.csv(datapoints, stringsAsFactors = FALSE)

  #cets <- left_join(points, meta, by = "timeseries_id")
  #cets <- merge(x = points, y = meta, by = "timeseries_id", all.x = TRUE)
  cets <- setNames(split(points, seq(NROW(meta))), meta$name)
  metarow <- setNames(split(meta, seq(NROW(meta))), meta$name)
  cets <- mapply(convert_datapoints, pointsrow = cets, metarow = metarow, SIMPLIFY = FALSE)
  cat("Data is cleaned.\n")
  ns <- length(cets)
  for(i in seq(trunc(ns/1000)+1L))
  {
    idx <- (i-1)*1000 + seq(1000)
    idx <- idx[idx < ns]
    assign(paste0("cets", i), cets[idx])
    save(list=paste0("cets",i), file=paste0("data/cets",i,".rda"),compress="bzip2")
    # save(z, file=paste0("../data/cets",i,".rda"),compress="bzip2")
  }
  #save(cets, file="data/cets.rda", compress="bzip2")
  save(meta, file="data/meta.rda",compress="bzip2")
  cat("Data from CompEngine is up to date.\n")

  # Delete old version data and record date
  if(file.exists("data-raw/update-info.rds")){
    date_updated <- readRDS("data-raw/update-info.rds")
    if(tail(date_updated, 1) != Sys.Date()){
      if(rm.old == TRUE){
        for(i in 1:length(date_updated)){
          upda <- data_updated[i]
          last_points <- paste0("data-raw/comp-engine-export-datapoints.", gsub("-", "", upda), ".csv")
          last_meta <- paste0("data-raw/comp-engine-export-metadata.", gsub("-", "", upda), ".csv")
          if(file.exists(last_points)) file.remove(last_points)
          if(file.exists(last_meta)) file.remove(last_meta)
        }
        cat("Outdated raw data is removed.\n")
      }
      saveRDS(c(date_updated, Sys.Date()), "data-raw/update-info.rds")
    }
  } else  saveRDS(Sys.Date(), "data-raw/update-info.rds")
  cat("Last update is recorded.\n")
}

convert_datapoints <- function(pointsrow, metarow){
  points <- as.numeric(unlist(strsplit(pointsrow$datapoints, ",")))
  attributes(points) <- metarow
  return(points)
}
