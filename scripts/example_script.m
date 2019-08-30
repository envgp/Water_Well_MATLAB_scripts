%%% This script is designed as an example script to illustrate how this
%%% MATLAB library works, and show some of its functionality. It gets all
%%% wells perforated not shallower than 400 ft and intersecting with the
%%% Corcoran Clay, and plots them coloured by depth. It also exports a .csv
%%% of these wells.


%% Part one: filtering wells

% Bookkeeping: add 'functions' to the path and close all open figures.
addpath('../functions');
close all

% Checks whether a variable called 'Data_All' exists already; if not, we
% import the bulk data. Note this script tries to download the data from
% the internet, but if that doesn't work, you can download yourself and put it in ../opendata_files.
% See 'help import_opendata'.
if exist('Data_All') == 0
    disp('Data_All not found; importing Data')
    Data_All = import_opendata();
else
    disp('Previously imported Data found; type "clear all" if not desired')
end

% Filter 'Data_All' to just the intersection with the Corcoran Clay.
CCtmp = GIS_kml2struct('../polygons/corcoran_clay_extent.kml'); % Import the Corcoran Clay from the kml
CC = [CCtmp.Lon CCtmp.Lat]; % spatial_filter_polygon wants a variable in form [LON LAT]
CC_intersection = spatial_filter_polygon(Data_All,CC); % Do the actual filtering


% Filter 'CC_intersection' to exclude wells with perforations shallower
% than 400ft.

CC_shallow = filter_perforations_max(CC_intersection,400);

% Sanity check: Plot what you've done to have a look.
figure()
plot_wells(CC_intersection);
hold on
plot_wells(CC_shallow);
legend('CC intersection','CC shallow')
%% Part two: plotting the wells coloured by their depth.

figure() % open a figure
scatter(CC_shallow.WellData.longitude, CC_shallow.WellData.latitude, 100, CC_shallow.WellData.well_depth, 'filled') % scatter, coloured by depth
c=colorbar('EastOutside');  % Note you can change position of the colourbar
c.TickLabels = linspace(0,max(CC_shallow.WellData.well_depth)); % Make the tick labels correct, from 0 -> maximum depth
c.Label.String = 'Depth / ft'; % give the colorbar a title
colormap('winter') % choose a nicer colormap than the default

%% Part three: save as .csv

export_wells_csv_advanced(CC_shallow,'CC_shallow_wells.csv') % single line to export basic info as a csv.
