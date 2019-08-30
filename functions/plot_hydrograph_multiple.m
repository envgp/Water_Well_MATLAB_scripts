function fig = plot_hydrograph_multiple(Data)
% Superimposes all hydrographs for a Data structure.

    nowells = unique(Data.WellData.stn_id(:));
    figure
    hold on 
    
    for i=1:length(nowells)
        wellid = nowells(i);
        logical = ismember(Data.WellData.stn_id(:),wellid);
        datatemp = filter_logical(Data,logical,true([length(Data.MeasurementData.stn_id(:)),1]));
        datatemp = remove_measurements_wo_wells(datatemp);
        DATA = [datenum(datatemp.MeasurementData.date(:)), calc_water_levels(datatemp,0)];
        DATA = sortrows(DATA,1);
        DATA(any(isnan(DATA),2),:) = [];
    
        plot(DATA(:,1),DATA(:,2),'ko-','MarkerFaceColor','black','DisplayName','hydrograph');
        
    end
    
        set(gca,'ydir','reverse')
        xlabel('Date')
        ylabel('Depth to water (feet)')
        title(sprintf('Hydrographs for %s', inputname(1)))
        datetick('x','mm/yyyy')

end
