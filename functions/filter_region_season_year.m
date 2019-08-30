function Data_filt = filter_region_season_year(Data,polygon,season,YYYY)
% Takes a well data instance, a polygon [LON LAT], season 'fall' or
% 'spring' and a year YYYY and returns a filtered data corresponding to
% those parameters.

    dat1 = spatial_filter_polygon(Data,polygon,1);
    dat2 = temporal_filter_year(dat1,YYYY);
    Data_filt = temporal_filter_season(dat2,season);
    
end
