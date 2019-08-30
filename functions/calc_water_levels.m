function depth = calc_water_levels(Data,ryan)
% Calculates depth to water level for a given Data structure. If ryan
% is true, we don't use 'Water Level Reading' in calculating depth; if ryan is false, we do. To
% read a litte about this, have a look at
% https://data.cnra.ca.gov/dataset/periodic-groundwater-level-measurements/resource/bfa9f262-24a1-45bd-8dc8-138bc8107266
% where it says, about RDNG_WS, 'Reading on the measurement device at water
% surface. Typically 0 for electric tape. Generally used for steel tape
% measurements, however typically is not 0.'. 

    if ryan==1
%         noNans = sum(isnan(Data.MeasurementData.water_surface_reading(:)));
%         noTot = length(Data.MeasurementData.water_surface_reading(:));
% %         fprintf('\n %i out of %i data have "NaN" for water_surface_reading. You are assuming these are zero.\n', [noNans noTot])
        depth = Data.MeasurementData.ground_surface_elevation - Data.MeasurementData.reference_point_elevation + Data.MeasurementData.ref_point_reading;
    end
    
    if ryan==0
%         noNans = sum(isnan(Data.MeasurementData.water_surface_reading(:)));
%         noTot = length(Data.MeasurementData.water_surface_reading(:));
% %         fprintf('\n %i out of %i data have "NaN" for water_surface_reading. You are removing NaNs.\n', [noNans noTot])
%         NaNs = ~isnan(Data.MeasurementData.water_surface_reading(:));
        depth = Data.MeasurementData.ground_surface_elevation - Data.MeasurementData.reference_point_elevation + Data.MeasurementData.ref_point_reading - Data.MeasurementData.water_surface_reading;
    end
    
end