function Data_filt = filter_by_siteid(Data, well_id)
% Data_filt = filter_by_siteid(Data, well_id)
% Takes a Data structure and a site_id, and returns a Data structure
% corresponding to just that site_id. Currently only works for a single
% well_id.  well_id refers to site_code in OpenData Periodic Groundwater Measurements and the Water Data Library, but is CASGEM
% id in the CASGEM dataset. well_id should be a character vector of form
% (for example) '361089N1194293W001'.
    cmd_called = getLastMATLABcommandLineStr();

    LIA = ismember(Data.WellData.site_code(:),well_id);

    Data_filt = filter_logical_new(Data,'WellData', LIA);
    Data_filt.History = Data_filt.History + newline + cmd_called;

end