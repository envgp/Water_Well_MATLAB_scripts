function Data_filt = filter_by_nicely_site_code(Data, nicelycode)
% Data_filt = filter_by_nicely_site_code(Data, nicelycode)
% Takes a Data structure and a nicely site code, and returns a Data structure
% corresponding to just that site_id. Currently only works for a single
% site code. The site code should be 'KSB-XXXX'.

    LIA = ismember(Data.WellData.nicely_site_code(:),nicelycode);

    Data_filt = filter_logical_new(Data,'WellData', LIA);

end