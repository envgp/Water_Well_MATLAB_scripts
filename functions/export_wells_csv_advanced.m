function export_wells_csv_advanced(Data,filename)
% export_wells_csv_advanced(Data,filename)
% 
% Takes a Data structure and saves it as a csv with name 'filename'. The csv contains
% fields: lat, lon in decimal degrees, stn_id, site_code, well_depth and
% well_use. filename is saved relative to the working directory. Append
% '.csv' yourself if you want this. 

 
   T = table(Data.WellData.latitude(:),Data.WellData.longitude(:),Data.WellData.stn_id(:),Data.WellData.site_code(:),Data.WellData.well_depth(:),Data.WellData.well_use(:),'VariableNames',{'Latitude';'Longitude';'Station_Id';'Site_code';'Well_depth';'Well_Use'});
   fprintf("Exporting to %s. \n",filename);
   writetable(T,filename);
   fprintf("Export successful (unless you saw an error message)\n");

   %    csvwrite(filename,[Data.WellData.latitude(:) Data.WellData.longitude(:) Data.WellData.stn_id(:) Data.WellData.site_code(:)]);