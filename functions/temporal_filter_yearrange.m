function Data_filt = temporal_filter_yearrange(Data,STARTYYYY,ENDYYYY)
% Data_filt = temporal_filter_yearrange(Data,STARTYYYY,ENDYYYY)
% Filters returns Measurements and corresponding wells for a given year.
    cmd_called = getLastMATLABcommandLineStr();

    fprintf('\nRunning temporal_filter_yearrange\n')
    fprintf('\tStarting with %s containing %i wells and %i measurements.\n',inputname(1),length(Data.WellData.site_code(:)),length(Data.MeasurementData.site_code(:)))
    
    fprintf('\tFiltering between years %i and %i.\n', STARTYYYY,ENDYYYY)
    
    years = year(Data.MeasurementData.date);
    
    measurementslogical = (STARTYYYY <= years & years <= ENDYYYY);
    
    %wellslogical = true([length(Data.WellData.site_code),1]); 
    
    Data_tmp = filter_logical_new(Data,'MeasurementData',measurementslogical);
    Data_filt = remove_wells_wo_measurements(Data_tmp);
    
    Data_filt.History = Data.History + newline + cmd_called;
    fprintf('\tFinished with %i wells and %i measurements.\n',length(Data_filt.WellData.site_code(:)),length(Data_filt.MeasurementData.site_code(:)))

end
