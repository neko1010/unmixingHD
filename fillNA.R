#getting a raster
library(raster)

fileloc = "../data/modisETann/"

files = list.files(fileloc)

for (f in files) {
  r <- raster(paste0(fileloc, f)) #r is the object of class 'raster'.

  # replacing NA's by zero
  r[is.na(r[])] <- 0
  writeRaster(r, paste0("../data/modisETfill/", f))
}
