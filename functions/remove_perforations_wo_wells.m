function Data_filt = remove_perforations_wo_wells(Data)
% Takes a data structure and removes any perforations which do not have
% corresponding wells.

    fprintf('\nRunning remove_perforations_wo_wells\n')
    
    CASGEMS = ismember(Data.PerfData.datasource,'CASGEM');
    NICELYS = ismember(Data.PerfData.datasource,'Nicely');
    fprintf('\tFound %i measurements from CASGEM and %i from Tim Nicely. Removing perforations wo wells for both.',sum(CASGEMS),sum(NICELYS))
    
    listperf_withwells_CASGEM = ismember(Data.PerfData.stn_id(CASGEMS),Data.WellData.stn_id(:));
    listperf_withwells_NICELY = ismember(Data.PerfData.nicely_site_code(NICELYS),Data.WellData.nicely_site_code(:));

    listperf_withwells=[listperf_withwells_CASGEM; listperf_withwells_NICELY];

    
    Data_filt = Data;
    
    fields = fieldnames(Data.PerfData);
    
    for i = 1:length(fields)
        Data_filt.PerfData.(fields{i}) = Data.PerfData.(fields{i})(listperf_withwells);
    end
    
end