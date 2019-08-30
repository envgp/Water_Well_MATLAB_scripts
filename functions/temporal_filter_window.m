function Data_filt = temporal_filter_window(Data,season,YYYY)
% Filters returns Measurements and corresponding wells for a given season
% and year. Season accepts 'fall' or 'spring'; fall is Sept+Oct and spring
% is Feb+Mar+Apr.

    months = month(Data.MeasurementData.date);
    if season=='fall'
        measurementslogical = months == 9 & 10;
    elif season=='spring'
        measurementslogical = months == 2 & 3 & 4;
    end
    
    wellslogical = true([length(Data.WellData.site_code),1]); 
    
    Data_filt = filter_logical(Data,wellslogical,measurementslogical)
end
