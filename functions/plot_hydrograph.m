function fig = plot_hydrograph(Data,well_id)
% Plots a hydrograph for a given well specified by it's well_id. well_id
% refers to site_code in OpenData Periodic Groundwater Measurements and the Water Data Library, but is CASGEM
% id in the CASGEM dataset. well_id should be a character vector of form
% (for example) '361089N1194293W001'. Depth to water is calculated using
% the correct 'Matt' method.
    Data_filt = filter_by_siteid(Data,well_id);
%     [LIA, LOCB] = ismember(Data.MeasurementData.site_code(:),well_id);
% 
%     Data_filt = filter_logical(Data,true([length(Data.WellData.stn_id(:)) 1]), LIA);
% 
%     Data_filt = remove_wells_wo_measurements(Data_filt);

    DATA = [datenum(Data_filt.MeasurementData.date(:)), calc_water_levels(Data_filt,0)];
    DATA = sortrows(DATA,1);
    DATA(any(isnan(DATA),2),:) = [];
    
    plot(DATA(:,1),DATA(:,2),'ko-','MarkerFaceColor','black','DisplayName','hydrograph');
    set(gca,'ydir','reverse')
    xlabel('Date')
    ylabel('Depth to water (feet)')
    title(sprintf('Hydrograph for well id %s', well_id))
    datetick('x','mm/yyyy')

%     hold on
%     depth = get_welldepth_siteid(Data,well_id);
%     plot([min(DATA(:,1)) max(DATA(:,1))],[depth depth],'--','DisplayName','Reported well depth')
    
    legend()
end
