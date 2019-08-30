function fig = plot_measurements(Data)
% Plots the locations of measurements for given data. Currently a basic plot just
% for a sanity check.
    Data = remove_measurements_wo_wells(Data); % this is required if Data contains measurements which don't have a corresponding well. I should make the code print something to say this is happening....
    [LIA, LOCB] = ismember(Data.MeasurementData.site_code,Data.WellData.site_code);
    lon = Data.WellData.longitude(LOCB);
    lat = Data.WellData.latitude(LOCB);
    
    fig = scatter(lon,lat);
end

     