function Data_filt = filter_remove_wells_wo_depth(Data)
% function takes a Data structure, and returns a Data structure containing
% only wells which has depth information, and their corresponding
% measurements. Depth refers to overall well depth not perforations.

    fprintf('\nApplying filter_remove_wells_wo_depth.\n')
    fprintf('\tStarting with %i wells, %i measurements. \n', length(Data.WellData.site_code(:)),length(Data.MeasurementData.site_code(:)))

    logicalnan = ~isnan(Data.WellData.well_depth(:));
    Data_filt = filter_logical(Data,logicalnan,true(length(Data.MeasurementData.site_code(:)),1));
    Data_filt = remove_measurements_wo_wells(Data_filt);
    
    fprintf('\tEnded with %i wells, %i measurements. \n', length(Data_filt.WellData.site_code(:)),length(Data_filt.MeasurementData.site_code(:)))

    
end
