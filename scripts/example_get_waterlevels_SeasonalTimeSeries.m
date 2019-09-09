% This came out of an old script called "Well_Data_AlexLi". Currently, it takes the well
% data in Matt's study area polygon (the 3 GW basins) and outputs a seasonal
% timeseries csv file, containing well time series for wells with data in
% 80% or more of the "seasons" (seasons being Spring/Fall for each year
% from 2012 to present).

% Bookkeeping: add 'functions' and 'polygons' to the path, make 'exports' and close all open figures.
addpath('../functions');
addpath('../polygons');
mkdir('exports');
close all

% Checks whether a variable called 'Data_All' exists already; if not, we
% import the bulk data. Note this script does not download the data from
% the internet, but assumes you have downloaded it in ../opendata_files.
% See 'help import_opendata'.
if exist('Data_All') == 0
    disp('Data_All not found; importing Data')
    Data_All = import_opendata();
else
    disp('Previously imported Data found; type "clear all" if not desired')
end

load cv_outline
polygon = [cvX' cvY'];

Data_CV = spatial_filter_polygon(Data_All,polygon);
Data_StudyArea = GIS_wells_from_polygon_kml(Data_All,'../polygons/studyarea_threeGWbasins.kml');

%% Export seasonal time series. --- this applies an 80% data threshold, if there's not data in 80% of times, we don't keep it.

[seasonaltimeseries,seasons] = calc_seasonal_timeseries(Data_StudyArea,2012,2019); % Calculate the time series.
seasonaltimeseries(:,3:3:end) = []; % The third column is 'difference'. We don't want that, so remove it.
seasons(:,3:3:end) = []; % ditto

% Now apply the 80% data threshold; delete wells where we have missing data
% more than 20% of the time.

for i = 1:length(seasonaltimeseries)
    NoMsmts(i) = sum(seasonaltimeseries(i,:)~=0 & ~isnan(seasonaltimeseries(i,:))); % Calculate the number of measurements for each well.
end

% Get the max no of measurements (this is the 100% value).
shp = size(seasonaltimeseries);
maxMsmts = shp(2) -1 ; % Minus 1 because Fall 2019 doesn't exist yet!

pc = 80; % This is the percent I want as a minimum
threshold = pc/100 * maxMsmts; % This is that as a number of measurements.
keep1d = NoMsmts>=threshold; % Logical array of the wells to keep

% Filter the seasonal time series by the logical array
keep = repmat(keep1d',1,shp(2));
ThresholdTimeSeries = seasonaltimeseries(:,any(keep,1));
ThresholdTimeSeries = seasonaltimeseries(any(keep,2),:);
ThresholdTimeSeries(ThresholdTimeSeries == 0) = NaN;

% Now save the output
filename=strcat('../exports/seasonal_timeseries_80pcthreshold.csv');
filename2=strcat('../exports/seasonal_timeseries_80pcthreshold_PERFDATA.csv');

variablenames=cellstr(['Latitude','Longitude','Station_Id','Site_code','Well_depth','Well_Use']);

Data_StudyArea_threshold = filter_logical_new(Data_StudyArea,'WellData',keep1d'); % Remove the Well information about ones without the 80% threshold

% Create tables
T1 = struct2table(Data_StudyArea_threshold.WellData);
T2 = array2table(ThresholdTimeSeries,'VariableNames',seasons);
T = [T1,T2];
fprintf("Exporting to %s. \n",filename);
writetable(T,filename);

Perftable = struct2table(Data_StudyArea_threshold.PerfData);
writetable(Perftable,filename2);

fprintf("Export successful (unless you saw an error message)\n");