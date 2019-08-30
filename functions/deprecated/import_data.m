function Data = import_opendata()
% Imports data downloaded from CaNRA OpenData
% (https://data.cnra.ca.gov/dataset/periodic-groundwater-level-measurements)
% files. The files 'stations.csv' and 'measurements.csv' should be
% downloaded in folder '../opendata_files'.

    oldfolder = cd;
    cd ..
    fprintf('Importing CaNRA OpenData using "import_opendata()". Data is at %s/data/. \n',pwd)
    cd(oldfolder)
%     Data.WellData = struct('site_code',[],'well_depth',[],'latitude',[],'longitude',[]); % initiate well data substructure
%     Data.MeasurementData = struct('date',[],'ground_surface_elevation',[],'reference_point_elevation',[],'ref_point_reading',[],'site_code',[]); % initiate measurement data substructure
    addpath('../opendata_files'); % add data files to path
    
    % populate well data
    fprintf('\treading stations.csv \n')
    tmp = readtable('stations.csv');

    Data.WellData.stn_id = tmp.STN_ID;
    Data.WellData.well_depth = tmp.WELL_DEPTH;
    Data.WellData.latitude = tmp.LATITUDE;
    Data.WellData.longitude = tmp.LONGITUDE;
    Data.WellData.site_code = tmp.SITE_CODE;
    Data.WellData.well_use = tmp.WELL_USE;
    
    % populate measurement data
    fprintf('\treading measurements.csv; may take some time\n')
    tmp = readtable('measurements.csv');
    
    Data.MeasurementData.date = tmp.MSMT_DATE;
    Data.MeasurementData.ground_surface_elevation = tmp.WLM_GSE;
    Data.MeasurementData.reference_point_elevation = tmp.WLM_RPE;
    Data.MeasurementData.ref_point_reading = tmp.RDNG_RP;
    Data.MeasurementData.stn_id = tmp.STN_ID;
    Data.MeasurementData.water_surface_reading = tmp.RDNG_WS;
    Data.MeasurementData.site_code = tmp.SITE_CODE;
    
    % populate perforation data
    
    fprintf('\treading perforations.csv\n')
    tmp = readtable('perforations.csv');
    Data.PerfData.stn_id = tmp.STN_ID;
    Data.PerfData.site_code = tmp.SITE_CODE;
    Data.PerfData.top_perf = tmp.TOP_PRF;
    Data.PerfData.bot_perf = tmp.BOT_PRF;
    
end