find_region <- function(the_region) {
  
  l <- list("GRAND EST" = c("ALSACE"))
  
  for(i in 1:length(l)) {
    elt <- l[[i]]
    if(the_region %in% elt) {
      return(names(l)[i])
    }
  }
}

create_rds_for_region <- function(the_region1) {
  
  the_region <- find_region(the_region1)
  
  message(">> Traitement de la région ", the_region1, " > ", the_region)
  
  # Filtre selon la région
  code_reg <- regions %>% dplyr::filter(NOM_REG_M == the_region) %>% pull(INSEE_REG)
  comms_reg <- comms %>% filter(INSEE_REG == code_reg) %>% arrange(INSEE_DEP, NOM_COM)
  
  # Lecture du rds de la région
  the_region_s <- tolower(gsub(" ", "-", the_region1))
  fichier_rds <- paste0(the_region_s, ".rds")
  fichier_rds <- glue("C:/Users/mathieu.rajerison/Documents/DATAS/OSM-ROUTE/{fichier_rds}")
  
  if(!file.exists(fichier_rds)) {
    stop("Fichier rds ", fichier_rds, " inexistant")
  }
  
  f <- readRDS(fichier_rds) %>%
    st_set_crs(4326)
  
  # Dossier d'export
  output_dir <- file.path("../test-rds/", the_region)
  dir.create(output_dir, recursive = T)
  
  for(i in 1:nrow(comms_reg)) {
    comm <- comms_reg[i, ]
    
    insee_com <- comm$INSEE_COM
    nom_com <- comm$NOM_COM
    
    message(">> Traitement de ", nom_com, " ", insee_com)
    
    file_name <- glue("{insee_com}-{nom_com}.rds")
    file_path <- file.path(output_dir, file_name)
    
    if(file.exists(file_path)) next
    
    w <- st_intersects(comm, f) %>% unlist
    f.sel <- f %>% slice(w)
    
    saveRDS(f.sel, file_path)
  }
  
}

read_remote_rds_for_commune <- function(insee_com, nom_com) {
  file_name <- glue("{insee_com}-{nom_com}.rds")
  url <- glue("https://github.com/mrajerisonCerema/test-rds/blob/master/{file_name}?raw=true")
  output_file <- file.path("shinyapp/data/", file_name)
  download.file(url, output_file)
  f <- readRDS("shinyapp/data/", output_file)
  # unlink(output_file)
  return(f)
}