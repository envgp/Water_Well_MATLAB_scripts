function depth = get_welldepth_siteid(Data,well_id)
% Function takes a Data structure, and a well_id, and returns the depth of
% the well. well_id refers to site_code in OpenData Periodic Groundwater Measurements and the Water Data Library, but is CASGEM
% id in the CASGEM dataset. well_id should be a character vector of form
% (for example) '361089N1194293W001'

    Data_filt = filter_by_siteid(Data,well_id);
    
    depth = Data_filt.WellData.well_depth(1);
end
