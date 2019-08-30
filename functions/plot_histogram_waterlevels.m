function fig = plot_histogram_waterlevels(Data,ryan)
% Plots a histogram of the depth to water level for Data; ryan
% corresponds to the calc_water_level function, see it's doc for details.

%     depth = Data.MeasurementData.ground_surface_elevation - Data.MeasurementData.reference_point_elevation + Data.MeasurementData.ref_point_reading;
    depth = calc_water_levels(Data,ryan);
    fig = histogram(depth,20);
    xlabel('Depth to water (feet)')
    ylabel('No of wells')
    title(sprintf('%s', inputname(1)))
    set(gca,'fontsize',14)

end
