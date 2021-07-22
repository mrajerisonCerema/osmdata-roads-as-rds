# date : 21 Juillet 2021
# description : télécharge les données rds pour une commune donnée depuis github
# pre : prepare-rds-roads.R
# post : None
# input : https://github.com/mrajerisonCerema/test-rds ou https://github.com/mrajerisonCerema/osmdata-roads-as-rds
# output : None

source("scripts/helpers.R")
source("scripts/load_data.R")

f <- read_remote_rds_for_commune(region = "provence-alpes-cote-d-azur",
                                 insee_com = "04006",
                                 nom_com = "Allos", 
                                 output_dir = "../arretes-circulation-assistant/shinyapp/downloads")
