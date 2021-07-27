# description : convertit les rds en geojson
# pre : 3-separate-rds-by-comms.R
# date : 27 Juillet 2021

library(sf)

fichiers_rds <- list.files("PROVENCE ALPES COTE D AZUR", "*.rds", full.names = T)

for(fichier_rds in fichiers_rds){
  file_path <- gsub(".rds", ".geojson", fichier_rds)
  if(file.exists(file_path)) next
  f <- readRDS(fichier_rds)
  st_write(f, file_path)
}

for(fichier_rds in fichiers_rds){
  unlink(fichier_rds)
}

