## Format the input parameter files to <source_var_dd_mm__yyyy.tif>

import os

path = "../data/"

param = path + "PRISM/pptTIF/"

files = os.listdir(param)

for f in files:
    name = os.path.splitext(f)[0]
    #print(name)

    parsed = name.split("_")
    ## Source
    base = parsed[0]
    ## Variable
    var = parsed[1]
    ## Year
    year = parsed[4][0:4]
    ## Month
    if len(parsed[4]) == 6:
        month = parsed[4][4:6]

    else:
        ## Annual marked as "00"
        month = "00"

    final = base + "_" + var + "_00_" + month + "_" + year + ".tif"
    print(final)
    os.rename(param + f, param + final)
