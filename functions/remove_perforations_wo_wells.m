function Data_filt = remove_perforations_wo_wells(Data)
% Takes a data structure and removes any perforations which do not have
% corresponding wells.

    fprintf('\nRunning remove_perforations_wo_wells\n')
    
    listperf_withwells = ismember(Data.PerfData.stn_id(:),Data.WellData.stn_id(:));
    
    Data_filt = Data;
    
    fields = fieldnames(Data.PerfData);
    
    for i = 1:length(fields)
        Data_filt.PerfData.(fields{i}) = Data.PerfData.(fields{i})(listperf_withwells);
    end
    
end