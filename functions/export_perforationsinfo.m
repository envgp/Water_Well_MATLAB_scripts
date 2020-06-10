function export_perforationsinfo(Data,outname)
%%% export_perforationsinfo(Data,outname). Outname is a stub (ie, no .csv at the
%%% end). Will be placed in current directory.

fid = fopen(strcat(outname,'.info'),'wt');
fprintf(fid, Data.History);
fclose(fid);

wellinfo = struct2table(Data.PerfData);
writetable(wellinfo,strcat(outname,'.csv'));
