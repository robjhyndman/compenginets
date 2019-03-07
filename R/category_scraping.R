

#' Download category information
#' @author Yangzhuoran Yang
#' @examples
#' cate_path <- category_scraping()
#' @export
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

