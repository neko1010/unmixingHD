import FCPGtools as fcpg
import rasterio

cores = 1
## Input ESRI flow direction grid
fdr = '../data/esriBigLostFDir.tif'
## Output TauDEM flow direction grid
fdrTau = '../data/BigLostTau.tif'
## Output flow accumulation
facTau =  '../data/BigLostAcc.tif'

### define crs
#crs = rasterio.crs.CRS.from_epsg(4326)
#src = rasterio.open(fdr, crs = crs)
#print("FILE", src.transform)
##src.bounds()

## make sure the dtype is correct
updateDict={'dtype':'uint8','compress': 'LZW', 'zlevel': 9, 'interleave': 'band', 'sparse': True, 'tiled': True, 'blockysize': 256, 'blockxsize': 256, 'driver': 'GTiff', 'nodata': 0, 'bigtiff': 'IF_SAFER'}

## Reclassify flow directions
fcpg.tauDrainDir(inRast = fdr, outRast = fdrTau, updateDict = updateDict)
print("flow direction reclassified as: ", fdrTau)

## Flow accumulation
fcpg.tauFlowAccum(fdrTau, facTau, cores = cores)

print("Tau Flow accumulation raster saved as: ", facTau)
