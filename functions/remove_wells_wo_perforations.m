function Data_filt = remove_wells_wo_perforations(Data)
% Takes a data structure and removes any wells which do not have
% corresponding perforations.

    fprintf('Running remove_wells_wo_perforations.\n')
    
    listwells_withperf = ismember(Data.WellData.stn_id(:),Data.PerfData.stn_id(:));
    
    Data_filt = Data;
    
    fields = fieldnames(Data.WellData);
    
    for i = 1:length(fields)
        Data_filt.WellData.(fields{i}) = Data.WellData.(fields{i})(listwells_withperf);
    end
    
end