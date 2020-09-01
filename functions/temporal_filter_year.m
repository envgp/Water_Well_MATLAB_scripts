function Data_filt = temporal_filter_year(Data,YYYY)
% Filters returns Measurements and corresponding wells for a given year.
    cmd_called = getLastMATLABcommandLineStr();

    years = year(Data.MeasurementData.date);
    
    measurementslogical = years == YYYY;
    
    wellslogical = true([length(Data.WellData.site_code),1]); 
    
    Data_filt = filter_logical_new(Data,'MeasurementData',measurementslogical);
    Data_filt.History = Data_filt.History + newline + cmd_called;

    %Data_filt = remove_wells_wo_measurements(Data_tmp);
end
