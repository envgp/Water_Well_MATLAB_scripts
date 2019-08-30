%%% This script takes a polygon defined as a kml file, and creates
%%% hydrographs for all the DWR wells in that polygon and exports a kml
%%% file called 'finalkml.kml' containing all of them. To share, open it in
%%% Google Earth and save as a kmz, which you can then share with others.
%%%
%%% ML 30/08/19: note a few NaN wells still slip through, which is when wells have
%%% measurements entered but the values of these measurements are 'NaN'.
%%% Not too many wells like this exist, thankfully.

% Bookkeeping: add 'functions' to the path and close all open figures.
addpath('../../functions');
close all

startyear = 2010;
endyear=2020;

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

% CCtmp = GIS_kml2struct('../polygons/corcoran_clay_extent.kml'); % Import the Corcoran Clay from the kml
% CC = [CCtmp.Lon CCtmp.Lat]; % spatial_filter_polygon wants a variable in form [LON LAT]
% CC_intersection = spatial_filter_polygon(Data_All,CC); % Do the actual filtering

addpath('../polygons');

% Extract and save as csv the wells inside the kml polygon

Data_filt = GIS_wells_from_polygon_kml(Data_All,'recharge_area.kml');
% export_wells_csv_advanced(Data_filt,'area1.csv')


Data_filt = temporal_filter_yearrange(Data_filt,startyear,endyear);
Data_filt = remove_wells_wo_measurements(Data_filt);

fprintf('\tFinished with %i wells and %i measurements.\n',length(Data_filt.WellData.stn_id(:)),length(Data_filt.MeasurementData.stn_id(:)))

description = cell(1,length(Data_filt.WellData.stn_id(:)));
name = cell(1,length(Data_filt.WellData.stn_id(:)));


%%

mkdir hydrograph_images

% Loop which makes a png file containing the hydrograph, then makes the variable 'description' which will tell the kml where to find the image.
for i = 1:length(Data_filt.WellData.stn_id(:))
    if i ==1
        fprintf('%i out of %i wells completed.\n', i, length(Data_filt.WellData.stn_id(:)))
    elseif rem(i,50)==0
        fprintf('%i out of %i wells completed.\n', i, length(Data_filt.WellData.stn_id(:)))
    end
    f = figure('visible','off');
    plot_hydrograph(Data_filt,Data_filt.WellData.site_code{i});
    xlim([datenum(sprintf('01/01/%i', startyear)) datenum(sprintf('08/29/%i', endyear))])
    datetick('x','mm/yyyy','keeplimits')
    saveas(f,sprintf('hydrograph_images/hydrograph%i.png',i));
    % This is the key bit
    description{i} = sprintf('<img style="max-width:500px;" src="hydrograph_images/hydrograph%i.png">]]<br>Site code = %s',i,Data_filt.WellData.site_code{i});
    name{i} = sprintf('%.0f',Data_filt.WellData.stn_id(i));
    close all
end

% This saves the final kml.
kmlwrite('finalkml.kml',Data_filt.WellData.latitude, Data_filt.WellData.longitude, 'Description',description, 'Name', name)