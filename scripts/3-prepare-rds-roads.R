# date : 21 Juillet 2021
# description : sépare les données par région
# pre : merge-rds.R
# post : 
# outputs : shinyapp/data/roads/*.rds (rds par régions)

library(tidyverse)
library(sf)
library(glue)

source("scripts/helpers.R")
source("scripts/load_data.R") # Lecture des données
load_data()

fichiers_rds <- list.files("D:/GIT/osmdata-roads-as-rds/data-raw", ".rds", full.names = T)

for(fichier_rds in fichiers_rds) {
  
  # fichier_rds <- fichiers_rds[1]
  
  message("> Traitement de ", fichier_rds)
  
  # Sélection des communes de la région ----
  nom_region <- gsub(".*/(.*)\\.rds", "\\1", fichier_rds)
  message(">> Traitement de la région ", nom_region)
  code_reg <- regs %>% dplyr::filter(NOM_REG == nom_region) %>% pull(INSEE_REG)
  comms_reg <- comms %>% filter(INSEE_REG == code_reg) %>% arrange(INSEE_DEP, NOM_COM)
  
  f <- readRDS(fichier_rds) %>%
    st_set_crs(4326)
  
  # Dossier d'export ----
  output_dir <- file.path(nom_region)
  dir.create(output_dir, recursive = T)
  
  for(i in 1:nrow(comms_reg)) {
    comm <- comms_reg[i, ]
    
    insee_com <- comm$INSEE_COM
    nom_com <- comm$NOM_COM
    
    message(">>> Traitement de ", nom_com, " ", insee_com)
    
    file_name <- glue("{insee_com}-{nom_com}.rds")
    file_path <- file.path(output_dir, file_name)
    
    if(file.exists(file_path)) next
    
    w <- st_intersects(comm, f) %>% unlist
    f.sel <- f %>% slice(w)
    print(nrow(f.sel))
    
    
    # Export de la donnée ----
    saveRDS(f.sel, file_path)
  }
}