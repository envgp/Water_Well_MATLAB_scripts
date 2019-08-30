function Data_new = GIS_wells_from_polygon_kml(Data,kmlfile)

% Data_new = GIS_well_from_kml(Data,kmlfile)
% 
% Function takes a Data structure and kmlfile defining a polygon, and
% returns a new Data structure corresponding to wells, measurements and
% perforations only within that polygon.

    fprintf('\nRunning GIS_wells_from_polygon_kml\n')
    fprintf('\tStarting with %s containing %i wells and %i measurements.\n',inputname(1),length(Data.WellData.stn_id(:)),length(Data.MeasurementData.stn_id(:)))

    KML = GIS_kml2struct(kmlfile);

    fprintf('\tFiltering with the following kml file: "%s".\n',kmlfile)

    lat = KML.Lat(:);
    lon = KML.Lon(:);

    Data_new = spatial_filter_polygon(Data,[lon,lat]);
    
    fprintf('\tFinished with %i wells and %i measurements.\n',length(Data_new.WellData.stn_id(:)),length(Data_new.MeasurementData.stn_id(:)))
    
end
