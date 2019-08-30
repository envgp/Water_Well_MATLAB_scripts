function fig = plot_compare_histograms(Data1,Data2)
% Function takes two Data structures, and finds the wells contained within
% both. Then, plots a histogram showing water levels in these wells for
% both datasets (most likely Data1 and Data2 represent the same region at a
% different time).
%     fprintf('\nApplying filter_intersection_datasets.\n')
%     fprintf('\tStarting with Data1 = %i wells, %i measurements; Data2 = %i wells, %i measurements. \n', length(Data1.WellData.site_code(:)),length(Data1.MeasurementData.site_code(:)),length(Data2.WellData.site_code(:)),length(Data2.MeasurementData.site_code(:)))
% 
%     sites = intersect(Data1.WellData.stn_id(:),Data2.WellData.stn_id(:));
% 
%     LIA1 = ismember(Data1.WellData.stn_id(:),sites);
%     LIA2 = ismember(Data2.WellData.stn_id(:),sites);
% 
%     Data1 = filter_logical(Data1,LIA1,true([length(Data1.MeasurementData.stn_id(:)) 1]));
%     Data2 = filter_logical(Data2,LIA2,true([length(Data2.MeasurementData.stn_id(:)) 1]));
% 
%     Data1 = remove_measurements_wo_wells(Data1);
%     Data2 = remove_measurements_wo_wells(Data2);
% 
%     fprintf('\tEnded with Data1 = %i wells, %i measurements; Data2 = %i wells, %i measurements. \n', length(Data1.WellData.site_code(:)),length(Data1.MeasurementData.site_code(:)),length(Data2.WellData.site_code(:)),length(Data2.MeasurementData.site_code(:)))
    [Data1,Data2] = filter_intersections_datasets(Data1,Data2);
    
    figure
    subplot(2,1,1)
    plot_histogram_waterlevels(Data1,0);
    set(gca,'fontsize',16)
    title(sprintf('%s', inputname(1)))
    subplot(2,1,2)
    plot_histogram_waterlevels(Data2,0);
    title(sprintf('%s', inputname(2)))
    set(gca,'fontsize',16)
end