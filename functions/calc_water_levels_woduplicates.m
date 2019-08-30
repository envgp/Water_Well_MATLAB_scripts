function [x y depth stn_id site_code] = calc_water_levels_woduplicates(Data,method)
% [x y depth stn_id site_code] = calc_water_levels_woduplicates(Data,method) returns
% positions and depth to water for wells within Data, removing wells with
% duplicate measurements according to method. Sofar, method can only be
% 'average', where wells with two measurements are replaced by the average
% of the two measurements.

fprintf('Calculating water levels. This function takes the mean of water levels for any wells with multiple measurements.\n')

depth_withdup = calc_water_levels(Data,0); % Calculate the depth to water

[~,wellrefs] = ismember(Data.MeasurementData.stn_id(:),Data.WellData.stn_id(:)); % get the indices of WellData corresponding to each Measurement
if find(~wellrefs)
    fprintf('FLAG: Caution! Measurements found with stn_id not present in WellData. Has something gone wrong? /n')
end
x = Data.WellData.longitude(wellrefs); % Get longitudes corresponding to each Measurement
y = Data.WellData.latitude(wellrefs); % Get latitudes corresponding to each Measurement
stn_ids = Data.WellData.stn_id(wellrefs); % Get the list of stn ids..
site_code = Data.WellData.site_code(wellrefs); % Get the list of site codes
well_depth = Data.WellData.well_depth(wellrefs);

[~, ind] = unique(stn_ids); % get index of unique wells
duplicate_ind = setdiff(1:length(depth_withdup), ind); % get indices of repeated wells

idlast=0; % just a flag variable
indicestokeep=[]; % initiate list of indices to keep

depth = depth_withdup; %

for i = 1:length(ind) 
    id = stn_ids(ind(i));
    Lia = ismember(id,stn_ids(:));
    idx = find(Lia);
    repidx = find(bsxfun(@eq,id(idx),stn_ids(:))); % finds indices of other instances of the same stn id
    if idlast~=id
        fprintf('\tStn id %.0f found to have %i measurements. Taking average. \n', id,length(repidx));
    end
    tmpdepths = depth_withdup(repidx);
    avgdepth = mean(tmpdepths,'omitnan'); % calculate the mean depth
    depth(repidx(1)) = avgdepth; % put the mean depth in the first instance of the well
    indicestokeep=[indicestokeep repidx(1)];
    idlast = id;
end

indicestokeep = unique(indicestokeep);

depth = depth(indicestokeep);
stn_id = stn_ids(indicestokeep);
x = x(indicestokeep);
y = y(indicestokeep);

end