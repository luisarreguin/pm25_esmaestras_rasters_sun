# ============================================================================ #
# generar rasters mensuales de pm2.5 en México
# Proyecto: Exposicion a largo plazo a pm2.5 y depresion en esmaestras
# Fecha:
# ============================================================================ #

# Paquetes a utilizar
library(tidyverse)
library(janitor)
library(sf)
library(raster)
library(ncdf4)

# Paso 1 - Definir ruta de entrada y variable =====
pm25_mensual <- "./data/00_pm25_satelital_0.01_mensual/2005/V5GL0502.HybridPM25.Global.200501-200501.nc"
varname <- "GWRPM25"

# Paso 2 - Leer atributos del NetCDF =====
ncfile <- ncdf4::nc_open(pm25_mensual)
ncdf4::ncatt_get(ncfile, varname, "units")      # unidades (ej. "ug m-3")
ncdf4::ncatt_get(ncfile, varname, "long_name")  # nombre largo 

# Paso 3 - Convertir NetCDF a raster =====
nc2raster <- raster::stack(pm25_mensual, varname = varname)

# Paso 4 - Recorte preliminar para México =====
# Extensión aproximada de México
mexico_extent <- extent(-118, -86, 14, 33)

# Recorte inicial
r_mexico_extent <- crop(nc2raster, mexico_extent)

# Visualizar
plot(r_mexico_extent, main = "PM2.5 mensual 2005_01 - Recorte por extensión México")

# Paso 5 - Cargar shapefile de México y reproyectar =====
# Shapefile de México
mexico_shp <- 
  read_sf("./shapefiles/mexico/00ent.shp", options = "ENCODING=LATIN1") %>% 
  clean_names() %>% 
  print()

# Verifico proyecciones
st_crs(nc2raster)
st_crs(mexico_shp)

# Reproyectar al CRS del raster
mexico_shp <- st_transform(mexico_shp, crs = st_crs(nc2raster))

identical(st_crs(nc2raster), st_crs(mexico_shp)) 

# Paso 6 - Recortar y enmascarar el raster con el shape =====
nc2raster_crop <- raster::crop(nc2raster, mexico_shp)
nc2raster_mask <- raster::mask(nc2raster_crop, mexico_shp)

# Visualizar
plot(nc2raster_mask, main = "PM2.5 mensual 2005_01 - Recorte por extensión México")

# Paso 7 - Guardar raster recortado y enmascarado =====
writeRaster(nc2raster_mask,
            "./shapefiles/pm25_mensual/2005/pm25_01_mexico.tif",
            format = "GTiff", overwrite = TRUE)
