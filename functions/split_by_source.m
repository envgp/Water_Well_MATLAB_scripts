function [CASGEMdata, Nicelydata] = split_by_source(Data)
% CASGEMdata, Nicelydata = split_datastructure_by_source(Data)
%
% Takes a datastructure and returns two datastructures, corresponding to
% data from CASGEM and data from Nicely. Filters on wells, so will
% LOSE any measurements without corresponding wells.

% Split by Wells
logicalcasgem = ismember(Data.WellData.datasource,['CASGEM']);
logicalnicely = ismember(Data.WellData.datasource,['Nicely']);

CASGEMdata = filter_logical_new(Data,'WellData',logicalcasgem);
Nicelydata = filter_logical_new(Data,'WellData',logicalnicely);

% Split by Measurements
CASGEMdata = filter_logical_new(CASGEMdata,'MeasurementData',ismember(CASGEMdata.MeasurementData.datasource,['CASGEM']));
Nicelydata = filter_logical_new(Nicelydata,'MeasurementData',ismember(Nicelydata.MeasurementData.datasource,['Nicely']));