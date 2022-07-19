import arcpy
import os
from arcpy.sa import *

def export_feats(features, out_loc):
        ## use the cursor to iterate over huc8 units a
    with arcpy.da.SearchCursor(features, ['SHAPE@', 'huc4']) as cursor:
        for row in cursor:
            ## extracting the name field and removing spaces
            name = row[1].replace(" ", "").replace("-", "")

            ## export each feature
            out_name = os.path.join(out_loc, name + ".shp")
            arcpy.CopyFeatures_management(row[0], out_name )
            print(name, " exported to ", out_loc)

# Extract by mask slope
def shed_slopes(sheds_loc, out_loc, slope):
    ''' Loop through sheds output by export_feats and extract slope'''
    ## Checkout spatial analyst extension
    arcpy.CheckOutExtension("Spatial")

    ## List of huc 8 shapefiles
    sheds = os.listdir(sheds_loc)

    ##loop through the list and extract flow direction
    for shed in sheds:
        if shed.endswith(".shp"):
            outras = ExtractByMask(slope, os.path.join(sheds_loc, shed))
            ## save to disk
            out_name = os.path.join(out_loc, shed.split(".")[0] + "_slope.tif")
            outras.save(os.path.join(out_loc, out_name))
            print(out_name, " saved to ", out_loc)
        else:
            pass

## Extract by mask DEM
def shed_dem(sheds_loc, out_loc, dem_loc):
    ''' Loop through sheds output by export_feats and extract dem'''
    ## Checkout spatial analyst extension
    arcpy.CheckOutExtension("Spatial")

    ## List of huc 8 shapefiles
    sheds = os.listdir(sheds_loc)

    ##loop through the list and extract flow direction
    for shed in sheds:
        if shed.endswith(".shp"):
            dem = os.path.join(dem_loc, 'huc' + shed.split('.')[0] + 'dem.tif')
            outras = ExtractByMask(dem, os.path.join(sheds_loc, shed))
            ## save to disk
            out_name = os.path.join(out_loc, shed.split(".")[0] + "_dem.tif")
            outras.save(os.path.join(out_loc, out_name))
            print(out_name, " saved to ", out_loc)

        else:
            pass

## Fill sinks for each DEM
def fill_sinks(dems_loc, out_loc):
    ''' fill sinks in each watershed dem for consequent hydrologicial analysis'''
    ## Checkout spatial analyst extension
    arcpy.CheckOutExtension("Spatial")

    ## list of shed dems
    dems = os.listdir(dems_loc)
    tifs = [dem for dem in dems if dem.split('.')[-1] == "tif"]

    for tif in tifs:

        out_name = os.path.join(out_loc, tif.split("_")[0] + "_filled.tif")
##        # Process: Fill
##        tempEnvironment0 = arcpy.gp.scratchWorkspace
##        arcpy.env.scratchWorkspace = "E:/HD_DEM/scratch/scratch.gdb"
##        tempEnvironment1 = arcpy.gp.workspace
##        arcpy.env.workspace = "E:/HD_DEM/scratch/scratch1.gdb"
##        arcpy.gp.Fill_sa(os.path.join(dems_loc, tif), out_name, "" )
##        arcpy.env.scratchWorkspace = tempEnvironment0
##        arcpy.env.workspace = tempEnvironment1
        ## clip to huc4 boundary

        #masked = arcpy.sa.Mask(os.path.join(dems_loc, tif), no_data_values = 0)
        arcpy.gp.Fill_sa(os.path.join(dems_loc, tif), out_name, "" )
        print(out_name, " saved to ", out_loc)


## Extract by mask Flowdir
def flow_dirs(fill_loc, out_loc):
    ''' Loop through filled dems and calculate flow direction '''
    ## Checkout spatial analyst extension
    arcpy.CheckOutExtension("Spatial")

    ## List of huc 8 shapefiles
    dems = os.listdir(fill_loc)
    tifs = [dem for dem in dems if dem.split('.')[-1] == "tif"]

    ##loop through the list and calculate flow direction
    for tif in tifs:

        ## save to disk
        out_name = os.path.join(out_loc, tif.split("_")[0] + "_flowdir.tif")
        arcpy.gp.FlowDirection_sa(os.path.join(fill_loc, tif), out_name, "NORMAL")

        print(out_name, " saved to ", out_loc)



## Calculate flow acc
def flow_accs(flowdirs_loc, out_loc):
    ''' Loop through the flow direction rasters and apply the flow accumulation tool'''
    ## Checkout spatial analyst extension
    arcpy.CheckOutExtension("Spatial")

    flowdirs = os.listdir(flowdirs_loc)
    tifs = [flowdir for flowdir in flowdirs if flowdir.split('.')[-1] == "tif"]
    print(tifs)

    for tif in tifs:

        ## save to disk
        out_name = os.path.join( out_loc, tif.split("_")[0] + "_flowacc.tif")

        if tif.split("_")[0] + "_flowacc.tif" in os.listdir(out_loc):
            print(tif.split("_")[0] + "_flowacc.tif", " aready calculated")
            pass
        else:

            arcpy.gp.FlowAccumulation_sa(os.path.join(flowdirs_loc, tif), out_name, "", "FLOAT")
            print(out_name, " saved to ", out_loc)

        #arcpy.gp.FlowAccumulation_sa("E:/HD_DEM/huc8/flow_dir/AmericanFalls_flowdir.tif", "E:/HD_DEM/tst/americanfalls_acctst.tif", "", "FLOAT")

## Calculate TWI

def twi(flow_acc_loc, slope_loc, out_loc):
    ''' Topographic Wetness Index'''
    ## Checkout spatial analyst extension
    arcpy.CheckOutExtension("Spatial")

    flow_accs = os.listdir(flow_acc_loc)
    fa_tifs = [flow_acc for flow_acc in flow_accs if flow_acc.split('.')[-1] == "tif"]

    slopes = os.listdir(slope_loc)
    slp_tifs = [slp for slp in slopes if slp.split('.')[-1] == "tif"]

    for fa_tif in fa_tifs:
        for slp_tif in slp_tifs:
            if fa_tif.split("_")[0] == slp_tif.split("_")[0]:
                out_ras = ln(floww_acc/slope)
                out_name = os.path.join(out_loc, slp_tif.split("_")[0] + "_twi.tif")
                out_ras.save(out_name)
                print(out_name, " saved to ", out_loc)
            else:
                pass




def main():

    cpath = "C:/Users/nicholaskolarik/DDeSuP/data/Ch2/"
    #epath = "E:/HD"
    huc4_out = os.path.join(cpath, "huc4")

    ## Individual HUC4 units

    feats = os.path.join(huc4_out, 'huc4.shp')
    #export_feats(feats, os.path.join(huc4_out, 'shp'))

    ## Clip the DEMs

    sheds_loc = os.path.join(huc4_out, 'shp')
    out_loc = os.path.join(huc4_out, 'clipped')
    dem_loc = os.path.join(huc4_out, 'huc4dem')
    shed_dem(sheds_loc, out_loc, dem_loc)

    ## Fill Sinks

    fill_out = os.path.join(huc4_out, "filled")

    fill_sinks(os.path.join(huc4_out, "clipped"), fill_out)

    ## Flow_dirs
    flow_dir_out = os.path.join(huc4_out, "flow_dir")

    flow_dirs(fill_out, flow_dir_out)

    ##Flow accumulations
    flow_acc_out = os.path.join(huc4_out, "flow_acc")

    flow_accs(flow_dir_out, flow_acc_out)


if __name__ == '__main__':
    main()
