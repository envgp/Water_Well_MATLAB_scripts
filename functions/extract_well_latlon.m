function Data_filt = extract_well_latlon(Data,lat,lon)
% Finds the nearest well to a given latitude/longitude. If two wells are
% coincident, it fails and just returns the first one to occur in
% Data.WellData. Note this doesn't strictly calculate distance in
% ground-units, but in lat-lon units, so is pretty inaccurate.
fprintf('Finding closest well to (%f %f).\n',lon,lat')
vector = [Data.WellData.latitude, Data.WellData.longitude];
dist = vector - [lat,lon];
A = vecnorm(dist,2,2);
[mindist,idx] = min(A);
fprintf('\tClosest well to given lat/lon is %i or %s.\n',Data.WellData.stn_id(idx),Data.WellData.nicely_site_code{idx})
logical_well = A==mindist;

Data_filt = filter_logical_new(Data,'WellData',logical_well);

end