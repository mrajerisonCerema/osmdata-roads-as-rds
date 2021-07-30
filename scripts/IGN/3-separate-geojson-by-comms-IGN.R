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

home <- FALSE
load_data(home = FALSE, osm = FALSE)

nom_region <- "PROVENCE ALPES COTE D AZUR"

# READ ROADS
fichier_rds <- file.path("data-raw/IGN", glue("{nom_region}.rds"))
message("> Traitement de ", fichier_rds)
f <- readRDS(fichier_rds) %>% st_set_crs(2154)
  
# READ COMMUNES
if(!home) {
  regs$NOM_REG_M <- gsub("-", " ", regs$NOM_REG)
  regs$NOM_REG_M <- gsub("'", " ", regs$NOM_REG_M)
}
code_reg <- regs %>% dplyr::filter(NOM_REG_M == nom_region) %>% pull(INSEE_REG)
comms_reg <- comms %>% filter(INSEE_REG == code_reg) %>% arrange(INSEE_DEP, NOM_COM)
  
# CREATE REGION DIR
output_dir <- file.path("IGN", nom_region) # On met la donnée dans un sous-dossier, par ex. ILE DE FRANCE/IGN
dir.create(output_dir, recursive = T)

# INTERSECTION
int <- st_intersects(comms_reg, f) # On croise les rues avec les communes
f.4326 <- f %>% st_transform(4326)

# EXPORT
for(i in 1:nrow(int)) {
  comm <- comms_reg[i, ]
  
  nom_com <- comm$NOM_COM
  code_insee <- comm$INSEE_COM
  
  file_name <- glue("{code_insee}-{nom_com}.geojson")
  message(">> Traitement de ", nom_com, glue(" ({code_insee}) ({i})"))
  file_path <- file.path(output_dir, file_name)
  
  if(file.exists(file_path)) next # si le fichier existe, on passe
  
  w <- int[[i]]
  f.sel <- f.4326 %>% slice(w) # on extrait les rues correspondant à la commune
  
  st_write(f.sel, file_path)
}