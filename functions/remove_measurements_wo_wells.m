function Data_filt = remove_measurements_wo_wells(Data)
% Sometimes you will have measurements which correspond to wells which you
% have no information about. This function deletes all measurement data which
% does not have a corresponding well.

    listmeasurement_withwells = ismember(Data.MeasurementData.site_code,Data.WellData.site_code); % Create a list of logicals showing which index in measurements contain a Well .
    
    listwells = true([length(Data.WellData.site_code),1]); % there are no redundant wells in this script...

    Data_filt = filter_logical(Data,listwells,listmeasurement_withwells);
end
