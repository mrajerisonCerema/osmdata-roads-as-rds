# @date : 21 Juillet 2021
# @desc : crée le fichier rds depuis les données shp du zip téléchargé
# @status :
# pre : 1-download-osm.R

library(glue)
library(stringr)
library(sf)
library(tidyverse)

source("scripts/load_data.R") # Lecture des données
load_data()

regions <- regs$NOM_REG_M

create_region_rds <- function(region, output_dir) {
  
  message(">> Traitement de ", region)
  
  # Lister les fichiers du dossier
  fichiers_zips <- list.files(file.path(output_dir, region), ".zip", full.names = T)
  fichier_rds <- file.path(output_dir, glue("{region}.rds"))
  if(file.exists(fichier_rds)) return()
  
  # UNZIP ----
  for (fichier_zip in fichiers_zips) {
    
    folder_name <- gsub(".*/(.*)-latest-free.shp.zip$", "\\1", fichier_zip)
    
    fichier_rds <- file.path(output_dir, region, glue("{folder_name}.rds"))
    print(fichier_rds)
    if(file.exists(fichier_rds)) return()
    
    cmd <- glue('"C:\\Program Files\\7-Zip\\7z" x "{fichier_zip}" -o"{output_dir}/{region}/{folder_name}"')
    # cmd <- glue('7z x "{fichier_zip}" -o"{output_dir}/{region}/{folder_name}"')
    system(cmd)
    
    # Export
    fichier_shp <- file.path(output_dir, region, folder_name, "gis_osm_roads_free_1.shp")
    f <- st_read(fichier_shp)
    f$zone <- folder_name
    saveRDS(f, fichier_rds)
  }
  
  # MERGE RDS ----
  fichiers_rds <- list.files(file.path(output_dir, region), ".rds", full.names = T)
  out <- vector(mode = "list")
  out <- lapply(fichiers_rds, function(x) {
    f <- readRDS(x)
    if("zone" %in% names(f)) {
      f <- f %>% select(-zone)
    }
    f
  }) # !! réactiver la zone
  res <- do.call(rbind, out)
  saveRDS(res, fichier_rds)
  
  # SUPPRESSION DU DOSSIER REGION ----
  dossier <- file.path(output_dir, glue("{region}"))
  if(!file.exists(dossier)) next
  
  cmd <- glue('rmdir /s /q "{dossier}"')
  system(cmd)
  shell(glue("rmdir /s /q '{dossier}'"))
}

create_region_rds(region = "ILE DE FRANCE", output_dir = "data-raw")