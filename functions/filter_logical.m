function Data_filt = filter_logical(Data,logical_well, logical_measurement)
% Returns a new Data structure given an existing data structure, a logical
% array for wells and a logical array for measurements. Perforation data is not filtered by this function, which has been superceeded in this respect by filter_logical_new (which I've not yet written...). 
% filter_logical is called during other filtering functions for
% compactness. NB logicals should be created with true() or false() rather
% than zeros() or ones().
    
    fields = fieldnames(Data.WellData);

    for i=1:length(fields)
        Data_filt.WellData.(fields{i}) = Data.WellData.(fields{i})(logical_well);
    end

%     Data_filt.WellData = struct('site_code',[],'well_depth',[],'latitude',[],'longitude',[]); % initiate new well data substructure    
%     
%     Data_filt.WellData.site_code = Data.WellData.site_code(logical_well);
%     Data_filt.WellData.well_depth = Data.WellData.well_depth(logical_well);
%     Data_filt.WellData.latitude = Data.WellData.latitude(logical_well);
%     Data_filt.WellData.longitude = Data.WellData.longitude(logical_well);

    fields = fieldnames(Data.MeasurementData);
    
    for i=1:length(fields)
        Data_filt.MeasurementData.(fields{i}) = Data.MeasurementData.(fields{i})(logical_measurement);
    end

%     Data_filt.MeasurementData.date = Data.MeasurementData.date(logical_measurement);
%     Data_filt.MeasurementData.ground_surface_elevation = Data.MeasurementData.ground_surface_elevation(logical_measurement);
%     Data_filt.MeasurementData.reference_point_elevation = Data.MeasurementData.reference_point_elevation(logical_measurement);
%     Data_filt.MeasurementData.ref_point_reading = Data.MeasurementData.ref_point_reading(logical_measurement);
%     Data_filt.MeasurementData.site_code = Data.MeasurementData.site_code(logical_measurement);

    fields = fieldnames(Data.PerfData);

    for i=1:length(fields)
        Data_filt.PerfData.(fields{i}) = Data.PerfData.(fields{i})(:);
    end

end
