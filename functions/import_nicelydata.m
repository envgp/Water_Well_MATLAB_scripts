function Data = import_nicelydata()
% Imports data from Tim Nicely's big spreadsheet. 

fprintf("Importing Tim Nicely data.\n")

oldfolder = cd;
cd ..

fprintf('\tReading data in %s/Tim_Nicely_data/KSB Water Level Master List_Filtered for Duplicates_sort.xlsx. May take some time...',pwd)
tmp = readtable('Tim_Nicely_data/KSB Water Level Master List_Filtered for Duplicates_sort.xlsx');

cd(oldfolder)

[Wellnames,idxs] = unique(tmp.KSB_ID); % Get the unique entries based on the KSB_ID; in other words, get just a list of wells (not measurements).
tmp_wells = tmp(idxs,:);


Data.WellData.stn_id = tmp_wells.CRNASTN_ID;
Data.WellData.well_depth = zeros(length(tmp_wells.CRNASTN_ID),1);
Data.WellData.latitude = tmp_wells.LATITUDE;
Data.WellData.longitude = tmp_wells.LONGITUDE;
Data.WellData.site_code = tmp_wells.CASGEMSITE_CODE; % This is the CASGEM site code.
Data.WellData.well_use = zeros(length(tmp_wells.CRNASTN_ID),1); % well use isn't specified in Tim Nicely's data. 
A = strings(length(tmp_wells.CRNASTN_ID),1);
A(:) = "Nicely";
Data.WellData.datasource = A;
Data.WellData.is_cclay = tmp_wells.is_corccly;
Data.WellData.aquifer = tmp_wells.AQUIFER;
Data.WellData.nicely_site_code = tmp_wells.KSB_ID; 
