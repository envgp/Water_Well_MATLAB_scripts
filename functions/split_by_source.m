function [CASGEMdata, Nicelydata] = split_by_source(Data)
% CASGEMdata, Nicelydata = split_datastructure_by_source(Data)
%
% Takes a datastructure and returns two datastructures, corresponding to
% data from CASGEM and data from Nicely. Filters on measurement, so will
% LOSE any wells without corresponding measurements.

logicalcasgem = ismember(Data.MeasurementData.datasource,['CASGEM']);
logicalnicely = ismember(Data.MeasurementData.datasource,['Nicely']);

CASGEMdata = filter_logical_new(Data,'MeasurementData',logicalcasgem);
Nicelydata = filter_logical_new(Data,'MeasurementData',logicalnicely);