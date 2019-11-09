function Data_filt = filter_by_stnid(Data, stn_id)
% Takes a Data structure and a stn_id, and returns a Data structure
% corresponding to just that site_id. Currently only works for a single
% stn_id.  stn_id refers to stn_id in OpenData Periodic Groundwater Measurements and the Water Data Library, but is CASGEM
% id in the CASGEM dataset and CRNA St_ID in Tim Nicely Data. stn_id should
% be an integer eg 35124.

    LIA = ismember(Data.WellData.stn_id(:),stn_id);

    Data_filt = filter_logical_new(Data,'WellData', LIA);
end