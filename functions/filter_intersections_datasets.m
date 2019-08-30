function [Data1_filt, Data2_filt] = filter_intersections_datasets(Data1,Data2)
% Takes two data structures Data1 and Data2, and returns Data1_filt and
% Data2_filt which contain only wells common to both datasets.

    fprintf('\nApplying filter_intersection_datasets.\n')
    fprintf('\tStarting with Data1 = %i wells, %i measurements; Data2 = %i wells, %i measurements. \n', length(Data1.WellData.site_code(:)),length(Data1.MeasurementData.site_code(:)),length(Data2.WellData.site_code(:)),length(Data2.MeasurementData.site_code(:)))

    sites = intersect(Data1.WellData.stn_id(:),Data2.WellData.stn_id(:));

    LIA1 = ismember(Data1.WellData.stn_id(:),sites);
    LIA2 = ismember(Data2.WellData.stn_id(:),sites);

    Data1_filt = filter_logical(Data1,LIA1,true([length(Data1.MeasurementData.stn_id(:)) 1]));
    Data2_filt = filter_logical(Data2,LIA2,true([length(Data2.MeasurementData.stn_id(:)) 1]));

    Data1_filt = remove_measurements_wo_wells(Data1_filt);
    Data2_filt = remove_measurements_wo_wells(Data2_filt);

    fprintf('\tEnded with Data1 = %i wells, %i measurements; Data2 = %i wells, %i measurements. \n', length(Data1_filt.WellData.site_code(:)),length(Data1_filt.MeasurementData.site_code(:)),length(Data2_filt.WellData.site_code(:)),length(Data2_filt.MeasurementData.site_code(:)))
end

