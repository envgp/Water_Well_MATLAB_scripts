function Data_filt = filter_by_wellnames_fromfile(Data,filename)
% Takes a filename of a text file (in double parenthesis "FILENAME", please), containing either nicely, or stn_ids each line. Well names refer to the 5 digit casgem code, or the full Nicely 'KSB-XXXX' code. 

fprintf('\nRunning filtr_by_wellnames_fromfile\n')
fprintf('\tStarting with %s containing %i wells and %i measurements.\n',inputname(1),length(Data.WellData.site_code(:)),length(Data.MeasurementData.site_code(:)))


fprintf('\tFiltering with the following wellnames file: "%s".\n',filename)


fileID = fopen(filename);
C = textscan(fileID,'%s','headerlines',1);
fclose(fileID);

wellnames=C{1};

wellnames_nicely = wellnames(startsWith(wellnames,'K'));
%wellnames_stnid = wellnames(~isnan(str2double(wellnames))); If i need,
%this is a slightly better way than the one below.
cellength = cellfun('length',wellnames);
wellnames_sitecodes = wellnames(cellength>10);
wellnames_other = str2double(wellnames(~startsWith(wellnames,'K')));

logical_wells = ismember(Data.WellData.stn_id,wellnames_other) | ismember(Data.WellData.nicely_site_code,wellnames_nicely) | ismember(Data.WellData.site_code,wellnames_sitecodes);

Data_filt = filter_logical_new(Data,'WellData',logical_wells);
Data_filt.History = Data_filt.History + newline + "Fitered to only contain wellnames from file " + filename +".";

fprintf('\tFinished with %i wells and %i measurements.\n',length(Data_filt.WellData.site_code(:)),length(Data_filt.MeasurementData.site_code(:)))
end