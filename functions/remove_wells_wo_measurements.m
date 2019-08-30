function Data_filt = remove_wells_wo_measurements(Data)
% Removes wells which don't have any associated measurements.
    
    %fprintf('Running remove_wells_wo_measurements.\n')
    
    listwells_withmeas = ismember(Data.WellData.stn_id(:),Data.MeasurementData.stn_id(:));
    
    Data_filt = Data;
    
    fields = fieldnames(Data.WellData);
    
    for i = 1:length(fields)
        Data_filt.WellData.(fields{i}) = Data.WellData.(fields{i})(listwells_withmeas);
    end
    
end

