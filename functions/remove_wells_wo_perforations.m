function Data_filt = remove_wells_wo_perforations(Data)
% Takes a data structure and removes any wells which do not have
% corresponding perforations.

    fprintf('Running remove_wells_wo_perforations.\n')
    
    CASGEMSperf = ismember(Data.PerfData.datasource,'CASGEM');
    CASGEMSwell = ismember(Data.WellData.datasource,'CASGEM');
    NICELYS = ismember(Data.PerfData.datasource,'Nicely');
    fprintf('\tFound %i wells from CASGEM and %i from Tim Nicely. Removing wells wo perforations for both.',sum(CASGEMSwell),sum(NICELYS))
    
    
    wells_withperf_CASGEM = intersect(Data.WellData.stn_id(CASGEMSwell),Data.PerfData.stn_id(CASGEMSperf));
    listwells_withperf_CASGEM = ismember(Data.WellData.stn_id,wells_withperf_CASGEM);
    
    NICELY_perfs = ~isnan(Data.PerfData.top_perf(NICELYS)) & ~isnan(Data.PerfData.top_perf(NICELYS));
    NICELY_wellnames = string(Data.PerfData.nicely_site_code(NICELY_perfs));

    listwells_withperf = ismember(Data.WellData.stn_id,wells_withperf_CASGEM) | ismember(Data.WellData.nicely_site_code,NICELY_wellnames);
    
    
    Data_filt = Data;
    
    fields = fieldnames(Data.WellData);
    
    for i = 1:length(fields)
        Data_filt.WellData.(fields{i}) = Data.WellData.(fields{i})(listwells_withperf);
    end
    
end