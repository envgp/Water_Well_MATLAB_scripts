function export_wellinfo(Data,outname)
%%% export_wellinfo(Data,outname). Exports stn_id, well_depth, lat, lon,
%%% site_code, well_use, datasource, is_cclay, aquifer, etc for each well.
%%% (It exports all attributes). It also exports measurement info for each
%%% well in individual csvs.
%%%
%%% Outname should be a stub (ie, no .csv at the end). All files be placed in current directory.

cmd_called = getLastMATLABcommandLineStr();
Data.History = Data.History + newline + cmd_called;

fid = fopen(strcat(outname,'.info'),'wt');
fprintf(fid, Data.History);
fclose(fid);

wellinfo = struct2table(Data.WellData);
writetable(wellinfo,strcat(outname,'.csv'));

wellnames = rmmissing(vertcat(Data.WellData.stn_id,Data.WellData.nicely_site_code));
wellnames = wellnames(~strcmp(wellnames(:),""),:);


wellnames_nicely = wellnames(startsWith(wellnames,'K'));
wellnames_other = str2double(wellnames(~startsWith(wellnames,'K')));


for i = 1:length(wellnames_nicely)
    well = wellnames_nicely{i};
    logical = Data.WellData.nicely_site_code == well;
    Dat_tmp = filter_logical_new(Data,'WellData',logical);
    Table_tmp = struct2table(Dat_tmp.MeasurementData);
    outname=string(well)+".csv";
    writetable(Table_tmp,outname);
end
    
    
for i = 1:length(wellnames_other)
    well = wellnames_other(i);
    logical = Data.WellData.stn_id == well;
    Dat_tmp = filter_logical_new(Data,'WellData',logical);
    Table_tmp = struct2table(Dat_tmp.MeasurementData);
    outname=string(well)+".csv";
    writetable(Table_tmp,outname);
end
end