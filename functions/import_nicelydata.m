function Data = import_nicelydata()
% Imports data from Tim Nicely's big spreadsheet. 

fprintf("Importing Tim Nicely data.\n")

oldfolder = cd;
cd ..

fprintf('\tReading data in %s/Tim_Nicely_data/KSBWaterLevelMasterList_FilteredforDuplicates_sort.xlsx. May take some time...',pwd)
tmp = readtable(sprintf('%s/Tim_Nicely_data/KSBWaterLevelMasterList_FilteredforDuplicates_sort.xlsx',pwd));

cd(oldfolder)

[Wellnames,idxs] = unique(tmp.KSB_ID); % Get the unique entries based on the KSB_ID; in other words, get just a list of wells (not measurements).
tmp_wells = tmp(idxs,:);


Data.WellData.stn_id = tmp_wells.CRNASTN_ID;
Data.WellData.well_depth = nan(length(tmp_wells.CRNASTN_ID),1);
Data.WellData.latitude = tmp_wells.LATITUDE;
Data.WellData.longitude = tmp_wells.LONGITUDE;
Data.WellData.site_code = tmp_wells.CASGEMSITE_CODE; % This is the CASGEM site code.
Data.WellData.well_use = strings(length(tmp_wells.CRNASTN_ID),1); % well use isn't specified in Tim Nicely's data. 
A = strings(length(tmp_wells.CRNASTN_ID),1);
A(:) = "Nicely";
Data.WellData.datasource = A;
Data.WellData.is_cclay = tmp_wells.is_corccly;
Data.WellData.aquifer = tmp_wells.AQUIFER;
Data.WellData.nicely_site_code = tmp_wells.KSB_ID;


% Load Measurements section

Data.MeasurementData.date = tmp.MSMT_DATE;
Data.MeasurementData.ground_surface_elevation = str2double(tmp.GSE_DEM); % Take the DEM reported GSE; note that sometimes this isn't the same as the 'reported' one. Some NaNs appear doing this as some of the GSE have 'null' as their value.
Data.MeasurementData.reference_point_elevation = zeros(length(tmp.MSMT_DATE),1); % Not needed
Data.MeasurementData.ref_point_reading = zeros(length(tmp.MSMT_DATE),1);
Data.MeasurementData.stn_id = tmp.CRNASTN_ID;
Data.MeasurementData.water_surface_reading = nan(length(tmp.MSMT_DATE),1);
Data.MeasurementData.site_code = tmp.CASGEMSITE_CODE; 
Data.MeasurementData.quality_comment = strings(length(tmp.MSMT_DATE),1);
Data.MeasurementData.water_surface_elevation = tmp.WSE;
A = strings(length(tmp.MSMT_DATE),1);
A(:) = "Nicely";
Data.MeasurementData.datasource = A;
Data.MeasurementData.nicely_site_code = tmp.KSB_ID;

% Load Perforations Section (haven't checked this is right yet - compare duplicate wells with CASGEM to check)

Data.PerfData.stn_id = tmp_wells.CRNASTN_ID;
Data.PerfData.site_code = tmp_wells.CASGEMSITE_CODE;
Data.PerfData.top_perf = tmp_wells.TOP_SCRN;
Data.PerfData.bot_perf = tmp_wells.BOT_SCRN;
Data.PerfData.nicely_site_code = tmp_wells.KSB_ID;
A = strings(length(tmp_wells.CRNASTN_ID),1);
A(:) = "Nicely";
Data.PerfData.datasource = A;

