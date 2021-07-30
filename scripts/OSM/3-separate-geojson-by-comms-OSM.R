# date : 21 Juillet 2021
# description : sépare les données par commune pour chaque région
# pre : 2-create-rds-for-region.R
# post : None
# outputs : shinyapp/data/roads/*.rds (rds par régions)

library(tidyverse)
library(sf)
library(glue)

source("scripts/helpers.R")
source("scripts/load_data.R") # Lecture des données
load_data()

nom_region <- "ILE DE FRANCE"

# READ ROADS
fichier_rds <- file.path("data-raw", glue("{nom_region}.rds"))
message("> Traitement de ", fichier_rds)
f <- readRDS(fichier_rds) %>% st_set_crs(4326)
  
# READ COMMUNES
code_reg <- regs %>% dplyr::filter(NOM_REG_M == nom_region) %>% pull(INSEE_REG)
comms_reg <- comms %>% filter(INSEE_REG == code_reg) %>% arrange(INSEE_DEP, NOM_COM)
  
# CREATE REGION DIR
output_dir <- nom_region
dir.create(output_dir, recursive = T)

# INTERSECTION
int <- st_intersects(comms_reg, f)

# EXPORT
for(i in 1:nrow(int)) {
  comm <- comms_reg[i, ]
  
  nom_com <- comm$NOM_COM
  insee_com <- comm$INSEE_COM
  
  file_name <- glue("{insee_com}-{nom_com}.geojson")
  message(">> Création de ", nom_com, " ", insee_com)
  file_path <- file.path(output_dir, file_name)
  
  if(file.exists(file_path)) next
  
  w <- int[[i]]
  f.sel <- f %>% slice(w)
  
  st_write(f.sel, file_path)
}