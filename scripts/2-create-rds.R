# @date : 21 Juillet 2021
# @desc : télécharge les données OSM depuis GeoFabrik
# @status :
# pre : 1-download-osm.R

library(glue)
library(stringr)
library(sf)

source("scripts/load_data.R") # Lecture des données
load_data()

regions <- regs$NOM_REG

for(region in regions) {
  
  message(">> Traitement de ", region)
  
  # Lister les fichiers du dossier
  zip_dir <- "D:/GIT/osmdata-roads-as-rds/data-raw"
  fichiers_zips <- list.files(file.path(zip_dir, region), ".zip", full.names = T)
  
  # UNZIP ----
  for (fichier_zip in fichiers_zips) {
    
    folder_name <- gsub(".*/(.*)-latest-free.shp.zip$", "\\1", fichier_zip)
    cmd <- glue('"C:\\Program Files\\7-Zip\\7z" x {fichier_zip} -o{zip_dir}/{region}/{folder_name}')
    cmd <- glue('7z x "{fichier_zip}" -o"{zip_dir}/{region}/{folder_name}"')
    system(cmd)
    
    # Export
    fichier_shp <- file.path(zip_dir, region, folder_name, "gis_osm_roads_free_1.shp")
    f <- st_read(fichier_shp)
    print(nrow(f))
    f$zone <- folder_name
    saveRDS(f, file.path(zip_dir, region, glue("{folder_name}.rds")))
  }
  
  # MERGE RDS ----
  fichiers_rds <- list.files(file.path(zip_dir, region), ".rds", full.names = T)
  out <- vector(mode = "list")
  out <- lapply(fichiers_rds, function(x) readRDS(x))
  res <- do.call(rbind, out)
  saveRDS(res, file.path(zip_dir, glue("{region}.rds")))
  
  # SUPPRESSION DU DOSSIER REGION ----
  dossier <- file.path(zip_dir, glue("{region}"))
  cmd <- glue('rmdir /s /q "{dossier}"')
  system(cmd)
  shell(glue("rmdir /s /q '{dossier}'"))
}