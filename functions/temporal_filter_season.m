function Data_filt = temporal_filter_season(Data,season)
% Filters returns Measurements and corresponding wells for a given season. Season accepts 'fall' or 'spring'; fall is Sept+Oct and spring
% is Feb+Mar+Apr. To Bill Brewster's (DWR) best recollection, they defined
% Spring as "early February to late May", so this approach is consistent
% with theirs. 

    months = month(Data.MeasurementData.date);
    if strcmp(season,'fall')
        measurementslogical = months == 9 | months == 10 | months == 11;
    elseif strcmp(season,'spring')
        measurementslogical = months == 2 | months == 3 | months == 4;
    end
    
    wellslogical = true([length(Data.WellData.site_code),1]); 
    
    Data_tmp = filter_logical(Data,wellslogical,measurementslogical);
    Data_filt = remove_wells_wo_measurements(Data_tmp);
end
