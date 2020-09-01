function Data_filt = filter_by_wellnames_fromfile(Data,filename)
% Takes a filename of a text file (in double parenthesis "FILENAME", please), containing either nicely or CASGEM wellnames on each line. Well names refer to the 5 digit casgem code, or the full Nicely 'KSB-XXXX' code. 

fileID = fopen(filename);
C = textscan(fileID,'%s','headerlines',1);
fclose(fileID);

wellnames=C{1};

wellnames_nicely = wellnames(startsWith(wellnames,'K'));
wellnames_other = str2double(wellnames(~startsWith(wellnames,'K')));

logical_wells = ismember(Data.WellData.stn_id,wellnames_other) | ismember(Data.WellData.nicely_site_code,wellnames_nicely);

Data_filt = filter_logical_new(Data,'WellData',logical_wells);
Data_filt.History = Data_filt.History + newline + "Fitered to only contain wellnames from file " + filename +".";
end