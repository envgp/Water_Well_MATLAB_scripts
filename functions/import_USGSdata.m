function WellData = import_USGSdata(filename)
% Data = import_USGSdata(filename) 
%
% Imports USGS well data from ../data. Data should be downloaded from
% https://nwis.waterdata.usgs.gov/nwis/gwlevels?search_criteria=state_cd&submitted_form=introduction
% with 'site-description information displayed in tab-separated format'.
% Some orange errors are probably created during import, but ignore them as
% the script still works just fine.

    fprintf("\n Importing data using import_USGSdata('%s')\n", filename) 
    tmp = readtable(filename);
    WellData.WellData.latitude=str2num(cell2mat(tmp.dec_lat_va(2:end)));
    WellData.WellData.longitude=str2num(cell2mat(tmp.dec_long_va(2:end)));

end