function Data_filt = temporal_filter_yearrange(Data,STARTYYYY,ENDYYYY)
% Data_filt = temporal_filter_yearrange(Data,STARTYYYY,ENDYYYY)
% Filters returns Measurements and corresponding wells for a given year.
    
    fprintf('\nRunning temporal_filter_yearrange\n')
    fprintf('\tStarting with %s containing %i wells and %i measurements.\n',inputname(1),length(Data.WellData.stn_id(:)),length(Data.MeasurementData.stn_id(:)))
    
    fprintf('\tFiltering between years %i and %i.\n', STARTYYYY,ENDYYYY)
    
    years = year(Data.MeasurementData.date);
    
    measurementslogical = (STARTYYYY <= years & years <= ENDYYYY);
    
    wellslogical = true([length(Data.WellData.site_code),1]); 
    
    Data_tmp = filter_logical(Data,wellslogical,measurementslogical);
    Data_filt = remove_wells_wo_measurements(Data_tmp);
    
    fprintf('\tFinished with %i wells and %i measurements.\n',length(Data_filt.WellData.stn_id(:)),length(Data_filt.MeasurementData.stn_id(:)))

end
