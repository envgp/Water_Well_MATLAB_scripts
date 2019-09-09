function Data_filt = spatial_filter_polygon(Data, polygon, varargin)
% Function takes a Data structure and a array of XY coordinates which form a
% polygon, then returns a clipped Data structure representing wells and
% measurements within the polygon. Polygon should contain vertices of
% polygon in format [LON LAT] where LON, LAT are column vectors. 
    
    % Check the polygon is specified in the right way, else exit with error
    % message.
    if isa(polygon,'char')
        if contains(polygon,'kml')
            fprintf("\tDetected you are trying to use a .kml polygon. It won't work!\n\tConsider instead using the function GIS_wells_from_polygon_kml.\n\tAborting!")
            return
        else
        fprintf("\tLooks like your polygon is not in the right input format.\n\t Polygon should contain vertices of polygon in format [LON LAT] where LON, LAT are column vectors.\n\tAborting!") 
        return
        end
    end
    
    if nargin == 3
        infolevel = varargin{1};
        fprintf('\nRunning data filt with info level = %i \n',infolevel)
    else
        infolevel=1;
    end

    lonPOLY = polygon(:,1);
    latPOLY = polygon(:,2);    
        
    listwells=find(inpolygon(Data.WellData.longitude,Data.WellData.latitude,lonPOLY,latPOLY)); % returns indices of wells within polygon
    
%     Data_filt.WellData = struct('site_code',[],'well_depth',[],'latitude',[],'longitude',[]); % initiate new well data substructure    
%     
%     Data_filt.WellData.site_code = Data.WellData.site_code(listwells);
%     Data_filt.WellData.well_depth = Data.WellData.well_depth(listwells);
%     Data_filt.WellData.latitude = Data.WellData.latitude(listwells);
%     Data_filt.WellData.longitude = Data.WellData.longitude(listwells);
    


    listmeasurements = find(ismember(Data.MeasurementData.stn_id,Data.WellData.stn_id(listwells)));
    
    Data_filt = filter_logical_new(Data,'WellData',listwells);
    
    if infolevel >= 2
        figure
        plot_wells(Data);
        hold on
        plot(lonPOLY,latPOLY);
        plot_wells(Data_filt);
        legend('Unfiltered data','Polygon','Filtered Data')
        title('Original wells, polygon outline, filtered wells')
        
        figure
        plot_measurements(Data);
        hold on
        plot(lonPOLY,latPOLY);
        plot_measurements(Data_filt);
        legend('Unfiltered data','Polygon','Filtered Data')
        title('Original measurements, polygon outline, filtered measurements') 
        
    end
    
end

