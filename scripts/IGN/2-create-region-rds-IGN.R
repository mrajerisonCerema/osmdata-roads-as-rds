# @date : 21 Juillet 2021
# @desc : crée le fichier rds depuis les données shp du zip téléchargé
# @status :
# pre : 1-download-osm.R

library(glue)
library(stringr)
library(sf)
library(tidyverse)

source("scripts/load_data.R") # Lecture des données

home <- FALSE

load_data(home = FALSE)

if(home) {
  path7z <<- "C:\\Program Files\\7-Zip\\7z"
} else {
  path7z <<- "7z"
}

regions <- regs$NOM_REG_M

create_region_rds_ign <- function(region, output_dir) {
  
  message(">> Traitement de ", region)
  
  # Lister les fichiers zips du dossier
  fichiers_zips <- list.files(file.path(output_dir, region), ".7z", full.names = T)
  rds_region <- file.path(output_dir, glue("{region}.rds")) # on paramètre le nom du rds final
  if(file.exists(rds_region)) return() # si le rds existe, on quitte
  
  # Unzip ----
  for (fichier_zip in fichiers_zips) {
    
    folder_name <- gsub(".*(D[0-9]{3}).*$", "\\1", fichier_zip) # le nom du dossier dézippé
    print(folder_name)
    
    fichier_rds <- file.path(output_dir, region, glue("{folder_name}.rds"))
    if(file.exists(fichier_rds)) next # si le fichier existe, on passe
    
    cmd <- glue('"{path7z}" x "{fichier_zip}" -o"{output_dir}/{region}/{folder_name}"')
    system(cmd)
    
    # Read GPKG ----
    fichier_gpkg <- file.path(output_dir, 
                              region, 
                              folder_name, 
                              glue("BDTOPO_3-0_TOUSTHEMES_GPKG_LAMB93_{folder_name}_2021-06-15/BDTOPO/1_DONNEES_LIVRAISON_2021-06-00223/BDT_3-0_GPKG_LAMB93_{folder_name}-ED2021-06-15/BDT_3-0_GPKG_LAMB93_{folder_name}-ED2021-06-15.gpkg"))
    f <- st_read(fichier_gpkg, layer="troncon_de_route")
    f$zone <- folder_name
    
    # Export rds ----
    saveRDS(f, fichier_rds)
  }
  
  # Merge RDS ----
  fichiers_rds <- list.files(file.path(output_dir, region), 
                             ".rds", 
                             full.names = T) # on liste les rds du dossier régional
  out <- vector(mode = "list")
  out <- lapply(fichiers_rds, function(x) {
    f <- readRDS(x)
    if("zone" %in% names(f)) {
      f <- f %>% select(-zone)
    }
    f
  }) # !! réactiver la zone
  res <- do.call(rbind, out) # on fusionne
  saveRDS(res, rds_region) # on enregistre
}

create_region_rds_ign(region = "PROVENCE ALPES COTE D AZUR", output_dir = "data-raw/IGN")
create_region_rds_ign(region = "ILE DE FRANCE", output_dir = "data-raw/IGN")