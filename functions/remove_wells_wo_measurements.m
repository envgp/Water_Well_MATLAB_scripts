function Data_filt = remove_wells_wo_measurements(Data)
% Removes wells which don't have any associated measurements.
    
    %fprintf('Running remove_wells_wo_measurements.\n')
    
    site_codes = Data.MeasurementData.site_code(Data.MeasurementData.site_code ~= ""); % get a list of site codes excluding empty strings
    nicely_codes = Data.MeasurementData.nicely_site_code(Data.MeasurementData.nicely_site_code ~= ""); % get a list of nicely codes excluding empty strings

    
    listwells_withmeas = ismember(Data.WellData.site_code,site_codes) | ismember(Data.WellData.nicely_site_code(:),nicely_codes);
    
    Data_filt = Data;
    
    fields = fieldnames(Data.WellData);
    
    for i = 1:length(fields)
        Data_filt.WellData.(fields{i}) = Data.WellData.(fields{i})(listwells_withmeas);
    end
    
end

