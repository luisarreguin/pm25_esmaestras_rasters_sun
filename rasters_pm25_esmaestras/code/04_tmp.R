library(raster)
library(sf)
library(tidyverse)

# 1. Load the NetCDF file as a raster object
r <- raster(
  "/Users/tex/Documents/r_test/pm25_esmaestras_rasters_sun/rasters_pm25_esmaestras/data/00_pm25_satelital_0.01_mensual/2005/V5GL0502.HybridPM25.Global.200501-200501.nc",
  varname = "GWRPM25"
)

mexico_extent <- extent(-118, -86, 14, 33)

r2 <- crop(r, mexico_extent)

plot(r2, main = "PM2.5 mensual 2005_01 - Recorte por extensión México")

p_t_g <- rasterToPolygons(r2, dissolve = FALSE, fun = NULL, na.rm = TRUE)

p_sf <- st_as_sf(p_t_g)

plot(st_geometry(p_sf))

st_write(p_sf, "~/Desktop/grid.shp")

is(p_sf)

p_sf

psf <-
  p_sf %>%
  rename(pm25_012025 = Hybrid.PM_2_._5...mug.m.3.) %>%
  rowid_to_column(var = "id_num") %>%
  mutate(id_celda = str_c("c_", str_pad(id_num, 7, pad = "0")), .before = 1) %>%
  print()

psf %>%
  arrange(desc(id_celda))

st_crs(psf)

st_write(psf, "~/Desktop/psf.shp")


# (Optional) You can aggregate or classify values using `cut` or `reclassify`
# before converting to reduce the number of unique polygons.
# rc <- cut(r, breaks = ...)

# 2. Convert raster cells to polygons
polygons_from_grid <- rasterToPolygons(
  r,
  dissolve = FALSE,
  fun = NULL,
  na.rm = TRUE
)

# 3. Convert to an sf object (modern R spatial standard)
polygons_sf <- st_as_sf(polygons_from_grid)

# 4. (Optional) Write to a new shapefile
# st_write(polygons_sf, "output_grid.shp")
