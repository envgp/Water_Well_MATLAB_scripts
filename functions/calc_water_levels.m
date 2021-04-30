function [depth,Data_New] = calc_water_levels(Data,ryan,varargin)
% depth = calc_water_levels(Data,ryan)
% Calculates depth to water level for a given Data structure. When ryan=0,
% this works for both CASGEM and Nicely data.
% If ryan is true, we don't use 'Water Level Reading' in calculating depth; if ryan is false, we do. To
% read a litte about this, have a look at
% https://data.cnra.ca.gov/dataset/periodic-groundwater-level-measurements/resource/bfa9f262-24a1-45bd-8dc8-138bc8107266
% where it says, about RDNG_WS, 'Reading on the measurement device at water
% surface. Typically 0 for electric tape. Generally used for steel tape
% measurements, however typically is not 0.'. 
%
% OPTIONAL ARGUMENTS:
%
% If 'NewDataInstance' is present we return a new data instance with a field 'Depth_To_Water'. 
    cmd_called = getLastMATLABcommandLineStr();


    if length(varargin)>0
        if strcmpi(varargin{1},'NewDataInstance')
            fprintf('\tNewDataInstance flag detected. Will return depths and a new Data object with new field MeasurementData.Depth_To_Water.\n')
            NewDataInstance=true();
        end
    else
        NewDataInstance=false();
        Data_New=0;
    end



    depth = nan(length(Data.MeasurementData.date),1);

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
        CASGEMS = ismember(Data.MeasurementData.datasource,'CASGEM');
        NICELYS = ismember(Data.MeasurementData.datasource,'Nicely');
        %fprintf('\tFound %i measurements from CASGEM and %i from Tim Nicely. Calculating depths to water for both.',sum(CASGEMS),sum(NICELYS))
        %depth(CASGEMS) = Data.MeasurementData.ground_surface_elevation(CASGEMS) - Data.MeasurementData.reference_point_elevation(CASGEMS) + Data.MeasurementData.ref_point_reading(CASGEMS) - Data.MeasurementData.water_surface_reading(CASGEMS);
        depth(CASGEMS) = Data.MeasurementData.Depth_To_Water(CASGEMS);
        depth(NICELYS) = Data.MeasurementData.ground_surface_elevation(NICELYS) - Data.MeasurementData.water_surface_elevation(NICELYS);
    end
    
    if NewDataInstance
        Data_New = Data;
        Data_New.MeasurementData.Depth_To_Water = depth;
        Data_New.History = Data.History + newline + cmd_called;
    end
end