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

  # download category information
  if(requireNamespace("jsonlite", quietly = TRUE)){
    cate_path <- try(category_scraping(), silent = TRUE)
    if("try-error" %in% class(cate_path))
      warning("An error occured when the category information was being downloaded.\n", cate_path)
    save(cate_path, file="data/cate_path.rda", compress="bzip2")
  } else warning("The package `jsonlite` is not installed. The category information cannot be updated.")
  cat("Data from CompEngine is up to date.\n")

  # Delete old version data and record date
  if(file.exists("data-raw/update-info.txt")){
    date_updated <- read.table("data-raw/update-info.txt", stringsAsFactors = FALSE)
    if(date_updated[NROW(date_updated),] != Sys.Date()){
      if(rm.old == TRUE){
        for(i in 1:NROW(date_updated)){
          upda <- date_updated[i,]
          last_points <- paste0("data-raw/comp-engine-export-datapoints.", gsub("-", "", upda), ".csv")
          last_meta <- paste0("data-raw/comp-engine-export-metadata.", gsub("-", "", upda), ".csv")
          if(file.exists(last_points)) file.remove(last_points)
          if(file.exists(last_meta)) file.remove(last_meta)
        }
        cat("Outdated raw data is removed.\n")
      }
      write.table(rbind(date_updated, as.character(Sys.Date())), "data-raw/update-info.txt")
    }
  } else  write.table(data.frame(date_updated=Sys.Date()), "data-raw/update-info.txt")
  cat("Updated date is recorded.\n")
}


convert_datapoints <- function(pointsrow, metarow){
  points <- as.numeric(unlist(strsplit(pointsrow$datapoints, ",")))
  attributes(points) <- metarow
  return(points)
}


category_scraping <- function(){
  cate_tree <- jsonlite::fromJSON("https://www.comp-engine.org/api/categories/browse")
  vec_tem <- unlist(cate_tree[[1]])
  attributes(vec_tem) <- NULL
  slug <- cate_tree$categories$slug
  slug <- c(slug, vec_tem[grep("/", vec_tem)])
  slug <- unique(gsub("-", " ", slug))
  category <- unique(unlist(strsplit(slug, "/")))
  cate_path <- setNames(split(category, seq(length(category))), category)
  cate_path <- mapply(walk_along, cate_path, MoreArgs = list(slug=slug), SIMPLIFY = FALSE)
  return(cate_path)
}

walk_along <- function(a_cat, slug){
  main <- a_cat
  road <- slug[grep(main, slug)]
  road <- gsub(paste0("^.*", main), "", road)
  subcat <- unique(unlist(strsplit(road, "/")))
  return(c(main,subcat[subcat!=""]))
}




