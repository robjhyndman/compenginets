update_cets <- function(){

  download.file("https://www.comp-engine.org/api/time-series/export?token=GN3hytnQKP8gfXFcmJwMgwWRs",
                "data-raw/data_raw.zip",
                mode = "wb")
  unzip("data-raw/data_raw.zip", exdir = "data-raw")
  datapoints <- paste0("data-raw/comp-engine-export-datapoints.",gsub("-", "", Sys.Date()), ".csv")
  metadata <- paste0("data-raw/comp-engine-export-metadata.",gsub("-", "", Sys.Date()), ".csv")
  meta <- read.csv(metadata, stringsAsFactors = FALSE)
  points <- read.csv(datapoints, stringsAsFactors = FALSE)

  #cets <- left_join(points, meta, by = "timeseries_id")
  cets <- merge(x = points, y = meta, by = "timeseries_id", all.x = TRUE)
  save(cets, file="data/cets.rda", compress="bzip2")
  save(meta, file="data/meta.rda",compress="bzip2")
  cat("Data from CompEngine is up to date.")
  # Delete old version data and record date
  if(file.exists("data-raw/update-info.rds")){
    date_updated <- readRDS("data-raw/update-info.rds")
    if(tail(date_updated, 1) != Sys.Date()){
      last_points <- paste0("data-raw/comp-engine-export-datapoints.", gsub("-", "", tail(date_updated, 1)), ".csv")
      last_meta <- paste0("data-raw/comp-engine-export-metadata.", gsub("-", "", tail(date_updated, 1)), ".csv")
      if(file.exists(last_points)) file.remove(last_points)
      if(file.exists(last_meta)) file.remove(last_meta)
      saveRDS(c(date_updated, Sys.Date()), "data-raw/update-info.rds")
    }
  } else  saveRDS(Sys.Date(), "data-raw/update-info.rds")
}

