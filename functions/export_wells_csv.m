function export_wells_csv(Data,filename)
% Takes a Data structure and saves it as 'filename.csv'. The csv contains
% fields: lat, lon in decimal degrees and stn_id. filename.csv is saved in
% '../exports' automatically, creating that folder if it doesn't yet exist.
% To save in current directory, set the first optional argument as zero (I
% HAVEN'T YET CODED THIS FUNCTIONALITY!!!).



   if exist('../exports') ~= 7
       mkdir('..','exports');
       addpath('../exports'); % add data files to path
   end
   
   oldfolder = cd;
   cd ../exports
   T = table(Data.WellData.latitude(:),Data.WellData.longitude(:),Data.WellData.stn_id(:),Data.WellData.site_code(:),'VariableNames',{'Latitude';'Longitude';'Station_Id';'Site_code'});
   writetable(T,filename);
   %    csvwrite(filename,[Data.WellData.latitude(:) Data.WellData.longitude(:) Data.WellData.stn_id(:) Data.WellData.site_code(:)]);
   cd(oldfolder);