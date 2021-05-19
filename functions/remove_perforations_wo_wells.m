function Data_filt = remove_perforations_wo_wells(Data)
% Takes a data structure and removes any perforations which do not have
% corresponding wells.

    site_codes = Data.WellData.site_code(Data.WellData.site_code ~= ""); % get a list of site codes excluding empty strings
    nicely_codes = Data.WellData.nicely_site_code(Data.WellData.nicely_site_code ~= ""); % get a list of nicely codes excluding empty strings
    
    listperf_withwells = ismember(Data.PerfData.site_code,site_codes) | ismember(Data.PerfData.nicely_site_code,nicely_codes); % Create a list of logicals showing which index in measurements contain a Well .

    Data_filt = Data;
    
    fields = fieldnames(Data.PerfData);
    
    for i = 1:length(fields)
        Data_filt.PerfData.(fields{i}) = Data.PerfData.(fields{i})(listperf_withwells);
    end
    
end