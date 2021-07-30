# @date : 21 Juillet 2021
# @desc : télécharge les données BDTOPO et crée une couche nationale des routes
# @status : unfinished

library(glue)
library(stringr)
library(sf)

deps_l93 <- str_pad(c(1:95), width = 3, pad = "0")
deps_l93 <- c(deps_l93, "2B", "2A")

for(dep in deps) {
  
  dep <- "003"
  
  # Download
  url <- glue("https://data.cquest.org/ign/bdtopo/latest/BDTOPO_3-0_TOUSTHEMES_GPKG_LAMB93_D{dep}_2021-06-15.7z")
  output_dir <- "C:/Users/mathieu.rajerison/Documents/DATAS/BDTOPO-ROUTE"
  dir.create(output_dir)
  destfile <- glue("C:/Users/mathieu.rajerison/Documents/DATAS/BDTOPO-ROUTE/BDTOPO-{dep}.7z")
  download.file(url, destfile, mode = "wb")
  
  # Unzip
  cmd <- glue('"C:\\Program Files\\7-Zip\\7z" x {destfile}')
  system(cmd)
  f <- st_read(glue("C:/Users/mathieu.rajerison/Documents/DATAS/BDTOPO-ROUTE/BDTOPO_3-0_TOUSTHEMES_GPKG_LAMB93_D{dep}_2021-06-15/BDTOPO/1_DONNEES_LIVRAISON_2021-06-00223/BDT_3-0_GPKG_LAMB93_D{dep}-ED2021-06-15/BDT_3-0_GPKG_LAMB93_D{dep}-ED2021-06-15.gpkg"), layer= "troncon_de_route") # access layer
  saveRDS(f, file.path(output_dir, glue("{dep}.rds")))
  
  # Suppression
  l <- list.files(output_dir, ".", full.names = T)
  l <- l[-grep(".rds", l)]
  sapply(l, function(x) unlink(x, recursive = TRUE))
  system(glue("rmdir /s /q C:\\Users\\mathieu.rajerison\\Documents\\DATAS\\BDTOPO-ROUTE\\BDTOPO_3-0_TOUSTHEMES_GPKG_LAMB93_D{dep}_2021-06-15"))
  
}