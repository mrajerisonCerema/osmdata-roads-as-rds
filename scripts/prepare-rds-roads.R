# date : 21 Juillet 2021
# description : sépare les données par région
# pre : merge-rds.R
# post : 
# outputs : shinyapp/data/roads/*.rds (rds par régions)

source("scripts/helpers.R")


library(tidyverse)

# Lecture des communes et régions
comms <- st_read("C:/Users/mathieu.rajerison/Documents/DATAS/ADMIN-EXPRESS-COG_2-1__SHP__FRA_L93_2020-03-25/ADMIN-EXPRESS-COG_2-1__SHP__FRA_2020-03-25/ADMIN-EXPRESS-COG/1_DONNEES_LIVRAISON_2020-03-25/ADE-COG_2-1_SHP_LAMB93_FR/COMMUNE_CARTO.shp") %>% 
  st_set_crs(2154) %>% st_transform(4326)
regions <- st_read("C:/Users/mathieu.rajerison/Documents/DATAS/ADMIN-EXPRESS-COG_2-1__SHP__FRA_L93_2020-03-25/ADMIN-EXPRESS-COG_2-1__SHP__FRA_2020-03-25/ADMIN-EXPRESS-COG/1_DONNEES_LIVRAISON_2020-03-25/ADE-COG_2-1_SHP_LAMB93_FR/REGION.shp")

# Récupération des données pour chaque région
l <- list.files("C:/Users/mathieu.rajerison/Documents/DATAS/OSM-ROUTE", ".rds")
the_regions <- l %>% toupper %>% {gsub("-", " ", .)} %>% {gsub(".RDS", "", .)}

# create_rds_for_region(the_region = "PROVENCE ALPES COTE D AZUR")
# create_rds_for_region(the_region = "BRETAGNE")

for(the_region in the_regions) {
  create_rds_for_region(the_region)
}