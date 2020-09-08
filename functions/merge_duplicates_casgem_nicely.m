function Data_merged = merge_duplicates_casgem_nicely(Data,varargin)
% A "merge duplicates" function. It should now work but I haven't tested it
% extensively...
%
%
% LEGACY: how it works/plan:
% For wells: if it is from 'nicely', then I want to check if it has a CASGEM site number. If so, I want to:
%    - check if the CASGEM site code OR CASGEM stn id exists as a separate entry in the same data structure
%    - if so, copy across the nicely well info (eg, aquifer, is_cc, etc) into the CASGEM version
%    - delete the nicely version from the dataset and replace data source with 'casgem+nicely'
%    - then, sort out MEASUREMENTS: [
%        - for this, I think I need to check first why there are
%        differences in the measurements for CASGEM and Nicely.
if length(varargin)>0

    if strcmpi(varargin{1},'mergeradius')
        fprintf('\tmergeradius flag detected. This flag should be a pair, so the following varargin needs to be your preferred mergeradius.\n')
        mergeradius=varargin{2};
        fprintf('\tmergeradius set to be %.2f m.', mergeradius)
    else
        mergeradius=100;
        fprintf('\tmergeradius set to be %.2f m.', mergeradius)
    end
else
    mergeradius=100;
    fprintf('\tmergeradius set to be %.2f m.', mergeradius)
end


cmd_called = getLastMATLABcommandLineStr();

[CasgemData, Nicelydata] = split_by_source(Data,'silent');

% Get a list of CASGEM stn ids and sitecodes from with Nicely data.
Nicely_CASGEM_stnids = Nicelydata.WellData.stn_id(~isnan(Nicelydata.WellData.stn_id));
Nicely_CASGEM_sitecodes_idxs = zeros(length(Nicelydata.WellData.site_code),1);

for i = 1:length(Nicelydata.WellData.site_code)
    Nicely_CASGEM_sitecodes_logical(i) =  ~isempty(Nicelydata.WellData.site_code{i});
end

Nicely_CASGEM_sitecodes_idxs = find(Nicely_CASGEM_sitecodes_logical);
Nicely_CASGEM_sitecodes = Nicelydata.WellData.site_code(Nicely_CASGEM_sitecodes_idxs);

% Loop through the stn_ids and copy Nicely information across. Update
% Datasource to 'Nicely and CASGEM (merged)'.

for i = 1:length(Nicely_CASGEM_stnids)
    logical_CASGEM = ismember(CasgemData.WellData.stn_id,Nicely_CASGEM_stnids(i));
    if sum(logical_CASGEM > 1)
        fprintf('\tUh oh. Multiple wells found with the same stn id. Skipping stn id %i.\n', Nicely_CASGEM_stnids(i));
    else
        idx_casgem = find(logical_CASGEM);
        idx_nicely = find(ismember(Nicelydata.WellData.stn_id,Nicely_CASGEM_stnids(i)));
        
        % Now, copy across the Nicely specific info to the CASGEM data. 

        CasgemData.WellData.datasource(idx_casgem) = "CASGEM and Nicely (merged)";
        CasgemData.WellData.is_cclay(idx_casgem) = Nicelydata.WellData.is_cclay(idx_nicely);
        CasgemData.WellData.aquifer(idx_casgem) = Nicelydata.WellData.aquifer(idx_nicely);
        CasgemData.WellData.nicely_site_code(idx_casgem) = Nicelydata.WellData.nicely_site_code(idx_nicely);
    end
end



% Now loop through the site codes and copy Nicely information across. Update
% Datasource to 'Nicely and CASGEM (merged)'. Can be sped up because I
% probably did a number of these in the stn_ids and am now just overwriting
% them.

for i = 1:length(Nicely_CASGEM_sitecodes)
    logical_CASGEM = ismember(CasgemData.WellData.site_code,Nicely_CASGEM_sitecodes(i));
    if sum(logical_CASGEM > 1)
        fprintf('\tUh oh. Multiple wells found with the same stn id. Skipping stn id %s.\n', Nicely_CASGEM_sitecodes{i});
    else
        idx_casgem = find(logical_CASGEM);
        idx_nicely = find(ismember(Nicelydata.WellData.site_code,Nicely_CASGEM_sitecodes(i)));
        
        % Now, copy across the Nicely specific info to the CASGEM data. 

        CasgemData.WellData.datasource(idx_casgem) = "CASGEM and Nicely (merged on name)";
        CasgemData.WellData.is_cclay(idx_casgem) = Nicelydata.WellData.is_cclay(idx_nicely);
        CasgemData.WellData.aquifer(idx_casgem) = Nicelydata.WellData.aquifer(idx_nicely);
        CasgemData.WellData.nicely_site_code(idx_casgem) = Nicelydata.WellData.nicely_site_code(idx_nicely);
    end
end

[nicely_logical_stnid,~] = ismember(Nicelydata.WellData.stn_id,Nicely_CASGEM_stnids);
Nicelys_for_removal = Nicely_CASGEM_sitecodes_logical | nicely_logical_stnid';

% Remove the nicely data which has been copied into CASGEMdata, before re-merging nicely_new with CasgemData.
Nicelydata_new = filter_logical_new(Nicelydata,'WellData',~Nicelys_for_removal,'silent','literal');
Data_merged = merge_datastructures(CasgemData,Nicelydata_new);

% Now have a go at merging wells with very very close geographic
% coordinates 

fprintf('\tMerging wells which are %.2f m apart. This could accidentally merge distinct wells.', mergeradius)

CASGEM_Wells_names = Data_merged.WellData.stn_id(Data_merged.WellData.datasource == "CASGEM");

Nicely_names = Data_merged.WellData.nicely_site_code(Data_merged.WellData.datasource == "Nicely");
Nicely_longitudes = Data_merged.WellData.longitude(Data_merged.WellData.datasource == "Nicely");
Nicely_latitudes = Data_merged.WellData.latitude(Data_merged.WellData.datasource == "Nicely");
Nicely_vector = [Nicely_longitudes,Nicely_latitudes];
Nicely_names = Nicely_names(~isnan(Nicely_vector(:,1))); % Makes names the right length for use below (the same length as the distances vectors will be)
Nicely_vector = Nicely_vector(~isnan(Nicely_vector(:,1)),:);

nicely_codes_for_merging = {};

for i = 1:length(CASGEM_Wells_names)
    casgem_logical = Data_merged.WellData.stn_id==CASGEM_Wells_names(i);
    welllat = Data_merged.WellData.latitude(casgem_logical);
    welllon = Data_merged.WellData.longitude(casgem_logical);
    delta_latlon = Nicely_vector - [welllon, welllat];
    distances = vecnorm(Nicely_vector - [welllon, welllat],2,2);
    [closest_distance,closest_distance_idx] = min(distances);
    
    if closest_distance <= 8*10^(-4) * mergeradius/100 % this gives approx 100m
        fprintf('\tFound one! Wells %i and %s are the same. Copying Nicely info over.\n', CASGEM_Wells_names(i),Nicely_names{closest_distance_idx})
        idx_nicely = find(strcmp(Data_merged.WellData.nicely_site_code,Nicely_names{closest_distance_idx}));
        idx_casgem = find(Data_merged.WellData.stn_id==CASGEM_Wells_names(i));
        Data_merged.WellData.datasource(idx_casgem) = "CASGEM and Nicely (merged on proximity)";
        Data_merged.WellData.is_cclay{idx_casgem} = Data_merged.WellData.is_cclay{idx_nicely};
        Data_merged.WellData.aquifer{idx_casgem} = Data_merged.WellData.aquifer{idx_nicely};
        Data_merged.WellData.nicely_site_code{idx_casgem} = Data_merged.WellData.nicely_site_code{idx_nicely};
        nicely_codes_for_merging{end+1} = Nicely_names{closest_distance_idx};
    end
end

% Remove the nicely data which has been copied into CASGEMdata.
nicelys_for_removal = contains(Data_merged.WellData.nicely_site_code,nicely_codes_for_merging) & Data_merged.WellData.datasource=='Nicely';
Data_merged = filter_logical_new(Data_merged,'WellData',~nicelys_for_removal,'silent','literal');

    
    

% Now get a list of 'casgem and nicely' well Nicely site codes

logical_nicelycasgem = Data_merged.WellData.datasource == 'CASGEM and Nicely (merged)';
duplicate_nicely_site_codes = Data_merged.WellData.nicely_site_code(logical_nicelycasgem);
duplicate_site_codes = Data_merged.WellData.site_code(logical_nicelycasgem);

% Now loop over each of these site codes, and for each one, find the
% nicely measurements and copy them across to the CASGEM well. 

for i = 1:length(duplicate_nicely_site_codes)
    nicelysitecode = duplicate_nicely_site_codes{i};
    sitecode = duplicate_site_codes{i};
    
    logical_nicelymeasurements = Data_merged.MeasurementData.nicely_site_code == nicelysitecode;
    corresponding_sitecodes = Data_merged.MeasurementData.site_code(logical_nicelymeasurements);
    if sum(cellfun(@isempty,corresponding_sitecodes))>0
        % Find the actual sitecode from the well
        fprintf('Copying casgem site codes to measurements from nicely well %s. \n', nicelysitecode)
        well_logical = Data_merged.WellData.nicely_site_code == nicelysitecode;
        site_code_to_add = Data_merged.WellData.site_code{well_logical};
        Data_merged.MeasurementData.site_code(logical_nicelymeasurements) = repmat({site_code_to_add},sum(logical_nicelymeasurements),1);
    end
end
%     dates=
%     Data.MeasurementData.date = tmp.MSMT_DATE;
%     Data.MeasurementData.ground_surface_elevation = str2double(tmp.GSE_DEM); % Take the DEM reported GSE; note that sometimes this isn't the same as the 'reported' one. Some NaNs appear doing this as some of the GSE have 'null' as their value.
% Data.MeasurementData.water_surface_elevation = tmp.WSE;
% A = strings(length(tmp.MSMT_DATE),1);
% A(:) = "Nicely";
% Data.MeasurementData.datasource = A;
% Data.MeasurementData.nicely_site_code = tmp.KSB_ID;

Data_merged.History = Data.History + newline + cmd_called;
    
end