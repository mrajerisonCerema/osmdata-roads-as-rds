find_region <- function(the_region) {
  
  l <- list("GRAND EST" = c("ALSACE"))
  
  for(i in 1:length(l)) {
    elt <- l[[i]]
    if(the_region %in% elt) {
      return(names(l)[i])
    }
  }
}


read_remote_rds_for_commune <- function(region, insee_com, nom_com, output_dir) {
  file_name <- glue("{insee_com}-{nom_com}.rds")
  output_file <- file.path(output_dir, file_name)
  url <- glue("https://github.com/mrajerisonCerema/osmdata-roads-as-rds/blob/master/{region}/{file_name}?raw=true")
  download.file(url, output_file, mode = "wb")
  f <- readRDS(output_file)
  # unlink(output_file)
  return(f)
}