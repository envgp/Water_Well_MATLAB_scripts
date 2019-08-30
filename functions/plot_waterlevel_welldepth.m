function c = plot_waterlevel_welldepth(Data)
% Function plots the water level against well depth. Currently calculates
% water level using a 'Matt' scheme, as opposed to a 'Ryan' scheme. This
% function automatically removes wells without associated depth. One
% 'complication' of this function is its ability to handle wells with more
% than one measurement.

    Data = filter_remove_wells_wo_depth(Data);

    if length(Data.MeasurementData.site_code(:)) ~= length(unique(Data.MeasurementData.site_code(:)))
%         fprintf('Some wells have multiple measurements; padding measurement data with well depth.\n')
        waterlvl = calc_water_levels(Data,0);
        [LIA, LOCB] = ismember(Data.MeasurementData.site_code(:),Data.WellData.site_code(:));
        welldepth = Data.WellData.well_depth(LOCB);
    else
        waterlvl = calc_water_levels(Data,0);
        welldepth = Data.WellData.well_depth(:);        
    end
    
    date = datenum(Data.MeasurementData.date(:));

    scatter(welldepth,waterlvl,25,date,'filled','MarkerEdgeColor','black')
    c=colorbar('EastOutside');  % Note you can change position 
    c.TickLabels = datestr(c.Ticks,"mmm 'yy"); 
    c.Label.String = 'Date of measurement';
    hold on
    x = 0:1:round(max([max(welldepth) max(waterlvl)]));
    y = 0:1:round(max([max(welldepth) max(waterlvl)]));
    plot(x,y)
    xlabel('Well depth (ft below ground surface)')
    ylabel('Depth to water (ft below ground surface)')
    title(sprintf('%s', inputname(1)))
    
end