function [x y depth stn_id site_code] = calc_water_levels_woduplicates(Data,method,varargin)
% [x y depth stn_id site_code] = calc_water_levels_woduplicates(Data,method) returns
% positions and depth to water for wells within Data, removing wells with
% duplicate measurements according to method. Sofar, method can only be
% 'average', where wells with two measurements are replaced by the average
% of the two measurements.
%
% When using multisource data, the site_code and stn_id are not correctly
% returned for Nicely wells!

if length(varargin)>0
    if sum(strcmpi('silent',varargin))
        fprintf('Silent mode!\n')
        silent=true();
    else
        silent=false();
    end
    if sum(strcmpi('multisource',varargin))
        fprintf('Multi source version.\n')
        multisource=true();
    else
        multisource=false();
    end
end

fprintf('Calculating water levels. This function takes the mean of water levels for any wells with multiple measurements.\n')

CASGEMS = ismember(Data.WellData.datasource,'CASGEM');
NICELYS = ismember(Data.WellData.datasource,'Nicely');
%fprintf('\tFound %i measurements from CASGEM and %i from Tim Nicely.',sum(CASGEMS),sum(NICELYS))

if multisource
    [CasgemData,Nicelydata] = split_by_source(Data);
    Data = CasgemData;
end

% Start doing CASGEM data

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
        if silent==false()
            fprintf('\tStn id %.0f found to have %i measurements. Taking average. \n', id,length(repidx));
        end
    end
    tmpdepths = depth_withdup(repidx);
    avgdepth = mean(tmpdepths,'omitnan'); % calculate the mean depth
    depth(repidx(1)) = avgdepth; % put the mean depth in the first instance of the well
    indicestokeep=[indicestokeep repidx(1)];
    idlast = id;
end

indicestokeep = unique(indicestokeep);

depthcasgem = depth(indicestokeep);
stn_id = stn_ids(indicestokeep);
x = x(indicestokeep);
y = y(indicestokeep);

depth = depthcasgem;

if multisource
    % Now do Nicely data 
    depth_withdup = Nicelydata.MeasurementData.ground_surface_elevation - Nicelydata.MeasurementData.water_surface_elevation; % Calculate the depth to water

    [~,wellrefs] = ismember(Nicelydata.MeasurementData.nicely_site_code(:),Nicelydata.WellData.nicely_site_code(:)); % get the indices of WellData corresponding to each Measurement
    if find(~wellrefs)
        fprintf('FLAG: Caution! Measurements found with nicely_site_code not present in WellData. Has something gone wrong? \n')
    end
    xnicely = Nicelydata.WellData.longitude(wellrefs); % Get longitudes corresponding to each Measurement
    ynicely = Nicelydata.WellData.latitude(wellrefs); % Get latitudes corresponding to each Measurement
    stn_idsnicely = Nicelydata.WellData.nicely_site_code(wellrefs); % Get the list of stn ids..

    [~, ind] = unique(stn_idsnicely); % get index of unique wells
    duplicate_ind = setdiff(1:length(depth_withdup), ind); % get indices of repeated wells

    idlast=0; % just a flag variable
    indicestokeep=[]; % initiate list of indices to keep

    depth = depth_withdup; %
    idlast={''};
    for i = 1:length(ind) 
        id = stn_idsnicely(ind(i));
        %Lia = ismember(id,stn_idsnicely(:));
        %idx = find(Lia);
        %repidx = find(bsxfun(@eq,id(idx),stn_idsnicely(:))); % finds indices of other instances of the same stn id
        %[~,rep1] = ismember(stn_idsnicely,stn_idsnicely(idx));
        %[~,~,repidx] = find(rep1); % get exclusively the indices of other intsances of the same stn idea
        repidx = find(strcmp(stn_idsnicely,stn_idsnicely(ind(i)))); % find index of other instances of the same nicely id
        if ~strcmp(idlast,id)
            if silent==false()
                fprintf('\tStn id %s found to have %i measurements. Taking average. \n', id{:},length(repidx));
            end
        end
        tmpdepths = depth_withdup(repidx);
        avgdepth = mean(tmpdepths,'omitnan'); % calculate the mean depth
        depth(repidx(1)) = avgdepth; % put the mean depth in the first instance of the well
        indicestokeep=[indicestokeep repidx(1)];
        idlast = id;
    end

    indicestokeep = unique(indicestokeep);

    depthnicely = depth(indicestokeep);
    stn_idnicely = stn_idsnicely(indicestokeep);
    xnicely = xnicely(indicestokeep);
    ynicely = ynicely(indicestokeep);
    
    xout = [x;xnicely];
    x = xout;
    yout = [y;ynicely];
    y = yout;
    depthout = [depthcasgem;depthnicely];
    depth= depthout;
    
    stn_idout = string([stn_id;stn_idnicely]); % this is 'wrong' but who cares right now.
    stn_id = stn_idout;
end



end