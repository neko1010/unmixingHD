import rasterio
from rasterio.merge import merge
import os
import sys

#external = "/media/think/Elements/FCPG/"
param = sys.argv[1]
#external = os.path.join("~/scratch/FCPGs/", param)
external = "./FCPGs/"
print(external)
years = [2004, 2006, 2008, 2011, 2013, 2016, 2019] 
#years = range(int(sys.argv[2]), int(sys.argv[3]), 1)
#print(years)
files = os.listdir(os.path.join(external, param))
print(files)
for year in years:
	to_merge = []
	for f in files:
		if str(year) in f:
			ras = rasterio.open(os.path.join(external, param, f))
			to_merge.append(ras)
	print(to_merge)
	merged, trans = merge(to_merge, indexes = 1)
	print("OUT TRANSFORM?", trans)
	with rasterio.Env():
		##Write the array as a raster to 8-bit file
		out_meta  = ras.meta.copy()
	## set the band count to 1, dtype to float32 and LZW compression
		#profile.update(
		#	dtype = rasterio.float32,
		#	count =1, 
		#	compress = 'lzw',
		#	)
		out_meta.update({"driver": "GTiff",
				"height": merged.shape[1],
				"width": merged.shape[2],
				"transform": trans})

	with rasterio.open(os.path.join(external, "{}_{}.tif".format(param,year)), 'w', **out_meta) as dst:
			dst.write(merged.astype(rasterio.float32))
			print(dst, " written")
