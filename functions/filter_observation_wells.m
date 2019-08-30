function Data_filt = filter_observation_wells(Data)
% Takes a Data structure and returns a structure Data_filt corresponding to only wells marked as 'observation'.

    position = ismember(Data.WellData.well_use(:),'Observation');
    fprintf('\nApplying filter_observation_wells.\n')
    fprintf('\tStarting with %s = %i wells, %i measurements.\n',inputname(1),length(Data.WellData.well_use(:)),length(Data.MeasurementData.date(:)))
    Data_filt = filter_logical(Data,position,true([length(Data.MeasurementData.site_code(:)) 1]));
    Data_filt = remove_measurements_wo_wells(Data_filt);
    fprintf('\tEnded with %i wells, %i measurements.\n',length(Data_filt.WellData.well_use(:)),length(Data_filt.MeasurementData.date(:)))

    
end
