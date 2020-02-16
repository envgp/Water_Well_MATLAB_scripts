function Data_filtered = filter_minimum_no_measurement_dates(Data,threshold)
    % Returns a data object containing only wells, measurements and
    % perforations with >=threshold number of measurements.
    %
    % This function assumes we have two types of wells. First, wells with a
    % CASGEM site_code; and secondly, those without a CASGEM site_code (and
    % therefore with a nicely site code). Wells with both site codes will go by
    % their CASGEM site_code.

    site_codes = unique((Data.MeasurementData.site_code));
    site_codes = site_codes(~cellfun(@isempty,site_codes));
    logical_site_codes = ~cellfun(@isempty,Data.MeasurementData.site_code);

    logical_keep = false(length(Data.MeasurementData.site_code),1);

    for i = 1:length(site_codes)
        logical_sitecode_tmp = ismember(Data.MeasurementData.site_code,site_codes{i});
        logical_msmts_nonan = ~isnan(Data.MeasurementData.Depth_To_Water(logical_sitecode_tmp));
        nomsmtdates = length(unique(Data.MeasurementData.date(logical_msmts_nonan)));
        if nomsmtdates >= threshold
            logical_keep(logical_sitecode_tmp) = true();
        end
    end

%     nicely_codes_all = Data.MeasurementData.nicely_site_code;
%     logical_rest = ~logical_site_codes & ~cellfun(@isempty,nicely_codes_all); % A logical for the 'rest', meaning measurements without a casgem site code but with a nicely one.
% 
%     nicely_codes_rest_unique = unique(Data.MeasurementData.nicely_site_code(logical_rest)); % These are the nicely site codes to loop over.
%     
%     for i = 1:length(nicely_codes_rest_unique)
%         logical_nicely_sitecode_tmp = ismember(Data.MeasurementData.nicely_site_code,nicely_codes_rest_unique{i});
%         nomsmts = sum(~isnan(Data.MeasurementData.Depth_To_Water(logical_nicely_sitecode_tmp)));
% 
%         if nomsmts >= threshold
%             logical_keep(logical_nicely_sitecode_tmp) = true();
%         end
%     end

    Data_filtered = filter_logical_new(Data,'MeasurementData',logical_keep);
    
end