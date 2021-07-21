# @date : 21 Juillet 2021
# @desc : télécharge les données OSM depuis GeoFabrik
# @status : 

library(glue)
library(stringr)
library(sf)

regions <- c("aquitaine", 
             "alsace", 
             "basse-normandie", 
             "bourgogne",
             "bretagne",
             "centre",
             "champagne-ardennes",
             "corse",
             "franche-comte",
             "haute-normandie",
             "ile-de-france",
             "languedoc-roussillon",
             "limousin",
             "lorraine",
             "midi-pyrenees",
             "nord-pas-de-calais",
             "pays-de-la-loire",
             "picardie",
             "poitou-charentes",
             "provence-alpes-cote-d-azur",
             "rhone-alpes")

regions_downloaded <- list.files("C:/Users/mathieu.rajerison/Documents/DATAS/OSM-ROUTE", ".rds") %>% {gsub(".rds", "", .)}
message(">> Régions restant à télécharger : ", setdiff(regions, regions_downloaded) %>% paste(collapse = ", "))

for(region in regions) {
  
  message(">> Traitement de ", region)
  
  # region <- regions[1]
  fichier_rds <- glue("C:/Users/mathieu.rajerison/Documents/DATAS/OSM-ROUTE/{region}.rds")
  fichier_zip <- glue("C:/Users/mathieu.rajerison/Documents/DATAS/OSM-ROUTE/{region}-latest-free.shp.zip")
  
  if(file.exists(fichier_rds)) next
  if(!file.exists(fichier_zip)) next
  
  # # Download
  # url <- glue("https://download.geofabrik.de/europe/france/{region}-latest-free.shp.zip")
  # output_dir <- "C:/Users/mathieu.rajerison/Documents/DATAS/OSM-ROUTE"
  # dir.create(output_dir)
  # download.file(url, destfile, mode = "wb")
  # 
  # # Unzip
  cmd <- glue('"C:\\Program Files\\7-Zip\\7z" x {fichier_zip} -oC:/Users/mathieu.rajerison/Documents/DATAS/OSM-ROUTE/{region}')
  system(cmd)
  
  # Export
  fichier_shp <- glue("C:/Users/mathieu.rajerison/Documents/DATAS/OSM-ROUTE/{region}/gis_osm_roads_free_1.shp")
  f <- st_read(fichier_shp)
  # f2 <- f %>% dplyr::filter(!is.na(name))
  saveRDS(f, fichier_rds)
  
  # Suppression
  # l <- list.files("C:/Users/mathieu.rajerison/Documents/DATAS/OSM-ROUTE/", ".", full.names = T)
  # l <- l[-grep(".rds", l)]
  # sapply(l, function(x) unlink(x, recursive = TRUE))
  dossier <- glue("C:\\Users\\mathieu.rajerison\\Documents\\DATAS\\OSM-ROUTE\\{region}")
  system(glue("rmdir /s /q {dossier}"))
  shell(glue("rmdir /s /q {dossier}"))
  
}

# data <- read_csv("https://raw.githubusercontent.com/RobertMyles/Bayesian-Ideal-Point-IRT-Models/master/Senate_Example.csv")