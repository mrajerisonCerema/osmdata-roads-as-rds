library(osmdata)

q <- opq(bbox = c(51.1, 0.1, 51.2, 0.2))
q <- opq(bbox = 'greater london uk') %>%
  add_osm_feature(key = 'highway', value = 'motorway') %>%
  osmdata_sf ()

x <- opq(bbox = 'greater london uk') %>%
  add_osm_feature(key = 'highway', value = 'motorway') %>%
  osmdata_sf ()
