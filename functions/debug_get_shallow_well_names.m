function names = debug_get_shallow_well_names(Data)
% debug function which takes a Data structure and returns a list of
% well_ids for wells with water depths deeper than the reported well depth.

    % get water and well depths    
    waterlvl = calc_water_levels(Data,0);
    [LIA, LOCB] = ismember(Data.MeasurementData.site_code(:),Data.WellData.site_code(:));
    welldepth = Data.WellData.well_depth(LOCB);

    tmp = waterlvl>welldepth;

    names = Data.MeasurementData.site_code(tmp);
    names = unique(names);

end