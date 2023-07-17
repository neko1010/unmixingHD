import rasterio
from rasterio.merge import merge
from rasterio.plot import show
import glob
import os


## merge the rasters
dem_path = "../data/DEM/"
dem_files = os.listdir(dem_path)
print("FILES", dem_files)

src_files_to_mosaic = []

for f in dem_files:
    src = rasterio.open(os.path.join(dem_path,f))
    src_files_to_mosaic.append(src)

print(src_files_to_mosaic)

mosaic, out_trans = merge(src_files_to_mosaic)
print(out_trans)

## Looks wrong, but I think only because of the missing tile
show(mosaic[0])#, cmap = 'terrain')

## out filepath
out_fp = "../data/BigLostDEM.tif"

## copy the metadata
out_meta = src.meta.copy()

## update the output params
out_meta.update({
    'driver': 'GTiff',
    'height' : mosaic.shape[1],
    'width': mosaic.shape[2],
    'transform': out_trans})


## write the file
with rasterio.open(out_fp, 'w', **out_meta) as dest:
    dest.write(mosaic)


