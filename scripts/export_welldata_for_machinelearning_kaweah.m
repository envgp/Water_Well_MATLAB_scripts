% This:
% 1. Imports and merges casgem+nicely data for KaweahGroundwaterModel
% 2. Filters to only include wells with the site id or nicely codes as read
% in from a file.
% 3. Creates a new folder, and in that folder creates a "data.info"
% file. Then, it writes files for each individual well containing well
% time series information in the rows.

%% Firstly, let's do part 1.

addpath('../functions');

if exist('data_casgem') == 0
    data_casgem = import_opendata();
end

if exist('data_nicely') == 0
    data_nicely = import_nicelydata();
end

data_all = merge_datastructures(data_casgem,data_nicely);
data_all_nodup = merge_duplicates_casgem_nicely(data_all);

data_kaweah = GIS_wells_from_polygon_kml(data_all_nodup,'../Polygons/KaweahGroundwaterModel.kml');

%% Now, we'll do part 2.

fileID = fopen('../exports/Kaweah_Post2010_Hydrographs/Hydrographs_GOOD/wellnames.txt');
C = textscan(fileID,'%s','headerlines',1);
fclose(fileID);

wellnames=C{1};
wellnames=wellnames(1:end-1); % for whatever reason the last entry in the file wellnames.txt is 'wellnames' lol

wellnames_nicely = wellnames(startsWith(wellnames,'K'));
wellnames_other = str2double(wellnames(~startsWith(wellnames,'K')));

logical_wells = ismember(data_kaweah.WellData.stn_id,wellnames_other) | ismember(data_kaweah.WellData.nicely_site_code,wellnames_nicely);

Data_GoodWells = filter_logical_new(data_kaweah,'WellData',logical_wells);
Data_GoodWells.History = Data_GoodWells.History + newline + "Fitered to only contain wellnames from file wellnames.txt";

[depth,Data_GoodWells] = calc_water_levels(Data_GoodWells,0,'NewDataInstance');

%% Finally do part 3 (the hard part).

%This will involve: first, make a new folder with the name given in a
%variable.
% Then, write Data_GoodWells.info to it. That will be a text file
% containing the history thing.
% Then, for each line of WellData, get the corresponding measurements. Use
% struct2table on the measurements and then save the table as
% wellname_measurements.csv. Job done!!

foldername="Kaweah_GroundwaterModel_GoodWellsForMachineLearning";

cd ../exports/
mkdir(foldername)
cd(foldername)

fid = fopen('Data_GoodWells.info','wt');
fprintf(fid, Data_GoodWells.History);
fclose(fid);

wellinfo = struct2table(Data_GoodWells.WellData);
writetable(wellinfo,'WELLINFO.csv');

for i = 1:length(wellnames_nicely)
    well = wellnames_nicely{i};
    logical = Data_GoodWells.WellData.nicely_site_code == well;
    Dat_tmp = filter_logical_new(Data_GoodWells,'WellData',logical);
    Table_tmp = struct2table(Dat_tmp.MeasurementData);
    outname=string(well)+".csv";
    writetable(Table_tmp,outname);
end
    
    
for i = 1:length(wellnames_other)
    well = wellnames_other(i);
    logical = Data_GoodWells.WellData.stn_id == well;
    Dat_tmp = filter_logical_new(Data_GoodWells,'WellData',logical);
    Table_tmp = struct2table(Dat_tmp.MeasurementData);
    outname=string(well)+".csv";
    writetable(Table_tmp,outname);
end

cd ../../scripts