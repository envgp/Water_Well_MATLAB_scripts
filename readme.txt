Version 2 of this library of functions. To see how it works, have a look in the scripts folder at one of the scripts starting 'example'. 

Typically, scripts should be written and ran in the 'scripts' folder. The latest EWM/CASGEM database data should be maintained in 'opendata_files'; the function import_data automatically updates this if run from within the scripts folder. A selection of useful (and less useful) CV related polygons are contained in 'polygons'. 'functions' contains the functions which do the bulk of the filtering, plotting, etc. Some deprecated functions are also in the 'deprecated' subfolder. 'old_temp' is typically for things I don't need any more but am too scared to delete. Good luck!

New functions include:

calc_seasonal_timeseries
calc_water_levels_woduplicates now works correctly
temporal_filter_yearrange

And new scripts include:

example_create_hydrographs_polygon (which is particularly good!)
