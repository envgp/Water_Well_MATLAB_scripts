function Data_filt = temporal_filter_year(Data,YYYY)
% Filters returns Measurements and corresponding wells for a given year.

    years = year(Data.MeasurementData.date);
    
    measurementslogical = years == YYYY;
    
    wellslogical = true([length(Data.WellData.site_code),1]); 
    
    Data_tmp = filter_logical(Data,wellslogical,measurementslogical);
    Data_filt = remove_wells_wo_measurements(Data_tmp);
end
