function Data_filt = remove_measurements_wo_wells(Data)
% Sometimes you will have measurements which correspond to wells which you
% have no information about. This function deletes all measurement data which
% does not have a corresponding well.

    listmeasurement_withwells = ismember(Data.MeasurementData.site_code,Data.WellData.site_code) | ismember(Data.MeasurementData.nicely_site_code,Data.WellData.nicely_site_code); % Create a list of logicals showing which index in measurements contain a Well .
    
     % Manually set wells with no entry for site code/nicely entry to 0.
    listmeasurement_withwells(Data.MeasurementData.site_code=="") = 0;
    listmeasurement_withwells(Data.MeasurementData.nicely_site_code=="") = 0;

    %listwells = true([length(Data.WellData.site_code),1]); % there are no redundant wells in this script...

    Data_filt = filter_logical_new(Data,'MeasurementData',listmeasurement_withwells);
end
