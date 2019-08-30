function Data = import_opendata()
% Imports data downloaded from CaNRA OpenData
% (https://data.cnra.ca.gov/dataset/periodic-groundwater-level-measurements)
% files. The files 'stations.csv', 'measurements.csv' and 'performations.csv' should be
% downloaded in folder '../opendata_files'. THIS SCRIPT IS IN TRANSITION
% AND NOW AUTOMATICALLY DOWNLOADS THE LATEST FROM THE INTERNET! It doesn't
% quite work yet as it doesn't delete the old 'zip' file before downloading
% a new one, so we simply unzip the same data each time....

    oldfolder = cd;
    cd ..
    fprintf('Importing CaNRA OpenData using "import_opendata()". Data is at %s/opendata_files/ .\n',pwd)
%     Data.WellData = struct('site_code',[],'well_depth',[],'latitude',[],'longitude',[]); % initiate well data substructure
%     Data.MeasurementData = struct('date',[],'ground_surface_elevation',[],'reference_point_elevation',[],'ref_point_reading',[],'site_code',[]); % initiate measurement data substructure
    cd opendata_files
%    !mv measurements.csv old
%    !mv perforations.csv old
%    !mv stations.csv old
    
    fprintf('Downloading latest version of opendata.. \n\tIf this fails the last previously downloaded verison will be used. \n\tReasons for failure might be wget not installed or not on the MATLAB path. \n\tIn event of failure, download yourself from https://data.cnra.ca.gov/dataset/periodic-groundwater-level-measurements and unzip the files to the directory "opendata_files".\n')
    
%    path1='/Users/mlees/anaconda3/envs/qGIS_environment/bin:/Users/mlees/anaconda3/condabin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin'
    path2='/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin';
%    setenv('PATH',path1)    
    setenv('PATH',path2)    

    cmd = 'wget -N https://data.cnra.ca.gov/dataset/dd9b15f5-6d08-4d8c-bace-37dc761a9c08/resource/c51e0af9-5980-4aa3-8965-e9ea494ad468/download/periodic_gwl_bulkdatadownload.zip';
    fprintf('Executing command: \n\t %s \n', cmd)
    system(cmd,'-echo');
    
    cmd = 'unzip -fo periodic_gwl_bulkdatadownload.zip';
    fprintf('Executing command: \n\t %s \n', cmd)
    system(cmd,'-echo');
    
    
    
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
    
    cd(oldfolder)

end