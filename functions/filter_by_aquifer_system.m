function Data_filt = filter_by_aquifer_system(Data,aquifer_sys)
% Data_filt = filter_by_aquifer_system(Data,aquifer sys)
%
% Returns a new, filtered data structure where only wells and measurements
% from the specific aquifer system are returned. Aquifer system can be
% 'LAS', 'UAS' or 'SAS'. Note this automatically restricts us to only
% Nicely wells. 

fprintf("Filtering by aquifer system '%s'. \n", aquifer_sys)
fprintf("\tStarting with %i wells and %i measurements.\n", length(Data.WellData.site_code), length(Data.MeasurementData.site_code));

temp = contains(Data.WellData.aquifer, aquifer_sys);

Data_filt = filter_logical_new(Data,'WellData',temp);
fprintf("\tDone. Returned new data instance with %i wells and %i measurements.\n", length(Data_filt.WellData.site_code), length(Data_filt.MeasurementData.site_code))
end