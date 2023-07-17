import rasterio
from rasterio.merge import merge
import os

external = "/media/think/Elements/FCPG/"
for root, dirs, files in os.walk(external):
    #print(dirs)
    years = range(2004, 2020, 1)
    for dir in dirs:
        files = os.listdir(os.path.join(external,dir))
        for year in years:
            to_merge = []
            for f in files:
                if year in f:
                    ras = rasterio.open(os.path.join(external, dir, f))
                    to_merge.append(ras)
            print(to_merge)
            merged, trans = merge(to_merge)
            with rasterio.Env():
                ##Write the array as a raster to 8-bit file
                profile = ras.meta

                ## set the band count to 1, dtype to float32 and LZW compression
                profile.update(
                        dtype = rasterio.float32,
                        count =1, 
                        compress = 'lzw')

                with rasterio.open(os.path.join(external, dir, "{}_{}.tif".format(dir,year)), 'w', **profile) as dst:
                    dst.write(array.astype(rasterio.float32),1)
                    print(dst, " written")
