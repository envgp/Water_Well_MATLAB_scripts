function Data2 = remove_NAN_measurements(Data)
% takes a Data structure and returns a Data structure with measurements
% (and corresponding wells) containing NaN values missing. Typically, the
% physical reason these measurements exist is that the measuring person has
% gone along to the well, found it pumping/broken/otherwise inaccessible,
% and recorded 'NONE' in the database.
    fprintf('\nApplying remove_NAN_measurements.\n')
    fprintf('\tStarting with %s = %i wells, %i measurements.\n',inputname(1),length(Data.WellData.well_use(:)),length(Data.MeasurementData.date(:)))
    NaNs = ~isnan(Data.MeasurementData.water_surface_reading(:));
    fprintf('\tFound %i NaN measurements.\n', sum(~NaNs))
    Data2 = filter_logical(Data,true([length(Data.WellData.stn_id(:)) 1]), NaNs);
    Data2 = remove_wells_wo_measurements(Data2);
    fprintf('\tEnding with Data2 = %i wells, %i measurements.\n',length(Data2.WellData.well_use(:)),length(Data2.MeasurementData.date(:)))
end