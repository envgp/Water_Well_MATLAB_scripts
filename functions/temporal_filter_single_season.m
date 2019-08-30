function Data_filt = temporal_filter_season(Data,season)
% Filters returns Measurements and corresponding wells for a given season. Season accepts 'fall' or 'spring'; fall is Sept+Oct and spring
% is Feb+Mar+Apr.

    months = month(Data.MeasurementData.date);
    if strcmp(season,'fall')
        measurementslogical = months == 9 & 10;
    elseif strcmp(season,'spring')
        measurementslogical = months == 1 | 2 | 3 | 4 | 5;
    end
    
    wellslogical = true([length(Data.WellData.site_code),1]); 
    
    Data_filt = filter_logical(Data,wellslogical,measurementslogical);
end
