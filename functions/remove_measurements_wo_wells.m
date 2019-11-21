function Data_filt = remove_measurements_wo_wells(Data)
% Sometimes you will have measurements which correspond to wells which you
% have no information about. This function deletes all measurement data which
% does not have a corresponding well.
    
    site_codes = Data.WellData.site_code(Data.WellData.site_code ~= ""); % get a list of site codes excluding empty strings
    nicely_codes = Data.WellData.nicely_site_code(Data.WellData.nicely_site_code ~= ""); % get a list of nicely codes excluding empty strings
    
    listmeasurement_withwells = ismember(Data.MeasurementData.site_code,site_codes) | ismember(Data.MeasurementData.nicely_site_code,nicely_codes); % Create a list of logicals showing which index in measurements contain a Well .
    
    %listwells = true([length(Data.WellData.site_code),1]); % there are no redundant wells in this script...

    Data_filt = filter_logical_new(Data,'MeasurementData',listmeasurement_withwells);
end
