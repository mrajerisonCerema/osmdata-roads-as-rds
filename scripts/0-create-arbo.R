# description : créer l'arborescence des dossiers

library(glue)
library(stringr)
library(sf)

source("scripts/load_data.R") # Lecture des données
load_data()

noms_regions <- regs$NOM_REG_M
noms_regions <- c("ILE DE FRANCE", "PROVENCE ALPES COTES D AZUR")

for (nom_region in noms_regions) {
  dir.create(nom_region)
  dir.create(file.path("data-raw", nom_region))
}