# ============================================================================ #
# Añadir informacion de areas urbanas del sistema urbano nacional a cada folio 
# de las maestras
# Proyecto: Exposicion a largo plazo a PM2.5 y depresion en esmaestras
# Fecha:
# ============================================================================ #

# Paquetes a utilizar
library(tidyverse)
library(readxl)
library(sf)
library(janitor)


# Paso 1: Importar shape de folios (maestras)
folios <- 
  read_sf("./shapefiles/01_sites_pm25/sites_esmaestras.shp") %>% 
  print()

# Paso 2: Importar sahpe del Sistema Urbano Nacional
sun_2018 <- 
  read_sf("./shapefiles/SUN_2018/SUN_2018.shp") %>% 
  clean_names() %>% 
  print()

# Verifico que las proyecciones sean iguales
identical(st_crs(folios), st_crs(sun_2018)) 

# Reproyectar capas en caso de que las proyecciones sean diferentes
# folios <- st_transform(folios, crs = st_crs(sun_2018))
# 
# # Verificar que sean iguales, conservar la proyeccion oficial de mexico
# identical(st_crs(folios), st_crs(sun_2018)) 

# Paso 3: Unir información entre ambas capas
folios_sun <- 
  st_join(folios, sun_2018, join = st_within) %>% 
  st_set_geometry(NULL) %>% 
  print()

# Paso 4: Exportar la salida en formato .rds y .csv
write_rds(folios_sun, "./data/01_sun_esmaestras/folios_sun_esmaestras.rds")
write_excel_csv(folios_sun, "./data/01_sun_esmaestras/folios_sun_esmaestras.csv")
