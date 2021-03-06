function Data_new = GIS_wells_from_polygon_kml(Data,kmlfile)

% Data_new = GIS_well_from_kml(Data,kmlfile)
% 
% Function takes a Data structure and kmlfile defining a polygon, and
% returns a new Data structure corresponding to wells, measurements and
% perforations only within that polygon.
    cmd_called = getLastMATLABcommandLineStr();

    fprintf('\nRunning GIS_wells_from_polygon_kml\n')
    fprintf('\tStarting with %s containing %i wells and %i measurements.\n',inputname(1),length(Data.WellData.site_code(:)),length(Data.MeasurementData.site_code(:)))

    KML = GIS_kml2struct(kmlfile);

    fprintf('\tFiltering with the following kml file: "%s".\n',kmlfile)

    lat = KML.Lat(:);
    lon = KML.Lon(:);

    Data_new = spatial_filter_polygon(Data,[lon,lat]);
    Data_new.History = Data_new.History + newline + cmd_called;
    
    fprintf('\tFinished with %i wells and %i measurements.\n',length(Data_new.WellData.site_code(:)),length(Data_new.MeasurementData.site_code(:)))
    
end
