# ============================================================================ #
# Abrir un archivo raster
# Proyecto: Exposicion a largo plazo a PM2.5 y depresion en esmaestras
# Fecha:
# ============================================================================ #

library(raster)
library(rasterVis)

# Leer un solo raster 
r <- raster("./shapefiles/pm25_mensual/2005/pm25_01_mexico.tif")

# Inspeccionar
print(r)
crs(r)
extent(r)
res(r)

# Mostrar en pantalla
plot(r)                

levelplot(r)     

