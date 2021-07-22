# @date : 21 Juillet 2021
# @desc : télécharge les données OSM depuis GeoFabrik
# @status : 

library(glue)
library(stringr)
library(sf)

for(region in regions) {
  
  message(">> Traitement de ", region)
  
  fichier_rds <- glue("C:/Users/mathieu.rajerison/Documents/DATAS/OSM-ROUTE/{region}.rds")
  fichier_zip <- glue("C:/Users/mathieu.rajerison/Documents/DATAS/OSM-ROUTE/{region}-latest-free.shp.zip")
  
  if(file.exists(fichier_rds)) next
  if(!file.exists(fichier_zip)) next
  
  url <- glue("https://download.geofabrik.de/europe/france/{region}-latest-free.shp.zip")
  output_dir <- "C:/Users/mathieu.rajerison/Documents/DATAS/OSM-ROUTE"
  dir.create(output_dir)
  download.file(url, destfile, mode = "wb")
}