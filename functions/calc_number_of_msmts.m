function [stn_id, number_msmts] = calc_number_of_msmts(Data)

% no_msmts = calc_number_of_msmts(Data) returns a new instance of Data,
% where the well data now has a new field called 'number of measurements'
% which reportst the number of non-NAN measurements reported for that well.

fprintf('Calculating number of non-NAN measurements each well has.\n')

depth_withdup = calc_water_levels(Data,0); % Calculate the depth to water

[~,wellrefs] = ismember(Data.MeasurementData.stn_id(:),Data.WellData.stn_id(:)); % get the indices of WellData corresponding to each Measurement
if find(~wellrefs)
    fprintf('FLAG: Caution! Measurements found with stn_id not present in WellData. Has something gone wrong? /n')
end
stn_ids = Data.WellData.stn_id(wellrefs); % Get the list of stn ids..
number_msmts = zeros('like',stn_ids); % initiate number_msmts

if length(stn_ids) > 50000
    fprintf('\tNumber of measurements = %i; may take some time.\n',length(stn_ids)) 

[~, ind] = unique(stn_ids); % get index of unique wells
duplicate_ind = setdiff(1:length(depth_withdup), ind); % get indices of repeated wells

idlast=0; % just a flag variable
indicestokeep=[]; % initiate list of indices to keep

depth = depth_withdup; %

for i = 1:length(ind) 
    if floor(i/2000)==i/2000
        fprintf('\tBookkeeping: on station %i of %i.\n', i,length(ind))        
    end
    id = stn_ids(ind(i));
    Lia = ismember(id,stn_ids(:));
    idx = find(Lia);
    repidx = find(bsxfun(@eq,id(idx),stn_ids(:))); % finds indices of other instances of the same stn id
%     if idlast~=id
%         fprintf('\tStn id %.0f found to have %i measurements.\n', id,length(repidx));
%     end
    number_msmts(repidx(1)) = length(repidx);
    indicestokeep=[indicestokeep repidx(1)];
end

indicestokeep = unique(indicestokeep);

stn_id = stn_ids(indicestokeep);
number_msmts = number_msmts(indicestokeep)';
fprintf('\tDONE.\n')
end